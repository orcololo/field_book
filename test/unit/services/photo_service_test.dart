// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:field_book/core/services/photo_service.dart';

// ---------------------------------------------------------------------------
// Fake platform implementations
//
// All three classes use `extends` (not `implements`) so the super-constructor
// stores the correct PlatformInterface token in the expando, satisfying
// PlatformInterface.verify().  FlutterImageCompressPlatform.instance is a
// plain public field (no setter/verify call), so no token considerations are
// needed there either.
// ---------------------------------------------------------------------------

class _FakeImagePicker extends ImagePickerPlatform {
  XFile? imageToReturn;
  List<XFile> imagesToReturn = const [];

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async =>
      imageToReturn;

  @override
  Future<List<XFile>> getMultiImageWithOptions({
    MultiImagePickerOptions options = const MultiImagePickerOptions(),
  }) async =>
      imagesToReturn;
}

class _FakePathProvider extends PathProviderPlatform {
  final String docsPath;
  _FakePathProvider(this.docsPath);

  @override
  Future<String?> getApplicationDocumentsPath() async => docsPath;
}

class _FakeFlutterImageCompress extends FlutterImageCompressPlatform {
  bool shouldReturnNull = false;

  @override
  Future<XFile?> compressAndGetFile(
    String path,
    String targetPath, {
    int minWidth = 1920,
    int minHeight = 1080,
    int inSampleSize = 1,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
    int numberOfRetries = 5,
  }) async {
    if (shouldReturnNull) return null;
    // Write a minimal 4-byte "JPEG" to the target so the returned File exists.
    await File(targetPath).writeAsBytes([0xFF, 0xD8, 0xFF, 0xE0]);
    return XFile(targetPath);
  }

  // The validator getter is never invoked in these tests; throw to catch any
  // accidental call.
  @override
  FlutterImageCompressValidator get validator =>
      throw UnimplementedError('validator not used in tests');

  @override
  Future<void> showNativeLog(bool value) async {}

  @override
  Future<Uint8List> compressWithList(
    Uint8List image, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
    int inSampleSize = 1,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
  }) =>
      throw UnimplementedError();

  @override
  Future<Uint8List?> compressWithFile(
    String path, {
    int minWidth = 1920,
    int minHeight = 1080,
    int inSampleSize = 1,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
    int numberOfRetries = 5,
  }) =>
      throw UnimplementedError();

  @override
  Future<Uint8List?> compressAssetImage(
    String assetName, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
  }) =>
      throw UnimplementedError();

  @override
  void ignoreCheckSupportPlatform(bool value) {}
}

// ---------------------------------------------------------------------------

void main() {
  late PhotoService svc;
  late Directory tmpDir;
  late _FakeImagePicker fakePicker;
  late _FakePathProvider fakePathProvider;
  late _FakeFlutterImageCompress fakeCompress;

  setUp(() async {
    svc = PhotoService();
    tmpDir = await Directory.systemTemp.createTemp('photo_svc_test_');
    fakePicker = _FakeImagePicker();
    fakePathProvider = _FakePathProvider(tmpDir.path);
    fakeCompress = _FakeFlutterImageCompress();
    ImagePickerPlatform.instance = fakePicker;
    PathProviderPlatform.instance = fakePathProvider;
    FlutterImageCompressPlatform.instance = fakeCompress;
  });

  tearDown(() async {
    if (tmpDir.existsSync()) await tmpDir.delete(recursive: true);
  });

  // ---------------------------------------------------------------------------
  group('deletePhoto', () {
    test('deletes an existing file', () async {
      final file = File('${tmpDir.path}/test.jpg');
      await file.writeAsBytes([0xFF, 0xD8, 0xFF]);
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

  // ---------------------------------------------------------------------------
  group('takePhoto', () {
    test('returns null when user cancels (picker returns null)', () async {
      fakePicker.imageToReturn = null;

      expect(await svc.takePhoto(), isNull);
    });

    test('returns compressed file when user picks an image', () async {
      final src = File('${tmpDir.path}/picked.jpg');
      await src.writeAsBytes([0xFF, 0xD8]);
      fakePicker.imageToReturn = XFile(src.path);

      final result = await svc.takePhoto();

      expect(result, isNotNull);
      expect(result!.path, contains('photos'));
    });

    test('returns null when compression returns null', () async {
      final src = File('${tmpDir.path}/picked.jpg');
      await src.writeAsBytes([0xFF, 0xD8]);
      fakePicker.imageToReturn = XFile(src.path);
      fakeCompress.shouldReturnNull = true;

      expect(await svc.takePhoto(), isNull);
    });

    test('completes when source path is under /tmp/ (delete-after-compress '
        'branch)', () async {
      // The source file does not actually exist on disk.  delete() will throw
      // PathNotFoundException, which is caught and logged.  The compressed
      // output is still returned.
      fakePicker.imageToReturn = XFile('/tmp/photo_svc_test_src.jpg');

      final result = await svc.takePhoto();
      expect(result, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  group('pickFromGallery', () {
    test('returns null when user cancels', () async {
      fakePicker.imageToReturn = null;

      expect(await svc.pickFromGallery(), isNull);
    });

    test('returns compressed file on success', () async {
      fakePicker.imageToReturn = XFile('${tmpDir.path}/gallery.jpg');

      final result = await svc.pickFromGallery();

      expect(result, isNotNull);
      expect(result!.path, contains('photos'));
    });
  });

  // ---------------------------------------------------------------------------
  group('pickMultipleFromGallery', () {
    test('returns empty list when picker returns no images', () async {
      fakePicker.imagesToReturn = const [];

      expect(await svc.pickMultipleFromGallery(), isEmpty);
    });

    test('returns a compressed file for each picked image', () async {
      fakePicker.imagesToReturn = [
        XFile('${tmpDir.path}/a.jpg'),
        XFile('${tmpDir.path}/b.jpg'),
      ];

      final results = await svc.pickMultipleFromGallery();

      expect(results, hasLength(2));
      for (final f in results) {
        expect(f.path, contains('photos'));
      }
    });

    test('omits images for which compression returns null', () async {
      fakePicker.imagesToReturn = [XFile('${tmpDir.path}/c.jpg')];
      fakeCompress.shouldReturnNull = true;

      expect(await svc.pickMultipleFromGallery(), isEmpty);
    });
  });
}
