import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// Result of a single file upload to R2.
class UploadResult {
  final String originalUrl;
  final String? thumbnailUrl;
  final String key;
  final String? thumbnailKey;

  const UploadResult({
    required this.originalUrl,
    this.thumbnailUrl,
    required this.key,
    this.thumbnailKey,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult(
      originalUrl: json['originalUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      key: json['key'] as String,
      thumbnailKey: json['thumbnailKey'] as String?,
    );
  }
}

/// Service for uploading images and audio files to the backend (R2 storage).
class MediaUploadService {
  final ApiClient _api;

  MediaUploadService({required ApiClient api}) : _api = api;

  /// Upload a local image file. Returns the R2 URLs and keys.
  Future<UploadResult> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final data = await _api.upload<Map<String, dynamic>>(
      ApiEndpoints.uploadImage,
      formData: formData,
    );

    return UploadResult.fromJson(data);
  }

  /// Upload a local audio file.
  Future<UploadResult> uploadAudio(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final data = await _api.upload<Map<String, dynamic>>(
      ApiEndpoints.uploadAudio,
      formData: formData,
    );

    return UploadResult.fromJson(data);
  }

  /// Upload multiple images, returning results in order. Skips failures.
  Future<List<UploadResult>> uploadImages(List<File> files) async {
    final results = <UploadResult>[];
    for (final file in files) {
      try {
        results.add(await uploadImage(file));
      } catch (e) {
        _log.w('Failed to upload ${file.path}: $e');
      }
    }
    return results;
  }

  /// Delete a remote file by its R2 key.
  Future<void> deleteFile(String key) async {
    await _api.delete(ApiEndpoints.deleteUpload(key));
  }
}
