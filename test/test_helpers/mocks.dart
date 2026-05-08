import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

/// Mock factories for external dependencies. Import these in test files.
class MockDio extends Mock implements Dio {}
class MockResponse<T> extends Mock implements Response<T> {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockImagePicker extends Mock implements ImagePicker {}

/// Geolocator's API is mostly static — service tests stub by injecting a
/// mockable wrapper. The location_service_test.dart will document its
/// approach.

/// Sentinel fallback values for mocktail. Register these in setUpAll() of
/// any test file that uses captures with custom types.
void registerCommonFallbacks() {
  registerFallbackValue(Uri.parse('https://example.com'));
  registerFallbackValue(<String, dynamic>{});
  registerFallbackValue(RequestOptions(path: ''));
}
