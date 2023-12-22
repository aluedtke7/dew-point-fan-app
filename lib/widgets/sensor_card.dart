import 'package:flutter/material.dart';

import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/sensor_data.dart';

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
      ),
    );
  }
}
