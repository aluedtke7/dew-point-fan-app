class SensorData {
  String name = '';
  double temperature = 0;
  double humidity = 0;
  double dewPoint = 0;
  double batLevel = 0;
  int rssi = 0;
  int upTime = 0;

  SensorData({
    this.name = '',
    this.temperature = 0,
    this.humidity = 0,
    this.dewPoint = 0,
    this.batLevel = 0,
    this.rssi = 0,
    this.upTime = 0,
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
    );
  }
}
