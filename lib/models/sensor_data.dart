class SensorData {
  String name = '';
  double temperature = 0;
  double humidity = 0;
  double dewPoint = 0;
  double batLevel = 0;
  int rssi = 0;
  int upTime = 0;
  DateTime? scanned;

  SensorData({
    this.name = '',
    this.temperature = 0,
    this.humidity = 0,
    this.dewPoint = 0,
    this.batLevel = 0,
    this.rssi = 0,
    this.upTime = 0,
    this.scanned,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      name: json['name'],
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      dewPoint: json['dew_point'].toDouble(),
      batLevel: json['bat_level'].toDouble(),
      rssi: json['rssi'].toInt(),
      upTime: json['up_time_in_sec'].toInt(),
      scanned: DateTime.tryParse(json['scanned'] ?? ''),
    );
  }

  /// False when the sensor never delivered a reading: no scan time and every
  /// value still at its default. The server reports such a sensor with all
  /// zeroes, which no live beacon produces (0 % humidity, 0 dBm RSSI).
  bool get hasReading =>
      scanned != null ||
      temperature != 0 ||
      humidity != 0 ||
      dewPoint != 0 ||
      batLevel != 0 ||
      rssi != 0 ||
      upTime != 0;
}
