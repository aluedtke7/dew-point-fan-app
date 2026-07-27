import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    super.key,
    required this.sensorData,
    this.staleBy,
  });

  final SensorData sensorData;

  /// How far this sensor's scan time lags the other sensor's. Non-null marks
  /// this sensor as stale.
  final Duration? staleBy;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  i18n(context).location((sensorData.name == 'Outside').toString()),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (!sensorData.hasReading)
              Row(
                children: [
                  Icon(Icons.sensors_off, color: Colors.red.shade700, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    i18n(context).no_sensor_data,
                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            else if (staleBy != null)
              Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade800, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    i18n(context).stale_hint(staleBy!.inMinutes, staleBy!.inSeconds % 60),
                    style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            Divider(),
            Row(
              spacing: 24,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(i18n(context).temperature(sensorData.temperature)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i18n(context).humidity(sensorData.humidity)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i18n(context).dew_point(sensorData.dewPoint)),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(i18n(context).up_time((sensorData.upTime / (24 * 60 * 60)).round())),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i18n(context).rssi(sensorData.rssi)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i18n(context).bat_level(sensorData.batLevel)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
