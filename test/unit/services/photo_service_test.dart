// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:field_book/core/services/photo_service.dart';

// FIXME: takePhoto, pickFromGallery, and pickMultipleFromGallery are not
// testable because PhotoService constructs ImagePicker() inline
// (`final ImagePicker _picker = ImagePicker()`), with no injection seam.
// Deferred fix: accept an optional `ImagePicker` parameter in the constructor
// so tests can supply a mock picker.  Until then, coverage for those methods
// can only come from integration / widget tests with a real device.

void main() {
  late PhotoService svc;
  late Directory tmpDir;

  setUp(() async {
    svc = PhotoService();
    tmpDir = await Directory.systemTemp.createTemp('photo_service_test_');
  });

  tearDown(() async {
    if (tmpDir.existsSync()) {
      await tmpDir.delete(recursive: true);
    }
  });

  // ---------------------------------------------------------------------------
  group('deletePhoto', () {
    test('deletes an existing file', () async {
      final file = File('${tmpDir.path}/test.jpg');
      await file.writeAsBytes([0xFF, 0xD8, 0xFF]); // minimal JPEG header
      expect(await file.exists(), isTrue);

      await svc.deletePhoto(file.path);

      expect(await file.exists(), isFalse);
    });

    test('does not throw when file does not exist', () async {
      final missingPath = '${tmpDir.path}/nonexistent.jpg';
      await expectLater(svc.deletePhoto(missingPath), completes);
    });

    test('does not throw for empty path string', () async {
      // Empty-path File().exists() returns false; silently ignored.
      await expectLater(svc.deletePhoto(''), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('getPhotoSize', () {
    test('returns correct byte count for existing file', () async {
      final data = List<int>.filled(512, 0xFF);
      final file = File('${tmpDir.path}/photo.jpg');
      await file.writeAsBytes(data);

      final size = await svc.getPhotoSize(file.path);
      expect(size, 512);
    });

    test('returns 0 for non-existent file', () async {
      final size = await svc.getPhotoSize('${tmpDir.path}/missing.jpg');
      expect(size, 0);
    });

    test('returns 0 for empty path', () async {
      expect(await svc.getPhotoSize(''), 0);
    });

    test('returns correct size for a 1-byte file', () async {
      final file = File('${tmpDir.path}/tiny.jpg');
      await file.writeAsBytes([0x00]);
      expect(await svc.getPhotoSize(file.path), 1);
    });
  });
}
