import 'package:dpfa/components/custom_themes.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/extensions.dart';
import 'package:dpfa/models/sensor_data.dart';
import 'package:dpfa/widgets/surface_card.dart';
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localeName = i18n(context).localeName;
    final muted = textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600);

    return SurfaceCard(
      borderColor: staleBy != null ? scheme.warning : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            i18n(context).location((sensorData.name == 'Outside').toString()),
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (!sensorData.hasReading)
            _Hint(
              icon: Icons.sensors_off,
              color: scheme.error,
              text: i18n(context).no_sensor_data,
            )
          else if (staleBy != null)
            _Hint(
              icon: Icons.warning_amber,
              color: scheme.warning,
              text: i18n(context).stale_hint(staleBy!.inMinutes, staleBy!.inSeconds % 60),
            ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: sensorData.temperature.formatFixed(localeName),
              children: [
                TextSpan(
                  text: '°C',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
          ),
          const SizedBox(height: 12),
          _ValueRow(
            label: i18n(context).humidity_label,
            value: '${sensorData.humidity.formatFixed(localeName, 0)} %',
          ),
          const SizedBox(height: 6),
          _ValueRow(
            label: i18n(context).dew_point_label,
            value: '${sensorData.dewPoint.formatFixed(localeName)} °C',
            color: scheme.primary,
          ),
          const Divider(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _Meta(icon: Icons.battery_std, text: i18n(context).bat_level(sensorData.batLevel), style: muted),
              _Meta(icon: Icons.signal_cellular_alt, text: i18n(context).rssi(sensorData.rssi), style: muted),
            ],
          ),
          const SizedBox(height: 4),
          Text(i18n(context).up_time((sensorData.upTime / (24 * 60 * 60)).round()), style: muted),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, this.style});

  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: style?.color),
        const SizedBox(width: 4),
        Text(text, style: style),
      ],
    );
  }
}
