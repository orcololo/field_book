import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/export_import_service.dart';
import '../../../core/services/inaturalist_service.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/repositories/session_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/plant_record.dart';
import '../../settings/screens/inaturalist_auth_screen.dart';

class ExportImportScreen extends ConsumerStatefulWidget {
  final List<PlantRecord>? preSelectedPlants;
  const ExportImportScreen({super.key, this.preSelectedPlants});

  @override
  ConsumerState<ExportImportScreen> createState() => _ExportImportScreenState();
}

class _ExportImportScreenState extends ConsumerState<ExportImportScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _isPushingToInaturalist = false;
  bool _includeSessions = true;
  ExportFormat _selectedFormat = ExportFormat.json;
  int _inatProgressCurrent = 0;
  int _inatProgressTotal = 0;

  late final ExportImportService _exportService;

  @override
  void initState() {
    super.initState();
    _exportService = ExportImportService(
      ref.read(plantRepositoryProvider),
      ref.read(sessionRepositoryProvider),
    );
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      String content;
      String filename;
      String mimeType;

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final plants = widget.preSelectedPlants;

      switch (_selectedFormat) {
        case ExportFormat.json:
          content = await _exportService.exportToJson(
            plants: plants,
            includeSessions: _includeSessions,
          );
          filename = 'field_book_$timestamp.json';
          mimeType = 'application/json';
          break;

        case ExportFormat.csv:
          content = await _exportService.exportToCsv(plants: plants);
          filename = 'field_book_$timestamp.csv';
          mimeType = 'text/csv';
          break;

        case ExportFormat.darwinCore:
          content = await _exportService.exportToDarwinCore(plants: plants);
          filename = 'field_book_darwin_core_$timestamp.csv';
          mimeType = 'text/csv';
          break;
      }

      await _exportService.saveAndShareExport(content, filename, mimeType);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportSuccessMsg),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorExportMsg(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _handleImport() async {
    setState(() => _isImporting = true);

    try {
      final result = await _exportService.pickAndImportFile();

      if (result != null && mounted) {
        _showImportResultDialog(result);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorImportMsg(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  Future<void> _handleInaturalistPush() async {
    final l10n = AppLocalizations.of(context)!;
    final service = ref.read(inaturalistServiceProvider);
    final hasToken = await service.hasToken();

    if (!hasToken) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.inaturalistRequiresToken)),
      );
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const InaturalistAuthScreen()),
      );
      return;
    }

    final plants = await _resolvePlantsForInaturalist();
    if (plants.isEmpty) return;

    setState(() {
      _isPushingToInaturalist = true;
      _inatProgressCurrent = 0;
      _inatProgressTotal = plants.length;
    });

    try {
      final sent = await service.bulkPush(
        plants,
        onProgress: (current, total) {
          if (!mounted) return;
          setState(() {
            _inatProgressCurrent = current;
            _inatProgressTotal = total;
          });
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.inaturalistBulkSuccess(sent.length))),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.inaturalistPushError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPushingToInaturalist = false;
          _inatProgressCurrent = 0;
          _inatProgressTotal = 0;
        });
      }
    }
  }

  Future<List<PlantRecord>> _resolvePlantsForInaturalist() async {
    if (widget.preSelectedPlants != null) {
      return widget.preSelectedPlants!;
    }

    return ref.read(plantRepositoryProvider).getPaginated(limit: 100000);
  }

  void _showImportResultDialog(ImportResult result) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Row(
          children: [
            Icon(
              result.hasErrors ? Icons.warning : Icons.check_circle,
              color: result.hasErrors ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            Text(l10n.importResultTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResultRow(l10n.importedLabel, result.imported, Colors.green),
              _buildResultRow(l10n.updatedLabel, result.updated, Colors.blue),
              if (result.skipped > 0)
                _buildResultRow(l10n.skippedLabel, result.skipped, Colors.orange),
              if (result.errors.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.errorsLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.errors.map((error) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $error',
                    style: const TextStyle(fontSize: 12),
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
      },
    );
  }

  Widget _buildResultRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exportImportTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Export Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.upload, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.exportData,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.exportBackupHint,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (widget.preSelectedPlants != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list, color: Colors.blue, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            l10n.exportingNPlants(widget.preSelectedPlants!.length),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  
                  // Format selection
                  Text(
                    l10n.formatLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  RadioGroup<ExportFormat>(
                    groupValue: _selectedFormat,
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedFormat = value);
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('JSON'),
                          subtitle: Text(l10n.jsonFormatSubtitle),
                          leading: const Radio<ExportFormat>(
                            value: ExportFormat.json,
                          ),
                          onTap: () => setState(() => _selectedFormat = ExportFormat.json),
                        ),
                        ListTile(
                          title: const Text('CSV'),
                          subtitle: Text(l10n.csvFormatSubtitle),
                          leading: const Radio<ExportFormat>(
                            value: ExportFormat.csv,
                          ),
                          onTap: () => setState(() => _selectedFormat = ExportFormat.csv),
                        ),
                        ListTile(
                          title: const Text('Darwin Core'),
                          subtitle: Text(l10n.darwinCoreFormatSubtitle),
                          leading: const Radio<ExportFormat>(
                            value: ExportFormat.darwinCore,
                          ),
                          onTap: () => setState(() => _selectedFormat = ExportFormat.darwinCore),
                        ),
                      ],
                    ),
                  ),
                  
                  // Options
                  if (_selectedFormat == ExportFormat.json)
                    CheckboxListTile(
                      title: Text(l10n.includeCollectionSessions),
                      value: _includeSessions,
                      onChanged: (value) {
                        setState(() => _includeSessions = value ?? true);
                      },
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Export button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isExporting ? null : _handleExport,
                      icon: _isExporting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_file),
                      label: Text(_isExporting ? l10n.exporting : l10n.export),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isPushingToInaturalist
                          ? null
                          : _handleInaturalistPush,
                      icon: _isPushingToInaturalist
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.outbox_outlined),
                      label: Text(
                        _isPushingToInaturalist
                            ? l10n.inaturalistProgress(
                                _inatProgressCurrent,
                                _inatProgressTotal,
                              )
                            : l10n.sendSelectedToInaturalist,
                      ),
                    ),
                  ),
                  if (_isPushingToInaturalist && _inatProgressTotal > 0) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _inatProgressCurrent / _inatProgressTotal,
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Import Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.download, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.importData,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.importFromJson,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.importWarnMsg,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Import button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isImporting ? null : _handleImport,
                      icon: _isImporting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.file_open),
                      label: Text(_isImporting ? l10n.importing : l10n.selectFile),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.aboutFormats,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFormatInfo('JSON', l10n.jsonFormatDesc),
                  const SizedBox(height: 12),
                  _buildFormatInfo('CSV', l10n.csvFormatDesc),
                  const SizedBox(height: 12),
                  _buildFormatInfo('Darwin Core', l10n.darwinCoreDesc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatInfo(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
