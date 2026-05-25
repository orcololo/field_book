import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/repositories/label_template_repository.dart';
import '../../../core/repositories/plant_repository.dart';
import '../../../core/services/herbarium_label_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/collection_session.dart';
import '../../../models/label_template.dart';
import '../../../models/plant_record.dart';

/// Batch herbarium-label preparation flow ("Preparar Exsicatas").
///
/// Lists every plant record in [session], lets the user multi-select records
/// and pick a [LabelTemplate], then exports a single PDF containing all
/// chosen labels following the template's grid + field toggles.
class PrepareExsiccataeScreen extends ConsumerStatefulWidget {
  final CollectionSession session;

  const PrepareExsiccataeScreen({super.key, required this.session});

  @override
  ConsumerState<PrepareExsiccataeScreen> createState() =>
      _PrepareExsiccataeScreenState();
}

class _PrepareExsiccataeScreenState
    extends ConsumerState<PrepareExsiccataeScreen> {
  List<PlantRecord> _records = [];
  List<LabelTemplate> _templates = [];
  final Set<String> _selectedUuids = <String>{};
  LabelTemplate? _selectedTemplate;
  bool _loading = true;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final templateRepo = ref.read(labelTemplateRepositoryProvider);
    final plantRepo = ref.read(plantRepositoryProvider);

    // Make sure built-ins exist (idempotent). Localized names come from the
    // current l10n context.
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      await templateRepo.seedBuiltIns(
        standardName: l10n.labelTemplateStandard,
        compactName: l10n.labelTemplateCompact,
        largeName: l10n.labelTemplateLarge,
      );
    }

    final templates = await templateRepo.getAll();
    final records = await plantRepo.getBySession(widget.session.uuid);

    if (!mounted) return;
    setState(() {
      _templates = templates;
      _selectedTemplate = templates.isNotEmpty ? templates.first : null;
      _records = records;
      _selectedUuids
        ..clear()
        ..addAll(records.map((r) => r.uuid));
      _loading = false;
    });
  }

  void _toggleAll() {
    setState(() {
      if (_selectedUuids.length == _records.length) {
        _selectedUuids.clear();
      } else {
        _selectedUuids
          ..clear()
          ..addAll(_records.map((r) => r.uuid));
      }
    });
  }

  Future<void> _generatePdf() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final template = _selectedTemplate;
    if (template == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.selectTemplate)));
      return;
    }
    final chosen = _records
        .where((r) => _selectedUuids.contains(r.uuid))
        .toList(growable: false);
    if (chosen.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.noRecordsToExport)));
      return;
    }
    setState(() => _generating = true);

    final service = HerbariumLabelService(
      strings: HerbariumLabelStrings(
        appTitle: l10n.appTitle,
        title: l10n.herbariumLabelTitle,
        family: l10n.family,
        collector: l10n.collector,
        collectionDate: l10n.collectionDate,
        locality: l10n.locality,
        gpsCoordinates: l10n.gpsCoordinates,
        altitude: l10n.altitude,
        habitat: l10n.habitat,
        morphologicalNotes: l10n.morphologicalNotes,
        notes: l10n.notes,
        root: l10n.root,
        stem: l10n.stem,
        leaf: l10n.leaf,
        flower: l10n.flower,
        fruit: l10n.fruitLabel,
        seed: l10n.seedLabel,
        notSpecified: l10n.notSpecified,
      ),
    );

    try {
      await Printing.layoutPdf(
        name:
            'exsiccatae_${widget.session.tripName.replaceAll(RegExp(r'\s+'), '_')}.pdf',
        onLayout: (_) => service.generateLabels(chosen, template),
      );
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.errorExportingLabelPdf(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.prepareExsiccatae)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? Center(child: Text(l10n.noRecordsToExport))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<LabelTemplate>(
                            initialValue: _selectedTemplate,
                            decoration: InputDecoration(
                              labelText: l10n.selectTemplate,
                              border: const OutlineInputBorder(),
                            ),
                            items: _templates
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      '${t.name}  ·  ${t.labelsPerPage}/pg',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => _selectedTemplate = value),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                l10n.selectedCount(
                                  _selectedUuids.length,
                                  _records.length,
                                ),
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: _toggleAll,
                                icon: const Icon(Icons.select_all),
                                label: Text(
                                  _selectedUuids.length == _records.length
                                      ? l10n.deselectAll
                                      : l10n.selectAll,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _records.length,
                        itemBuilder: (context, index) {
                          final record = _records[index];
                          final selected =
                              _selectedUuids.contains(record.uuid);
                          return CheckboxListTile(
                            value: selected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedUuids.add(record.uuid);
                                } else {
                                  _selectedUuids.remove(record.uuid);
                                }
                              });
                            },
                            title: Text(
                              record.scientificName,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            subtitle: Text(
                              [
                                record.registryIdentifier,
                                record.family,
                                record.locality,
                              ].whereType<String>().where((s) => s.isNotEmpty)
                                  .join(' · '),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: _loading || _records.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _generating ? null : _generatePdf,
              icon: _generating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(l10n.generatePdf),
            ),
    );
  }
}
