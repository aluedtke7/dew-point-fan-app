import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/models/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final base = DateTime(2026, 7, 27, 17, 31);

  DewPointData withScans(DateTime? inside, DateTime? outside) {
    return DewPointData(
      sensors: [
        SensorData(name: 'Inside', scanned: inside),
        SensorData(name: 'Outside', scanned: outside),
      ],
    );
  }

  group('scanGap', () {
    test('is the absolute difference between both scan times', () {
      final gap = const Duration(minutes: 7, seconds: 12);

      expect(withScans(base, base.subtract(gap)).scanGap, equals(gap));
      expect(withScans(base.subtract(gap), base).scanGap, equals(gap));
    });

    test('is null when a scan time is missing', () {
      expect(withScans(base, null).scanGap, isNull);
      expect(withScans(null, base).scanGap, isNull);
      expect(withScans(null, null).scanGap, isNull);
    });

    test('is null with fewer than two sensors', () {
      expect(DewPointData().scanGap, isNull);
      expect(
        DewPointData(sensors: [SensorData(name: 'Inside', scanned: base)]).scanGap,
        isNull,
      );
    });
  });

  group('staleSensorIndex', () {
    test('is null when the gap is at or below the threshold', () {
      expect(withScans(base, base).staleSensorIndex, isNull);
      expect(
        withScans(base, base.subtract(const Duration(minutes: 4, seconds: 59))).staleSensorIndex,
        isNull,
      );
      expect(
        withScans(base, base.subtract(DewPointData.staleThreshold)).staleSensorIndex,
        isNull,
      );
    });

    test('flags the second sensor when it is the older one', () {
      final data = withScans(base, base.subtract(const Duration(minutes: 5, seconds: 1)));

      expect(data.staleSensorIndex, equals(1));
      expect(data.scanGap, equals(const Duration(minutes: 5, seconds: 1)));
    });

    test('flags the first sensor when it is the older one', () {
      final data = withScans(base.subtract(const Duration(minutes: 7, seconds: 12)), base);

      expect(data.staleSensorIndex, equals(0));
      expect(data.scanGap, equals(const Duration(minutes: 7, seconds: 12)));
    });

    test('is null when a scan time is missing or there are too few sensors', () {
      expect(withScans(base.subtract(const Duration(hours: 1)), null).staleSensorIndex, isNull);
      expect(withScans(null, null).staleSensorIndex, isNull);
      expect(DewPointData().staleSensorIndex, isNull);
    });
  });

  test('fromJson parses scanned per sensor', () {
    final data = DewPointData.fromJson({
      'update': '2026-07-27 17:31:00',
      'sensors': [
        {
          'name': 'Inside',
          'temperature': 21.5,
          'humidity': 55.0,
          'dew_point': 11.9,
          'bat_level': 2.9,
          'rssi': -72,
          'up_time_in_sec': 172800,
          'scanned': '2026-07-27 17:31:00',
        },
        {
          'name': 'Outside',
          'temperature': 12.3,
          'humidity': 78.0,
          'dew_point': 8.5,
          'bat_level': 2.8,
          'rssi': -88,
          'up_time_in_sec': 86400,
          'scanned': '2026-07-27 17:23:48',
        },
      ],
      'reason': 2,
      'venting': false,
      'override': false,
      'remote_override': 0,
      'diff_min': 5,
      'hysteresis': 2,
    });

    expect(data.scanGap, equals(const Duration(minutes: 7, seconds: 12)));
    expect(data.staleSensorIndex, equals(1));
  });

  test('a payload without scanned keys stays free of stale markers', () {
    final data = DewPointData.fromJson({
      'update': '2026-07-27 17:31:00',
      'sensors': [
        {
          'name': 'Inside',
          'temperature': 21.5,
          'humidity': 55.0,
          'dew_point': 11.9,
          'bat_level': 2.9,
          'rssi': -72,
          'up_time_in_sec': 172800,
        },
        {
          'name': 'Outside',
          'temperature': 12.3,
          'humidity': 78.0,
          'dew_point': 8.5,
          'bat_level': 2.8,
          'rssi': -88,
          'up_time_in_sec': 86400,
        },
      ],
      'reason': 0,
      'venting': false,
      'override': false,
      'remote_override': 0,
      'diff_min': 5,
      'hysteresis': 2,
    });

    expect(data.sensors, hasLength(2));
    expect(data.scanGap, isNull);
    expect(data.staleSensorIndex, isNull);
  });
}
