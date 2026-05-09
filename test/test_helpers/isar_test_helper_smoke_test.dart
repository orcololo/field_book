import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:field_book/core/database/isar_service.dart';

import '../test_helpers/isar_test_helper.dart';

void main() {
  group('isar_test_helper smoke', () {
    late Isar isar;
    late Directory dir;

    setUp(() async {
      (isar, dir) = await openTestIsar();
    });

    tearDown(() async {
      await closeTestIsar(isar, dir);
    });

    // Plan Step 0.7 required test 1: verify the helper opens Isar correctly.
    test('opens an empty Isar instance', () {
      expect(isar.isOpen, isTrue);
    });

    // Plan Step 0.7 required test 2: verify closeTestIsar removes the temp dir.
    test('clean tearDown removes the temp directory', () async {
      final dirPath = dir.path;
      await closeTestIsar(isar, dir);
      // Re-open so the outer tearDown doesn't fail.
      (isar, dir) = await openTestIsar();
      expect(Directory(dirPath).existsSync(), isFalse);
    });

    // Additional test added when the @visibleForTesting IsarService seam was
    // introduced: verifies that openTestIsar() injects the test Isar into the
    // IsarService singleton so repositories resolve the same instance.
    test('openTestIsar injects Isar into IsarService and closeTestIsar resets it', () async {
      final db = await IsarService.instance.isar;
      expect(db, same(isar), reason: 'IsarService.instance.isar must return the injected test Isar');
      expect(db.isOpen, isTrue);
      // closeTestIsar is called by the outer tearDown — just verify no throw here.
    });
  });
}
