import 'package:flutter/material.dart';

import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/extensions.dart';
import 'package:dpfa/models/dew_point_data.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.dewPointData,
  });

  final DewPointData dewPointData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                if (dewPointData.update == null)
                  Text(i18n(context).update('---'))
                else
                  Text(i18n(context).update(dewPointData.update!.formatDateTime(i18n(context).localeName))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    i18n(context).fan_is(dewPointData.venting.toString()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textScaler: const TextScaler.linear(1.5),
                  ),
                ),
                Text(i18n(context).manual_override(dewPointData.override.toString())),
                Text(i18n(context).remote_override(dewPointData.remoteOverride)),
                Text(
                    '${i18n(context).difference(dewPointData.diffMin)} - ${i18n(context).hysteresis(dewPointData.hysteresis)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
