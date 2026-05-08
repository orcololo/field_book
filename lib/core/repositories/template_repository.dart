// ignore_for_file: deprecated_member_use

import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../models/collection_template.dart';
import '../../shared/constants/biome_templates.dart';
import '../database/isar_service.dart';
import '../utils/biome_detector.dart';

part 'template_repository.g.dart';

const _uuid = Uuid();

@riverpod
TemplateRepository templateRepository(TemplateRepositoryRef ref) {
  return TemplateRepository();
}

class TemplateRepository {
  Future<Isar> get _isar => IsarService.instance.isar;

  Future<void> ensureBuiltInTemplates() async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);
  }

  Future<void> save(CollectionTemplate template) async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);

    await isar.writeTxn(() async {
      await isar.collectionTemplates.put(template);
    });
  }

  Future<CollectionTemplate?> getById(int id) async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);
    return isar.collectionTemplates.get(id);
  }

  Future<CollectionTemplate?> getByUuid(String uuid) async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);
    return isar.collectionTemplates.filter().uuidEqualTo(uuid).findFirst();
  }

  Future<List<CollectionTemplate>> getAll() async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);

    final templates = await isar.collectionTemplates.where().findAll();
    return _sortTemplates(templates);
  }

  Future<List<CollectionTemplate>> getByBiome(String biome) async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);

    final templates = await isar.collectionTemplates
        .filter()
        .biomeEqualTo(biome)
        .findAll();

    return _sortTemplates(templates);
  }

  Future<void> delete(int id) async {
    final isar = await _isar;
    await _ensureBuiltInTemplates(isar);

    final template = await isar.collectionTemplates.get(id);
    if (template == null) {
      return;
    }

    if (template.isBuiltIn) {
      throw StateError('Built-in templates cannot be deleted');
    }

    await isar.writeTxn(() async {
      await isar.collectionTemplates.delete(id);
    });
  }

  Future<CollectionTemplate> duplicate(CollectionTemplate template) async {
    return CollectionTemplate()
      ..uuid = _uuid.v4()
      ..name = template.name
      ..biome = template.biome
      ..isBuiltIn = false
      ..habitatTemplate = template.habitatTemplate
      ..vegetationTypeTemplate = template.vegetationTypeTemplate
      ..topographyTemplate = template.topographyTemplate
      ..substrateTemplate = template.substrateTemplate
      ..notesTemplate = template.notesTemplate;
  }

  Future<CollectionTemplate?> getSuggestedTemplateForCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final biome = BiomeDetector.detectBiome(
      latitude: latitude,
      longitude: longitude,
    );

    if (biome == null) {
      return null;
    }

    final templates = await getByBiome(biome);
    if (templates.isEmpty) {
      return null;
    }

    return templates.first;
  }

  Future<void> _ensureBuiltInTemplates(Isar isar) async {
    final builtInUuids = builtInBiomeTemplates.map((seed) => seed.uuid).toList();

    final existingTemplates = await isar.collectionTemplates
        .filter()
        .anyOf(builtInUuids, (query, uuid) => query.uuidEqualTo(uuid))
        .findAll();

    final existingUuids = existingTemplates.map((template) => template.uuid).toSet();
    final missingTemplates = builtInBiomeTemplates
        .where((seed) => !existingUuids.contains(seed.uuid))
        .map(_templateFromSeed)
        .toList();

    if (missingTemplates.isEmpty) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.collectionTemplates.putAll(missingTemplates);
    });
  }

  CollectionTemplate _templateFromSeed(BuiltInCollectionTemplateSeed seed) {
    return CollectionTemplate()
      ..uuid = seed.uuid
      ..name = seed.name
      ..biome = seed.biome
      ..isBuiltIn = seed.isBuiltIn
      ..habitatTemplate = seed.habitatTemplate
      ..vegetationTypeTemplate = seed.vegetationTypeTemplate
      ..topographyTemplate = seed.topographyTemplate
      ..substrateTemplate = seed.substrateTemplate
      ..notesTemplate = seed.notesTemplate;
  }

  List<CollectionTemplate> _sortTemplates(List<CollectionTemplate> templates) {
    final sorted = [...templates];
    sorted.sort((a, b) {
      if (a.isBuiltIn != b.isBuiltIn) {
        return a.isBuiltIn ? -1 : 1;
      }

      final biomeComparison = a.biome.compareTo(b.biome);
      if (biomeComparison != 0) {
        return biomeComparison;
      }

      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return sorted;
  }
}
