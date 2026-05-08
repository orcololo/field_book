import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/gps_point.dart';
import '../repositories/session_repository.dart';

part 'gps_track_service.g.dart';

const _minimumTrackDistanceMeters = 50.0;
const _minimumTrackInterval = Duration(seconds: 30);

class GpsTrackState {
  final bool isTracking;
  final bool isForeground;
  final String? sessionUuid;
  final int recordedPoints;
  final DateTime? lastRecordedAt;
  final String? errorCode;

  const GpsTrackState({
    this.isTracking = false,
    this.isForeground = true,
    this.sessionUuid,
    this.recordedPoints = 0,
    this.lastRecordedAt,
    this.errorCode,
  });

  GpsTrackState copyWith({
    bool? isTracking,
    bool? isForeground,
    String? sessionUuid,
    bool clearSessionUuid = false,
    int? recordedPoints,
    DateTime? lastRecordedAt,
    bool clearLastRecordedAt = false,
    String? errorCode,
    bool clearErrorCode = false,
  }) {
    return GpsTrackState(
      isTracking: isTracking ?? this.isTracking,
      isForeground: isForeground ?? this.isForeground,
      sessionUuid: clearSessionUuid ? null : (sessionUuid ?? this.sessionUuid),
      recordedPoints: recordedPoints ?? this.recordedPoints,
      lastRecordedAt: clearLastRecordedAt
          ? null
          : (lastRecordedAt ?? this.lastRecordedAt),
      errorCode: clearErrorCode ? null : (errorCode ?? this.errorCode),
    );
  }
}

@Riverpod(keepAlive: true)
class GpsTrackService extends _$GpsTrackService with WidgetsBindingObserver {
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastStoredPosition;
  DateTime? _lastStoredAt;

  @override
  GpsTrackState build() {
    WidgetsBinding.instance.addObserver(this);

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _positionSubscription?.cancel();
    });

    return GpsTrackState(
      isForeground:
          WidgetsBinding.instance.lifecycleState == null ||
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.state = this.state.copyWith(
      isForeground: state == AppLifecycleState.resumed,
    );
  }

  Future<void> startTracking(String sessionUuid) async {
    await _ensureTrackingReady();

    await _positionSubscription?.cancel();

    final session = await ref.read(sessionRepositoryProvider).getByUuid(sessionUuid);
    if (session == null) {
      state = state.copyWith(errorCode: 'session_not_found');
      throw Exception('session_not_found');
    }

    final lastPoint = session.track.isEmpty ? null : session.track.last;
    _lastStoredAt = lastPoint?.timestamp;
    _lastStoredPosition = lastPoint == null
        ? null
        : Position(
            longitude: lastPoint.longitude,
            latitude: lastPoint.latitude,
            timestamp: lastPoint.timestamp,
            accuracy: 0,
            altitude: lastPoint.altitude ?? 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );

    state = state.copyWith(
      isTracking: true,
      sessionUuid: sessionUuid,
      recordedPoints: session.track.length,
      lastRecordedAt: _lastStoredAt,
      clearErrorCode: true,
    );

    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    await _handlePosition(currentPosition, force: session.track.isEmpty);

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
      ),
    ).listen(
      (position) async {
        await _handlePosition(position);
      },
      onError: (_) {
        state = state.copyWith(errorCode: 'gps_track_stream_error');
      },
    );
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;

    state = state.copyWith(
      isTracking: false,
      clearSessionUuid: true,
      clearErrorCode: true,
    );
  }

  Future<void> _handlePosition(Position position, {bool force = false}) async {
    if (!state.isTracking || state.sessionUuid == null || !state.isForeground) {
      return;
    }

    final now = DateTime.now();

    if (!force) {
      if (_lastStoredAt != null &&
          now.difference(_lastStoredAt!) < _minimumTrackInterval) {
        return;
      }

      if (_lastStoredPosition != null) {
        final distance = Geolocator.distanceBetween(
          _lastStoredPosition!.latitude,
          _lastStoredPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance < _minimumTrackDistanceMeters) {
          return;
        }
      }
    }

    final point = GpsPoint()
      ..latitude = position.latitude
      ..longitude = position.longitude
      ..altitude = position.altitude.isFinite ? position.altitude : null
      ..timestamp = now;

    final updatedSession = await ref
        .read(sessionRepositoryProvider)
        .appendTrackPoint(state.sessionUuid!, point);

    if (updatedSession == null) {
      state = state.copyWith(errorCode: 'session_not_found');
      return;
    }

    _lastStoredPosition = position;
    _lastStoredAt = point.timestamp;

    state = state.copyWith(
      recordedPoints: updatedSession.track.length,
      lastRecordedAt: point.timestamp,
      clearErrorCode: true,
    );
  }

  Future<void> _ensureTrackingReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(errorCode: 'location_services_disabled');
      throw Exception('location_services_disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      state = state.copyWith(errorCode: 'location_permission_denied');
      throw Exception('location_permission_denied');
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(errorCode: 'location_permission_denied_forever');
      throw Exception('location_permission_denied_forever');
    }
  }
}
