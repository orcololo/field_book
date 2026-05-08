import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/sync_provider.dart';
import '../../../core/theme/folium_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/plant_record.dart';
import '../../../shared/widgets/modern/glass_app_bar.dart';

class ConflictResolutionScreen extends ConsumerWidget {
  const ConflictResolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final conflictsAsync = ref.watch(conflictRecordsProvider);

    return Scaffold(
      appBar: GlassAppBarFrosted(
        showBackButton: true,
        title: l10n.conflictResolutionTitle,
      ),
      body: conflictsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ConflictStateMessage(
          icon: Icons.error_outline,
          title: l10n.syncConflictLoadErrorTitle,
          message: error.toString(),
        ),
        data: (records) {
          if (records.isEmpty) {
            return _ConflictStateMessage(
              icon: Icons.task_alt,
              title: l10n.noPendingConflictsTitle,
              message: l10n.noPendingConflictsMessage,
            );
          }

          return Column(
            children: [
              _BulkResolveCard(records: records),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    FoliumTheme.space16,
                    0,
                    FoliumTheme.space16,
                    FoliumTheme.space24,
                  ),
                  itemBuilder: (context, index) => _ConflictRecordCard(
                    plant: records[index],
                  ),
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: FoliumTheme.space16),
                  itemCount: records.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BulkResolveCard extends ConsumerWidget {
  final List<PlantRecord> records;

  const _BulkResolveCard({required this.records});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(FoliumTheme.space16),
      padding: const EdgeInsets.all(FoliumTheme.space16),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(FoliumTheme.radiusLarge),
        border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pendingConflictsCount(records.length),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: FoliumTheme.space8),
          Text(
            l10n.conflictResolutionHelper,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: FoliumTheme.space16),
          FilledButton.icon(
            onPressed: () async {
              await ref.read(syncServiceProvider).resolveAllConflictsKeepMostRecent();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.conflictsResolvedMostRecent)),
              );
            },
            icon: const Icon(Icons.auto_fix_high),
            label: Text(l10n.resolveAllKeepMostRecent),
          ),
        ],
      ),
    );
  }
}

class _ConflictRecordCard extends ConsumerWidget {
  final PlantRecord plant;

  const _ConflictRecordCard({required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final syncService = ref.read(syncServiceProvider);
    final serverData = _decodeConflictData(plant.syncMetadata.conflictData);
    final localData = syncService.buildPlantConflictLocalData(plant);
    final fields = _buildConflictFields(localData, serverData, l10n);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(FoliumTheme.radiusLarge),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(FoliumTheme.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.scientificName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                      ),
                      if (plant.registryIdentifier != null)
                        Padding(
                          padding: const EdgeInsets.only(top: FoliumTheme.space4),
                          child: Text(
                            plant.registryIdentifier!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FoliumTheme.space10,
                    vertical: FoliumTheme.space8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(FoliumTheme.radiusFull),
                  ),
                  child: Text(
                    l10n.syncConflictBadge,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: FoliumTheme.space16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ConflictColumn(
                    title: l10n.syncConflictLocalVersion,
                    values: localData,
                    fields: fields,
                    accentColor: colorScheme.primary,
                    chipLabelBuilder: (field) => l10n.keepLocalField,
                    onFieldTap: (field) async {
                      final resolved = _mergeField(localData, serverData, field, true);
                      await syncService.resolvePlantConflictWithData(plant, resolved);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fieldResolvedKeepingLocal(field.label))),
                      );
                    },
                  ),
                ),
                const SizedBox(width: FoliumTheme.space12),
                Expanded(
                  child: _ConflictColumn(
                    title: l10n.syncConflictServerVersion,
                    values: serverData,
                    fields: fields,
                    accentColor: colorScheme.tertiary,
                    chipLabelBuilder: (field) => l10n.acceptServerField,
                    onFieldTap: (field) async {
                      final resolved = _mergeField(localData, serverData, field, false);
                      await syncService.resolvePlantConflictWithData(plant, resolved);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fieldResolvedKeepingServer(field.label))),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: FoliumTheme.space16),
            Wrap(
              spacing: FoliumTheme.space8,
              runSpacing: FoliumTheme.space8,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await syncService.keepLocalConflict(plant);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.conflictResolvedKeepingLocal)),
                    );
                  },
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(l10n.keepLocalRecord),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    await syncService.acceptServerConflict(plant);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.conflictResolvedKeepingServer)),
                    );
                  },
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: Text(l10n.acceptServerRecord),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConflictColumn extends StatelessWidget {
  final String title;
  final Map<String, dynamic> values;
  final List<_ConflictField> fields;
  final Color accentColor;
  final String Function(_ConflictField field) chipLabelBuilder;
  final Future<void> Function(_ConflictField field) onFieldTap;

  const _ConflictColumn({
    required this.title,
    required this.values,
    required this.fields,
    required this.accentColor,
    required this.chipLabelBuilder,
    required this.onFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FoliumTheme.space12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(FoliumTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: FoliumTheme.space12),
          for (final field in fields) ...[
            _FieldDecisionTile(
              label: field.label,
              value: _stringify(_valueByPath(values, field.path)),
              buttonLabel: chipLabelBuilder(field),
              accentColor: accentColor,
              onTap: () => onFieldTap(field),
            ),
            if (field != fields.last)
              const SizedBox(height: FoliumTheme.space10),
          ],
        ],
      ),
    );
  }
}

