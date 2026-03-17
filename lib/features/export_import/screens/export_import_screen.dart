// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/export_import_service.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/repositories/session_repository.dart';

class ExportImportScreen extends ConsumerStatefulWidget {
  const ExportImportScreen({super.key});

  @override
  ConsumerState<ExportImportScreen> createState() => _ExportImportScreenState();
}

class _ExportImportScreenState extends ConsumerState<ExportImportScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _includeSessions = true;
  ExportFormat _selectedFormat = ExportFormat.json;

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

      switch (_selectedFormat) {
        case ExportFormat.json:
          content = await _exportService.exportToJson(
            includeSessions: _includeSessions,
          );
          filename = 'field_book_$timestamp.json';
          mimeType = 'application/json';
          break;

        case ExportFormat.csv:
          content = await _exportService.exportToCsv();
          filename = 'field_book_$timestamp.csv';
          mimeType = 'text/csv';
          break;

        case ExportFormat.darwinCore:
          content = await _exportService.exportToDarwinCore();
          filename = 'field_book_darwin_core_$timestamp.csv';
          mimeType = 'text/csv';
          break;
      }

      await _exportService.saveAndShareExport(content, filename, mimeType);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exportação concluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao importar: $e'),
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

  void _showImportResultDialog(ImportResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.hasErrors ? Icons.warning : Icons.check_circle,
              color: result.hasErrors ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            const Text('Resultado da Importação'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResultRow('Importados', result.imported, Colors.green),
              _buildResultRow('Atualizados', result.updated, Colors.blue),
              if (result.skipped > 0)
                _buildResultRow('Ignorados', result.skipped, Colors.orange),
              if (result.errors.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Erros:',
                  style: TextStyle(
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
      ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar & Importar'),
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
                      Icon(Icons.upload, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Exportar Dados',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Exporte suas plantas para backup ou compartilhamento',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  // Format selection
                  const Text(
                    'Formato:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  ListTile(
                    title: const Text('JSON'),
                    subtitle: const Text('Formato completo com todos os dados'),
                    leading: Radio<ExportFormat>(
                      value: ExportFormat.json,
                      groupValue: _selectedFormat,
                      onChanged: (value) {
                        setState(() => _selectedFormat = value!);
                      },
                    ),
                    onTap: () => setState(() => _selectedFormat = ExportFormat.json),
                  ),
                  
                  ListTile(
                    title: const Text('CSV'),
                    subtitle: const Text('Planilha simples (Excel, LibreOffice)'),
                    leading: Radio<ExportFormat>(
                      value: ExportFormat.csv,
                      groupValue: _selectedFormat,
                      onChanged: (value) {
                        setState(() => _selectedFormat = value!);
                      },
                    ),
                    onTap: () => setState(() => _selectedFormat = ExportFormat.csv),
                  ),
                  
                  ListTile(
                    title: const Text('Darwin Core'),
                    subtitle: const Text('Padrão internacional para biodiversidade'),
                    leading: Radio<ExportFormat>(
                      value: ExportFormat.darwinCore,
                      groupValue: _selectedFormat,
                      onChanged: (value) {
                        setState(() => _selectedFormat = value!);
                      },
                    ),
                    onTap: () => setState(() => _selectedFormat = ExportFormat.darwinCore),
                  ),
                  
                  // Options
                  if (_selectedFormat == ExportFormat.json)
                    CheckboxListTile(
                      title: const Text('Incluir sessões de coleta'),
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
                      label: Text(_isExporting ? 'Exportando...' : 'Exportar'),
                    ),
                  ),
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
                      Icon(Icons.download, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Importar Dados',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Importe plantas de um arquivo JSON exportado',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Plantas existentes serão atualizadas. Apenas arquivos JSON são suportados.',
                            style: TextStyle(fontSize: 12),
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
                      label: Text(_isImporting ? 'Importando...' : 'Selecionar Arquivo'),
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
                      Icon(Icons.help_outline, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Sobre os Formatos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFormatInfo(
                    'JSON',
                    'Formato completo que preserva todos os dados incluindo fotos, '
                    'áudios, medições e metadados. Ideal para backup e restauração completa.',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildFormatInfo(
                    'CSV',
                    'Formato de planilha simples que pode ser aberto no Excel, '
                    'LibreOffice ou Google Sheets. Contém apenas dados básicos.',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildFormatInfo(
                    'Darwin Core',
                    'Padrão internacional para dados de biodiversidade. '
                    'Compatível com portais científicos como GBIF e iNaturalist.',
                  ),
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
