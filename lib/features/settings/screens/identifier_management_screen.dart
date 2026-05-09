import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/services/registry_identifier_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/services/identifier_export_import_service.dart';
import '../../../models/plant_record.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/modern/modern_app_bar.dart';
import '../../plant_detail/screens/plant_detail_screen.dart';

class IdentifierManagementScreen extends ConsumerStatefulWidget {
  const IdentifierManagementScreen({super.key});

  @override
  ConsumerState<IdentifierManagementScreen> createState() =>
      _IdentifierManagementScreenState();
}

class _IdentifierManagementScreenState
    extends ConsumerState<IdentifierManagementScreen> {
  static final _log = Logger(printer: PrettyPrinter(methodCount: 0));
  List<PlantRecord> _plantsWithoutIdentifiers = [];
  final Set<int> _selectedPlantIds = {};
  bool _isLoading = true;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    _loadPlantsWithoutIdentifiers();
  }

  Future<void> _loadPlantsWithoutIdentifiers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final plantRepo = ref.read(plantRepositoryProvider);
      final plants = await plantRepo.getPlantsWithoutIdentifier();

      setState(() {
        _plantsWithoutIdentifiers = plants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingPlants2(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showAssignmentPreview() async {
    final selectedPlants = _plantsWithoutIdentifiers
        .where((p) => _selectedPlantIds.contains(p.id))
        .toList();

    if (selectedPlants.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectAtLeastOnePlant),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final plantRepo = ref.read(plantRepositoryProvider);
    final identifierService = RegistryIdentifierService(
      plantRepository: plantRepo,
    );
    final settings = await ref.read(settingsNotifierProvider.future);

    // Generate preview identifiers
    final previews = <String>[];
    int nextNumber = settings.lastRegistryNumber + 1;

    for (int i = 0; i < selectedPlants.length; i++) {
      try {
        final identifier = identifierService.formatIdentifier(
          settings.userInitials,
          nextNumber + i,
        );
        previews.add(identifier);
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorGeneratingPreview(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    // Show confirmation dialog
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Text(l10n.confirmAssignTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.confirmAssignBody(selectedPlants.length),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedPlants.length,
                  itemBuilder: (context, index) {
                    final plant = selectedPlants[index];
                    final identifier = previews[index];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        plant.scientificName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Text(
                        identifier,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta operação não pode ser desfeita.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirmAssignTitle),
          ),
        ],
      );
      },
    );

    if (confirmed == true) {
      await _assignIdentifiers(selectedPlants);
    }
  }

  Future<void> _assignIdentifiers(List<PlantRecord> plants) async {
    setState(() {
      _isAssigning = true;
    });

    try {
      final plantRepo = ref.read(plantRepositoryProvider);
      final identifierService = RegistryIdentifierService(
        plantRepository: plantRepo,
      );
      int successCount = 0;

      for (final plant in plants) {
        try {
          final identifier = await identifierService.generateNextIdentifier();
          plant.registryIdentifier = identifier;
          
          final plantRepo = ref.read(plantRepositoryProvider);
          await plantRepo.save(plant);
          
          successCount++;
        } catch (e) {
          _log.e('Error assigning identifier to plant ${plant.id}', error: e);
          // Continue with next plant
        }
      }

      setState(() {
        _isAssigning = false;
        _selectedPlantIds.clear();
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.identifiersAssigned(successCount)),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Reload list
      await _loadPlantsWithoutIdentifiers();
    } catch (e) {
      setState(() {
        _isAssigning = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorAssigningIdentifiers(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showExportDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final format = await showDialog<IdentifierExportFormat>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Text(l10n.exportIdentifiersTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(l10n.exportFormatJson),
              subtitle: Text(l10n.exportFormatJsonSubtitle),
              onTap: () => Navigator.pop(context, IdentifierExportFormat.json),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(l10n.exportFormatCsv),
              subtitle: Text(l10n.exportFormatCsvSubtitle),
              onTap: () => Navigator.pop(context, IdentifierExportFormat.csv),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(l10n.exportFormatExcel),
              subtitle: Text(l10n.exportFormatExcelSubtitle),
              onTap: () => Navigator.pop(context, IdentifierExportFormat.xlsx),
            ),
          ],
        ),
      );
      },
    );

    if (format == null) return;

    try {
      final plantRepo = ref.read(plantRepositoryProvider);
      final exportService = IdentifierExportImportService(plantRepo);

      File? file;
      switch (format) {
        case IdentifierExportFormat.json:
          file = await exportService.exportToJson();
          break;
        case IdentifierExportFormat.csv:
          file = await exportService.exportToCsv();
          break;
        case IdentifierExportFormat.xlsx:
          file = await exportService.exportToExcel();
          break;
      }

      if (mounted) {
        await exportService.shareExport(file);
        
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.exportCompletedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.errorExporting(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performImport() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final plantRepo = ref.read(plantRepositoryProvider);
      final importService = IdentifierExportImportService(plantRepo);

      final result = await importService.pickAndImport();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.detailedMessage),
            backgroundColor: result.success ? Colors.green : Colors.red,
          ),
        );

        if (result.success) {
          // Reload the list
          await _loadPlantsWithoutIdentifiers();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorImporting2(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ModernAppBar(
        title: l10n.manageIdentifiersTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: l10n.import,
            onPressed: _performImport,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: l10n.exportIdentifiers,
            onPressed: _showExportDialog,
          ),
          if (_selectedPlantIds.isNotEmpty)
            TextButton.icon(
              onPressed: _isAssigning ? null : _showAssignmentPreview,
              icon: Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary),
              label: Text(
                '${_selectedPlantIds.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 64,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _plantsWithoutIdentifiers.isEmpty
                    ? _buildEmptyState()
                    : _buildPlantList(),
          ),
        ],
      ),
      floatingActionButton: _selectedPlantIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isAssigning ? null : _showAssignmentPreview,
              icon: const Icon(Icons.assignment_turned_in),
              label: Text(l10n.assignIdentifiers(_selectedPlantIds.length)),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.allPlantsHaveIdentifiers,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noPlantsWithoutIdentifiers,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantList() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Header with count and select all
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              Checkbox(
                value: _selectedPlantIds.length ==
                    _plantsWithoutIdentifiers.length,
                tristate: _selectedPlantIds.isNotEmpty &&
                    _selectedPlantIds.length !=
                        _plantsWithoutIdentifiers.length,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedPlantIds.addAll(
                        _plantsWithoutIdentifiers.map((p) => p.id),
                      );
                    } else {
                      _selectedPlantIds.clear();
                    }
                  });
                },
              ),
              Expanded(
                child: Text(
                  l10n.plantsWithoutIdentifier(_plantsWithoutIdentifiers.length),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        // Plant list
        Expanded(
          child: ListView.builder(
            itemCount: _plantsWithoutIdentifiers.length,
            itemBuilder: (context, index) {
              final plant = _plantsWithoutIdentifiers[index];
              final isSelected = _selectedPlantIds.contains(plant.id);

              return CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedPlantIds.add(plant.id);
                    } else {
                      _selectedPlantIds.remove(plant.id);
                    }
                  });
                },
                title: Text(
                  plant.scientificName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plant.commonName.isNotEmpty)
                      Text(
                        plant.commonName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      l10n.collectedOn('${plant.dateCollected.day}/${plant.dateCollected.month}/${plant.dateCollected.year}'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                secondary: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlantDetailScreen(plant: plant),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
