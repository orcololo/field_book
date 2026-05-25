// ignore_for_file: deprecated_member_use

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/label_template.dart';
import '../database/isar_service.dart';

part 'label_template_repository.g.dart';

@riverpod
LabelTemplateRepository labelTemplateRepository(
  LabelTemplateRepositoryRef ref,
) {
  return LabelTemplateRepository();
}

/// Persistence + seeding for [LabelTemplate].
///
/// Built-in templates are seeded once via [seedBuiltIns]; subsequent calls are
/// idempotent (matched by [LabelTemplate.uuid]).
class LabelTemplateRepository {
  Future<Isar> get _isar => IsarService.instance.isar;

  /// Insert or update a template by UUID.
  Future<int> save(LabelTemplate template) async {
    final isar = await _isar;
    template.updatedAt = DateTime.now();
    return isar.writeTxn(() async {
      // If a row exists with the same UUID, preserve its primary key so
      // foreign references (if any in the future) remain stable.
      final existing = await isar.labelTemplates
          .filter()
          .uuidEqualTo(template.uuid)
          .findFirst();
      if (existing != null) {
        template.id = existing.id;
      }
      return isar.labelTemplates.put(template);
    });
  }

  Future<LabelTemplate?> getById(int id) async {
    final isar = await _isar;
    return isar.labelTemplates.get(id);
  }

  Future<LabelTemplate?> getByUuid(String uuid) async {
    final isar = await _isar;
    return isar.labelTemplates.filter().uuidEqualTo(uuid).findFirst();
  }

  /// All templates, built-ins first, then by name ascending.
  Future<List<LabelTemplate>> getAll() async {
    final isar = await _isar;
    final templates =
        await isar.labelTemplates.where().sortByName().findAll();
    templates.sort((a, b) {
      if (a.isBuiltIn != b.isBuiltIn) {
        return a.isBuiltIn ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return templates;
  }

  /// Delete a custom template. Built-in templates cannot be deleted and the
  /// call throws [StateError] to surface caller bugs early.
  Future<void> delete(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final existing = await isar.labelTemplates.get(id);
      if (existing == null) return;
      if (existing.isBuiltIn) {
        throw StateError('Built-in templates cannot be deleted.');
      }
      await isar.labelTemplates.delete(id);
    });
  }

  /// Idempotently inserts the three built-in templates. Safe to call on every
  /// app start — existing UUIDs are skipped (no overwrite of user renames /
  /// localized names already applied).
  Future<void> seedBuiltIns({
    required String standardName,
    required String compactName,
    required String largeName,
  }) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      Future<void> ensure(LabelTemplate template) async {
        final existing = await isar.labelTemplates
            .filter()
            .uuidEqualTo(template.uuid)
            .findFirst();
        if (existing != null) return;
        await isar.labelTemplates.put(template);
      }

      await ensure(
        LabelTemplate.standard(
          uuid: BuiltInLabelTemplates.standardUuid,
          name: standardName,
        ),
      );
      await ensure(
        LabelTemplate.compact(
          uuid: BuiltInLabelTemplates.compactUuid,
          name: compactName,
        ),
      );
      await ensure(
        LabelTemplate.large(
          uuid: BuiltInLabelTemplates.largeUuid,
          name: largeName,
        ),
      );
    });
  }

  /// Resolve a default template — the user's preferred one, or [standardUuid]
  /// as fallback. Returns null only when the DB is empty (pre-seed).
  Future<LabelTemplate?> getDefault() async {
    final isar = await _isar;
    final standard = await isar.labelTemplates
        .filter()
        .uuidEqualTo(BuiltInLabelTemplates.standardUuid)
        .findFirst();
    if (standard != null) return standard;
    return isar.labelTemplates.where().findFirst();
  }
}
