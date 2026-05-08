import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:field_book/core/services/location_service.dart';

// ---------------------------------------------------------------------------
// Fake Geolocator
//
// Extending GeolocatorPlatform directly satisfies PlatformInterface.verify()
// because the correct super-constructor token is used.  No extra packages
// needed.
// ---------------------------------------------------------------------------

class _FakeGeolocator extends GeolocatorPlatform {
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.whileInUse;

  // Called by requestPermission() only when permission is currently denied.
  LocationPermission permissionAfterRequest = LocationPermission.whileInUse;

  Position? fakePosition;
  Exception? positionException;

  // Captures the LocationSettings passed to getCurrentPosition for assertions.
  LocationSettings? capturedSettings;

  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async =>
      permissionAfterRequest;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    capturedSettings = locationSettings;
    if (positionException != null) throw positionException!;
    if (fakePosition == null) {
      throw Exception('No fake position configured');
    }
    return fakePosition!;
  }

  @override
  Future<bool> openAppSettings() async {
    openAppSettingsCalls++;
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    openLocationSettingsCalls++;
    return true;
  }
}

// ---------------------------------------------------------------------------

Position _fakePosition({double lat = -3.0, double lon = -60.0}) {
  return Position(
    latitude: lat,
    longitude: lon,
    timestamp: DateTime(2025, 6, 1),
    accuracy: 5.0,
    altitude: 80.0,
    altitudeAccuracy: 2.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
}

// ---------------------------------------------------------------------------

void main() {
  late _FakeGeolocator fake;
  late LocationService svc;

  setUp(() {
    fake = _FakeGeolocator();
    GeolocatorPlatform.instance = fake;
    svc = LocationService();
  });

  // ---------------------------------------------------------------------------
  group('isLocationServiceEnabled', () {
    test('returns true when service is enabled', () async {
      fake.serviceEnabled = true;
      expect(await svc.isLocationServiceEnabled(), isTrue);
    });

    test('returns false when service is disabled', () async {
      fake.serviceEnabled = false;
      expect(await svc.isLocationServiceEnabled(), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  group('checkPermission', () {
    test('returns current permission status', () async {
      fake.permission = LocationPermission.always;
      expect(await svc.checkPermission(), LocationPermission.always);
    });

    test('returns denied when permission is denied', () async {
      fake.permission = LocationPermission.denied;
      expect(await svc.checkPermission(), LocationPermission.denied);
    });
  });

  // ---------------------------------------------------------------------------
  group('requestPermission', () {
    test('returns the permission granted after request', () async {
      fake.permissionAfterRequest = LocationPermission.whileInUse;
      expect(
        await svc.requestPermission(),
        LocationPermission.whileInUse,
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('getCurrentLocation', () {
    test('returns position when service enabled and permission granted',
        () async {
      fake.serviceEnabled = true;
      fake.permission = LocationPermission.whileInUse;
      fake.fakePosition = _fakePosition(lat: -3.1, lon: -60.0);

      final position = await svc.getCurrentLocation();
      expect(position, isNotNull);
      expect(position!.latitude, closeTo(-3.1, 0.001));
      expect(position.longitude, closeTo(-60.0, 0.001));
    });

    test('throws when location service is disabled', () async {
      fake.serviceEnabled = false;

      await expectLater(
        svc.getCurrentLocation(),
        throwsA(isA<Exception>()),
      );
    });

    test('throws when permission is denied and request is also denied',
        () async {
      fake.serviceEnabled = true;
      fake.permission = LocationPermission.denied;
      fake.permissionAfterRequest = LocationPermission.denied;

      await expectLater(
        svc.getCurrentLocation(),
        throwsA(isA<Exception>()),
      );
    });

    test('returns position when initially denied but granted after request',
        () async {
      fake.serviceEnabled = true;
      fake.permission = LocationPermission.denied;
      fake.permissionAfterRequest = LocationPermission.whileInUse;
      fake.fakePosition = _fakePosition();

      final position = await svc.getCurrentLocation();
      expect(position, isNotNull);
    });

    test('throws when permission is permanently denied', () async {
      fake.serviceEnabled = true;
      fake.permission = LocationPermission.deniedForever;

      await expectLater(
        svc.getCurrentLocation(),
        throwsA(isA<Exception>()),
      );
    });

    test('passes LocationAccuracy.high to the platform', () async {
      fake.serviceEnabled = true;
      fake.permission = LocationPermission.whileInUse;
      fake.fakePosition = _fakePosition();

      await svc.getCurrentLocation();

      expect(
        fake.capturedSettings?.accuracy,
        LocationAccuracy.high,
      );
    });

    test('propagates exception thrown by getCurrentPosition', () async {
      fake.serviceEnabled = true;
      fake.permission = LocationPermission.whileInUse;
      fake.positionException = Exception('platform error');

      await expectLater(
        svc.getCurrentLocation(),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('openAppSettings', () {
    test('delegates to GeolocatorPlatform.openAppSettings', () async {
      await svc.openAppSettings();
      expect(fake.openAppSettingsCalls, 1);
    });
  });

  // ---------------------------------------------------------------------------
  group('openLocationSettings', () {
    test('delegates to GeolocatorPlatform.openLocationSettings', () async {
      await svc.openLocationSettings();
      expect(fake.openLocationSettingsCalls, 1);
    });
  });
}
