import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/repositories/template_repository.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../core/utils/biome_detector.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/collection_template.dart';

const _uuid = Uuid();

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  bool _isLoading = true;
  List<CollectionTemplate> _templates = const [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
    });

    final repository = ref.read(templateRepositoryProvider);
    final templates = await repository.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _templates = templates;
      _isLoading = false;
    });
  }

  Future<void> _openTemplateDialog({CollectionTemplate? template}) async {
    final draft = template == null
        ? (CollectionTemplate()
          ..uuid = _uuid.v4()
          ..name = ''
          ..biome = BiomeDetector.cerrado
          ..isBuiltIn = false)
        : (CollectionTemplate()
          ..id = template.id
          ..uuid = template.uuid
          ..name = template.name
          ..biome = template.biome
          ..isBuiltIn = template.isBuiltIn
          ..habitatTemplate = template.habitatTemplate
          ..vegetationTypeTemplate = template.vegetationTypeTemplate
          ..topographyTemplate = template.topographyTemplate
          ..substrateTemplate = template.substrateTemplate
          ..notesTemplate = template.notesTemplate);

    final result = await showDialog<CollectionTemplate>(
      context: context,
      builder: (context) => _TemplateFormDialog(template: draft),
    );

    if (result == null) {
      return;
    }

    await ref.read(templateRepositoryProvider).save(result);

    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.collectionTemplateSaved)),
    );
    await _loadTemplates();
  }

  Future<void> _duplicateTemplate(CollectionTemplate template) async {
    final l10n = AppLocalizations.of(context)!;
    final duplicate = await ref.read(templateRepositoryProvider).duplicate(
      template,
    );
    duplicate.name = l10n.templateCopyName(template.name);

    await ref.read(templateRepositoryProvider).save(duplicate);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.collectionTemplateDuplicated)));
    await _loadTemplates();
  }

  Future<void> _deleteTemplate(CollectionTemplate template) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCollectionTemplateTitle),
        content: Text(l10n.deleteCollectionTemplateBody(template.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(templateRepositoryProvider).delete(template.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.collectionTemplateDeleted)));
    await _loadTemplates();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.collectionTemplatesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTemplateDialog(),
        icon: const Icon(Icons.add),
        label: Text(l10n.newCollectionTemplate),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTemplates,
              child: ListView.separated(
                padding: const EdgeInsets.all(FoliumTheme.space16),
                itemCount: _templates.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: FoliumTheme.space12),
                itemBuilder: (context, index) {
                  final template = _templates[index];

                  return Container(
                    decoration: FoliumTheme.cardDecoration(),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(FoliumTheme.space16),
                      leading: CircleAvatar(
                        backgroundColor: template.isBuiltIn
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        child: Icon(
                          template.isBuiltIn ? Icons.eco : Icons.edit_note,
                          color: template.isBuiltIn
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      title: Text(template.name),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: FoliumTheme.space8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_localizedBiomeName(l10n, template.biome)),
                            const SizedBox(height: FoliumTheme.space4),
                            Text(
                              _buildTemplatePreview(template, l10n),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _openTemplateDialog(template: template);
                              break;
                            case 'duplicate':
                              _duplicateTemplate(template);
                              break;
                            case 'delete':
                              _deleteTemplate(template);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(l10n.edit),
                          ),
                          PopupMenuItem<String>(
                            value: 'duplicate',
                            child: Text(l10n.duplicateCollectionTemplate),
                          ),
                          if (!template.isBuiltIn)
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Text(l10n.delete),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _localizedBiomeName(AppLocalizations l10n, String biome) {
    switch (biome) {
      case BiomeDetector.cerrado:
        return l10n.biomeCerrado;
      case BiomeDetector.mataAtlantica:
        return l10n.biomeMataAtlantica;
      case BiomeDetector.amazonia:
        return l10n.biomeAmazonia;
      case BiomeDetector.caatinga:
        return l10n.biomeCaatinga;
      case BiomeDetector.pampa:
        return l10n.biomePampa;
      case BiomeDetector.pantanal:
        return l10n.biomePantanal;
      default:
        return biome;
    }
  }

  String _buildTemplatePreview(
    CollectionTemplate template,
    AppLocalizations l10n,
  ) {
    final parts = <String>[];

    if ((template.habitatTemplate ?? '').trim().isNotEmpty) {
      parts.add('${l10n.habitat}: ${template.habitatTemplate!.trim()}');
    }
    if ((template.vegetationTypeTemplate ?? '').trim().isNotEmpty) {
      parts.add(
        '${l10n.vegetationType}: ${template.vegetationTypeTemplate!.trim()}',
      );
    }
    if ((template.topographyTemplate ?? '').trim().isNotEmpty) {
      parts.add('${l10n.topography}: ${template.topographyTemplate!.trim()}');
    }

    return parts.join(' • ');
  }
}

class _TemplateFormDialog extends StatefulWidget {
  final CollectionTemplate template;

  const _TemplateFormDialog({required this.template});

  @override
  State<_TemplateFormDialog> createState() => _TemplateFormDialogState();
}

class _TemplateFormDialogState extends State<_TemplateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _habitatController;
  late final TextEditingController _vegetationTypeController;
  late final TextEditingController _topographyController;
  late final TextEditingController _substrateController;
  late final TextEditingController _notesController;
  late String _selectedBiome;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.template.name);
    _habitatController = TextEditingController(
      text: widget.template.habitatTemplate ?? '',
    );
    _vegetationTypeController = TextEditingController(
      text: widget.template.vegetationTypeTemplate ?? '',
    );
    _topographyController = TextEditingController(
      text: widget.template.topographyTemplate ?? '',
    );
    _substrateController = TextEditingController(
      text: widget.template.substrateTemplate ?? '',
    );
    _notesController = TextEditingController(
      text: widget.template.notesTemplate ?? '',
    );
    _selectedBiome = widget.template.biome;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _habitatController.dispose();
    _vegetationTypeController.dispose();
    _topographyController.dispose();
    _substrateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        widget.template.id == Isar.autoIncrement
            ? l10n.newCollectionTemplate
            : l10n.editCollectionTemplate,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.collectionTemplateNameRequired;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: FoliumTheme.space12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedBiome,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateBiome,
                    border: const OutlineInputBorder(),
                  ),
                  items: BiomeDetector.allBiomes
                      .map(
                        (biome) => DropdownMenuItem<String>(
                          value: biome,
                          child: Text(_localizedBiomeName(l10n, biome)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _selectedBiome = value;
                    });
                  },
                ),
                const SizedBox(height: FoliumTheme.space12),
                TextFormField(
                  controller: _habitatController,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateHabitat,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: FoliumTheme.space12),
                TextFormField(
                  controller: _vegetationTypeController,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateVegetationType,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: FoliumTheme.space12),
                TextFormField(
                  controller: _topographyController,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateTopography,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: FoliumTheme.space12),
                TextFormField(
                  controller: _substrateController,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateSubstrate,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: FoliumTheme.space12),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l10n.collectionTemplateNotes,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            final result = widget.template
              ..name = _nameController.text.trim()
              ..biome = _selectedBiome
              ..habitatTemplate = _emptyToNull(_habitatController.text)
              ..vegetationTypeTemplate = _emptyToNull(
                _vegetationTypeController.text,
              )
              ..topographyTemplate = _emptyToNull(_topographyController.text)
              ..substrateTemplate = _emptyToNull(_substrateController.text)
              ..notesTemplate = _emptyToNull(_notesController.text);

            Navigator.of(context).pop(result);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }

  String _localizedBiomeName(AppLocalizations l10n, String biome) {
    switch (biome) {
      case BiomeDetector.cerrado:
        return l10n.biomeCerrado;
      case BiomeDetector.mataAtlantica:
        return l10n.biomeMataAtlantica;
      case BiomeDetector.amazonia:
        return l10n.biomeAmazonia;
      case BiomeDetector.caatinga:
        return l10n.biomeCaatinga;
      case BiomeDetector.pampa:
        return l10n.biomePampa;
      case BiomeDetector.pantanal:
        return l10n.biomePantanal;
      default:
        return biome;
    }
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
