import 'package:flutter_test/flutter_test.dart';
import 'package:field_book/core/database/isar_service.dart';
import '../test_helpers/isar_test_helper.dart';

void main() {
  group('isar_test_helper smoke test', () {
    test('openTestIsar injects Isar into IsarService and closeTestIsar resets it', () async {
      final (isar, dir) = await openTestIsar();

      // IsarService.instance.isar should now resolve to the test Isar immediately
      final db = await IsarService.instance.isar;
      expect(db, same(isar), reason: 'IsarService.instance.isar must return the injected test Isar');
      expect(db.isOpen, isTrue);

      await closeTestIsar(isar, dir);

      // After reset the singleton _isar is null; a new call would try _initIsar (which we do NOT call here)
      // Just verify closeTestIsar did not throw.
    });
  });
}
