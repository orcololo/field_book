import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

const _uuid = Uuid();

class PhotoService {
  static final _log = Logger(printer: PrettyPrinter(methodCount: 0));
  final ImagePicker _picker = ImagePicker();

  // Pick image from camera
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _processAndSavePhoto(File(photo.path));
    } catch (e) {
      rethrow;
    }
  }

  // Pick image from gallery
  Future<File?> pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _processAndSavePhoto(File(photo.path));
    } catch (e) {
      rethrow;
    }
  }

  // Pick multiple images from gallery
  Future<List<File>> pickMultipleFromGallery() async {
    try {
      final List<XFile> photos = await _picker.pickMultiImage(
        imageQuality: 85,
      );

      if (photos.isEmpty) return [];

      final List<File> processedPhotos = [];
      for (final photo in photos) {
        final processed = await _processAndSavePhoto(File(photo.path));
        if (processed != null) {
          processedPhotos.add(processed);
        }
      }

      return processedPhotos;
    } catch (e) {
      rethrow;
    }
  }

  // Process and save photo to app directory
  Future<File?> _processAndSavePhoto(File sourceFile) async {
    try {
      // Get app directory
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/photos');
      
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Generate unique filename
      final extension = path.extension(sourceFile.path);
      final filename = '${_uuid.v4()}$extension';
      final targetPath = '${photosDir.path}/$filename';

      // Compress and save
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        sourceFile.path,
        targetPath,
        quality: 70,
        format: CompressFormat.jpeg,
      );

      if (compressedFile == null) {
        return null;
      }

      // Delete original if it's in temp directory
      if (sourceFile.path.contains('/tmp/') ||
          sourceFile.path.contains('/cache/')) {
        try {
          await sourceFile.delete();
        } catch (e) {
          // Log but don't fail - this is cleanup
          _log.w('Failed to delete temp photo', error: e);
        }
      }

      return File(compressedFile.path);
    } catch (e) {
      rethrow;
    }
  }

  // Delete photo file
  Future<void> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore errors when deleting
    }
  }

  // Get photo file size
  Future<int> getPhotoSize(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}

class PhotoException implements Exception {
  final String message;
  PhotoException(this.message);

  @override
  String toString() => message;
}
