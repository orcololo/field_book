import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/collection_session.dart';
import '../../../models/collection_template.dart';
import '../../../models/municipality_bounding_box_cache.dart';
import '../../../models/plant_record.dart';
import '../../../models/saved_search.dart';
import '../../../models/settings.dart';
import '../../../models/taxon_cache.dart';
import 'isar_service_interface.dart';

class IsarService extends IsarServiceInterface {
  static IsarService? _instance;
  static Isar? _isar;

  IsarService._();

  static IsarService get instance {
    _instance ??= IsarService._();
    return _instance!;
  }

  @override
  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    _isar = await _initIsar();
    return _isar!;
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();

    return await Isar.open(
      [
        CollectionSessionSchema,
        CollectionTemplateSchema,
        MunicipalityBoundingBoxCacheSchema,
        PlantRecordSchema,
        SavedSearchSchema,
        SettingsSchema,
        TaxonCacheSchema,
      ],
      directory: dir.path,
      inspector: true,
    );
  }

  @override
  Future<void> bulkWrite(
    Future<void> Function(Isar isar) operation,
  ) async {
    final db = await isar;
    await db.writeTxn(() async {
      await operation(db);
    });
  }

  @override
  Future<T> bulkRead<T>(
    Future<T> Function(Isar isar) operation,
  ) async {
    final db = await isar;
    return await operation(db);
  }

  @override
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  @override
  Future<void> clearAll() async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.clear();
    });
  }
}
