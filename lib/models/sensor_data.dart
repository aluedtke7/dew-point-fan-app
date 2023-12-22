class SensorData {
  String name = '';
  double temperature = 0;
  double humidity = 0;
  double dewPoint = 0;

  SensorData({
    this.name = '',
    this.temperature = 0,
    this.humidity = 0,
    this.dewPoint = 0,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      name: json['name'],
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      dewPoint: json['dew_point'].toDouble(),
    );
  }
}
