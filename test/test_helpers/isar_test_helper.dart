import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_test/flutter_test.dart';

import 'package:field_book/models/plant_record.dart';
import 'package:field_book/models/collection_session.dart';
import 'package:field_book/models/label_template.dart';
import 'package:field_book/models/saved_search.dart';
import 'package:field_book/models/settings.dart';
import 'package:field_book/models/collection_template.dart';
import 'package:field_book/models/municipality_bounding_box_cache.dart';
import 'package:field_book/models/taxon_cache.dart';
import 'package:field_book/core/database/isar_service.dart';

/// In-memory Isar test harness.
///
/// Opens a named Isar instance in a temp directory and injects it into
/// [IsarService] so all repositories transparently use the test DB.
///
/// Usage:
/// ```dart
/// late Isar isar;
/// late Directory dir;
/// setUp(() async { (isar, dir) = await openTestIsar(); });
/// tearDown(() async => closeTestIsar(isar, dir));
/// ```
Future<(Isar, Directory)> openTestIsar() async {
  // InitializeIsarCore must run BEFORE TestWidgetsFlutterBinding because the
  // binding blocks all HTTP requests, which would prevent the download.
  await Isar.initializeIsarCore(download: true);
  TestWidgetsFlutterBinding.ensureInitialized();
  final dir = await Directory.systemTemp.createTemp('isar_test_');
  final isar = await Isar.open(
    [
      PlantRecordSchema,
      CollectionSessionSchema,
      LabelTemplateSchema,
      SavedSearchSchema,
      SettingsSchema,
      CollectionTemplateSchema,
      MunicipalityBoundingBoxCacheSchema,
      TaxonCacheSchema,
    ],
    directory: dir.path,
    name: p.basename(dir.path),
  );
  IsarService.overrideIsarForTesting(isar);
  return (isar, dir);
}

Future<void> closeTestIsar(Isar isar, Directory dir) async {
  IsarService.resetIsarAfterTesting();
  await isar.close(deleteFromDisk: true);
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
}
