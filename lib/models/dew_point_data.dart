import 'package:dpfa/models/sensor_data.dart';

class DewPointData {
  /// A sensor is considered stale when its scan time lags the other sensor by
  /// more than this.
  static const staleThreshold = Duration(minutes: 5);

  DateTime? update;
  List<SensorData> sensors = <SensorData>[];
  int reason = 0;
  bool venting = false;
  bool override = false;
  int remoteOverride = 0;
  int diffMin = 0;
  int hysteresis = 0;

  DewPointData({
    this.update,
    this.sensors = const [],
    this.reason = 0,
    this.venting = false,
    this.override = false,
    this.remoteOverride = 0,
    this.diffMin = 0,
    this.hysteresis = 0,
  });

  factory DewPointData.fromJson(Map<String, dynamic> json) {
    List<dynamic> sensorData = json['sensors'];
    sensorData.removeWhere((element) => element == null);
    return DewPointData(
      update: DateTime.tryParse(json['update'] ?? ''),
      sensors: sensorData.isEmpty
          ? []
          : sensorData.map((e) => SensorData.fromJson(e)).toList(),
      reason: json['reason'] ?? 0,
      venting: json['venting'],
      override: json['override'],
      remoteOverride: json['remote_override'] ?? 0,
      diffMin: json['diff_min'] ?? 0,
      hysteresis: json['hysteresis'] ?? 0,
    );
  }

  /// Absolute gap between the scan times of the first two sensors, or null when
  /// there are fewer than two sensors or either scan time is missing.
  Duration? get scanGap {
    if (sensors.length < 2) {
      return null;
    }
    final first = sensors[0].scanned;
    final second = sensors[1].scanned;
    if (first == null || second == null) {
      return null;
    }
    return first.difference(second).abs();
  }

  /// Index of the sensor with the older scan time when [scanGap] exceeds
  /// [staleThreshold], null otherwise.
  int? get staleSensorIndex {
    final gap = scanGap;
    if (gap == null || gap <= staleThreshold) {
      return null;
    }
    return sensors[0].scanned!.isBefore(sensors[1].scanned!) ? 0 : 1;
  }
}
