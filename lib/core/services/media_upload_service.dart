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
  static const _maxAttempts = 3;

  MediaUploadService({required ApiClient api}) : _api = api;

  /// Upload a local image file with retry. Returns the R2 URLs and keys.
  Future<UploadResult> uploadImage(File file) async {
    return _withRetry(
      label: file.path.split('/').last,
      action: () async {
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
      },
    );
  }

  /// Upload a local audio file with retry.
  Future<UploadResult> uploadAudio(File file) async {
    return _withRetry(
      label: file.path.split('/').last,
      action: () async {
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
      },
    );
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

  /// Retries [action] up to [_maxAttempts] times with exponential backoff.
  /// Only retries on transient errors (timeouts, connection errors, 5xx).
  Future<T> _withRetry<T>({
    required String label,
    required Future<T> Function() action,
  }) async {
    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        return await action();
      } on DioException catch (e) {
        if (!_isRetryable(e) || attempt == _maxAttempts) rethrow;
        final delay = Duration(seconds: 2 * attempt);
        _log.w('Upload "$label" failed (attempt $attempt/$_maxAttempts), '
            'retrying in ${delay.inSeconds}s: ${e.message}');
        await Future.delayed(delay);
      }
    }
    throw StateError('Unreachable');
  }

  bool _isRetryable(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return true;
    }
    final statusCode = e.response?.statusCode;
    if (statusCode != null && statusCode >= 500) return true;
    return false;
  }
}
