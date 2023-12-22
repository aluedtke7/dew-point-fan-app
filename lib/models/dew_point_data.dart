import 'package:dpfa/models/sensor_data.dart';

class DewPointData {
  DateTime? update;
  List<SensorData> sensors = <SensorData>[];
  bool venting = false;
  bool override = false;
  int remoteOverride = 0;
  int diffMin = 0;
  int hysteresis = 0;

  DewPointData({
    this.update,
    this.sensors = const [],
    this.venting = false,
    this.override = false,
    this.remoteOverride = 0,
    this.diffMin = 0,
    this.hysteresis = 0,
  });

  factory DewPointData.fromJson(Map<String, dynamic> json){
    List<dynamic> sensorData = json['sensors'];
    sensorData.removeWhere((element) => element == null);
    return DewPointData(
      update: DateTime.tryParse(json['update'] ?? ''),
      sensors: sensorData.isEmpty ? [] : sensorData.map((e) => SensorData.fromJson(e)).toList(),
      venting: json['venting'],
      override: json['override'],
      remoteOverride: json['remote_override'] ?? 0,
      diffMin: json['diff_min'] ?? 0,
      hysteresis: json['hysteresis'] ?? 0,
    );
  }
}