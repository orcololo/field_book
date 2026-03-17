import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/services/registry_identifier_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/services/identifier_export_import_service.dart';
import '../../../models/plant_record.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar plantas: $e'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos uma planta'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao gerar prévia: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Atribuição'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Serão atribuídos identificadores a ${selectedPlants.length} planta(s):',
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
                  color: Colors.blue.shade50,
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
                          color: Colors.blue.shade900,
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
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Atribuídos $successCount identificador(es) com sucesso',
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atribuir identificadores: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showExportDialog() async {
    final format = await showDialog<IdentifierExportFormat>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar Identificadores'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON'),
              subtitle: const Text('Formato estruturado, completo'),
              onTap: () => Navigator.pop(context, IdentifierExportFormat.json),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              subtitle: const Text('Planilha simples, compatível'),
              onTap: () => Navigator.pop(context, IdentifierExportFormat.csv),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Excel'),
              subtitle: const Text('Planilha Excel com formatação'),
              onTap: () => Navigator.pop(context, IdentifierExportFormat.xlsx),
            ),
          ],
        ),
      ),
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exportação concluída'),
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
    }
  }

  Future<void> _performImport() async {
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
            content: Text('Erro na importação: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Identificadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Importar',
            onPressed: _performImport,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar',
            onPressed: _showExportDialog,
          ),
          if (_selectedPlantIds.isNotEmpty)
            TextButton.icon(
              onPressed: _isAssigning ? null : _showAssignmentPreview,
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text(
                '${_selectedPlantIds.length}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _plantsWithoutIdentifiers.isEmpty
              ? _buildEmptyState()
              : _buildPlantList(),
      floatingActionButton: _selectedPlantIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isAssigning ? null : _showAssignmentPreview,
              icon: const Icon(Icons.assignment_turned_in),
              label: Text('Atribuir (${_selectedPlantIds.length})'),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
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
            const Text(
              'Todas as plantas possuem identificadores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Não há plantas sem identificadores no momento.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantList() {
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
                  '${_plantsWithoutIdentifiers.length} planta(s) sem identificador',
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
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plant.commonName.isNotEmpty)
                      Text(plant.commonName),
                    Text(
                      'Coletado em: ${plant.dateCollected.day}/${plant.dateCollected.month}/${plant.dateCollected.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
