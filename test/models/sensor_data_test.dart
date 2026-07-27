import 'package:dpfa/models/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> sensorJson({Object? scanned = _absent}) {
    return {
      'name': 'Inside',
      'temperature': 21.5,
      'humidity': 55.0,
      'dew_point': 11.9,
      'bat_level': 2.9,
      'rssi': -72,
      'up_time_in_sec': 172800,
      if (scanned != _absent) 'scanned': scanned,
    };
  }

  /// The shape a server reports for a sensor that was never seen: every value
  /// at zero.
  Map<String, dynamic> emptySensorJson({Object? scanned = _absent}) {
    return {
      'name': '',
      'temperature': 0,
      'humidity': 0,
      'dew_point': 0,
      'bat_level': 0,
      'rssi': 0,
      'up_time_in_sec': 0,
      if (scanned != _absent) 'scanned': scanned,
    };
  }

  group('SensorData.fromJson', () {
    test('parses all fields including scanned', () {
      final sensor = SensorData.fromJson(sensorJson(scanned: '2026-07-27 17:31:00'));

      expect(sensor.name, equals('Inside'));
      expect(sensor.temperature, equals(21.5));
      expect(sensor.humidity, equals(55.0));
      expect(sensor.dewPoint, equals(11.9));
      expect(sensor.batLevel, equals(2.9));
      expect(sensor.rssi, equals(-72));
      expect(sensor.upTime, equals(172800));
      expect(sensor.scanned, equals(DateTime(2026, 7, 27, 17, 31)));
    });

    test('scanned is null when the key is absent', () {
      expect(SensorData.fromJson(sensorJson()).scanned, isNull);
    });

    test('scanned is null for an empty string (sensor never seen)', () {
      expect(SensorData.fromJson(sensorJson(scanned: '')).scanned, isNull);
    });

    test('scanned is null for an unparseable value', () {
      expect(SensorData.fromJson(sensorJson(scanned: 'not a date')).scanned, isNull);
    });
  });

  group('hasReading', () {
    test('is false for an all-zero sensor with an empty scanned', () {
      expect(SensorData.fromJson(emptySensorJson(scanned: '')).hasReading, isFalse);
    });

    test('is false for an all-zero sensor without a scanned key', () {
      expect(SensorData.fromJson(emptySensorJson()).hasReading, isFalse);
      expect(SensorData().hasReading, isFalse);
    });

    test('is true when a scan time was reported', () {
      final json = emptySensorJson(scanned: '2026-07-27 17:31:00');
      expect(SensorData.fromJson(json).hasReading, isTrue);
    });

    test('is true when any single value is non-zero', () {
      const keys = [
        'temperature',
        'humidity',
        'dew_point',
        'bat_level',
        'rssi',
        'up_time_in_sec',
      ];
      for (final key in keys) {
        final json = emptySensorJson(scanned: '')..[key] = 1;
        expect(SensorData.fromJson(json).hasReading, isTrue, reason: '$key is set');
      }
    });

    test('is true for a live sensor from a server that omits scanned', () {
      expect(SensorData.fromJson(sensorJson()).hasReading, isTrue);
    });
  });
}

/// Sentinel distinguishing 'key absent' from an explicit null/empty value.
const _absent = Object();