class _FieldDecisionTile extends StatelessWidget {
  final String label;
  final String value;
  final String buttonLabel;
  final Color accentColor;
  final VoidCallback onTap;

  const _FieldDecisionTile({
    required this.label,
    required this.value,
    required this.buttonLabel,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FoliumTheme.space12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(FoliumTheme.radiusMedium),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: FoliumTheme.space8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: FoliumTheme.space10),
          Align(
            alignment: Alignment.centerLeft,
            child: ActionChip(
              onPressed: onTap,
              label: Text(buttonLabel),
              avatar: Icon(Icons.check_circle_outline, size: 16, color: accentColor),
              side: BorderSide(color: accentColor.withValues(alpha: 0.24)),
              backgroundColor: accentColor.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConflictStateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _ConflictStateMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FoliumTheme.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colorScheme.primary, size: 32),
            ),
            const SizedBox(height: FoliumTheme.space16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: FoliumTheme.space8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConflictField {
  final String label;
  final List<String> path;

  const _ConflictField(this.label, this.path);
}

List<_ConflictField> _buildConflictFields(
  Map<String, dynamic> localData,
  Map<String, dynamic> serverData,
  AppLocalizations l10n,
) {
  final candidates = <_ConflictField>[
    _ConflictField(l10n.scientificName, ['scientificName']),
    _ConflictField(l10n.commonName, ['commonName']),
    _ConflictField(l10n.family, ['family']),
    _ConflictField(l10n.genus, ['genus']),
    _ConflictField(l10n.species, ['species']),
    _ConflictField(l10n.habitat, ['habitat']),
    _ConflictField(l10n.location, ['location']),
    _ConflictField(l10n.notes, ['notes']),
    _ConflictField(l10n.category, ['category']),
    _ConflictField(l10n.collectionDate, ['dateCollected']),
    _ConflictField(l10n.registryIdentification, ['registryIdentifier']),
  ];

  return candidates.where((field) {
    final localValue = _stringify(_valueByPath(localData, field.path));
    final serverValue = _stringify(_valueByPath(serverData, field.path));
    return localValue != serverValue;
  }).toList();
}

Map<String, dynamic> _decodeConflictData(String? raw) {
  if (raw == null || raw.isEmpty) {
    return <String, dynamic>{};
  }

  final decoded = jsonDecode(raw);
  if (decoded is Map) {
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }

  return <String, dynamic>{};
}

dynamic _valueByPath(Map<String, dynamic> source, List<String> path) {
  dynamic current = source;
  for (final segment in path) {
    if (current is! Map) return null;
    current = current[segment];
  }
  return current;
}

Map<String, dynamic> _mergeField(
  Map<String, dynamic> local,
  Map<String, dynamic> server,
  _ConflictField field,
  bool keepLocal,
) {
  final base = Map<String, dynamic>.from(server.isNotEmpty ? server : local);
  _setByPath(base, field.path, _valueByPath(keepLocal ? local : server, field.path));
  return base;
}

void _setByPath(Map<String, dynamic> source, List<String> path, dynamic value) {
  Map<String, dynamic> current = source;
  for (var i = 0; i < path.length - 1; i++) {
    final key = path[i];
    final next = current[key];
    if (next is Map) {
      current = next.map((k, v) => MapEntry(k.toString(), v));
      source[key] = current;
    } else {
      current[key] = <String, dynamic>{};
      current = current[key] as Map<String, dynamic>;
    }
  }
  current[path.last] = value;
}

String _stringify(dynamic value) {
  if (value == null) return '—';
  if (value is List) {
    return value.isEmpty ? '—' : value.join(', ');
  }
  if (value is Map) {
    return value.isEmpty ? '—' : value.entries.map((e) => '${e.key}: ${e.value}').join(' · ');
  }
  if (value is bool) {
    return value ? 'true' : 'false';
  }
  return value.toString().trim().isEmpty ? '—' : value.toString();
}
