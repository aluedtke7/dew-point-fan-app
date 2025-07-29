import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({
    super.key,
    required this.sensorData,
  });

  final SensorData sensorData;

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
