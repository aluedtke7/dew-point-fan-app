import 'dart:math' as math;

import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/extensions.dart';
import 'package:dpfa/widgets/surface_card.dart';
import 'package:flutter/material.dart';

/// Shows the dew point difference on a bar with markers at the minimum
/// difference and at minimum difference plus hysteresis, the point from which
/// the controller starts venting.
class DifferenceCard extends StatelessWidget {
  const DifferenceCard({
    super.key,
    required this.difference,
    required this.diffMin,
    required this.hysteresis,
  });

  final double difference;
  final int diffMin;
  final int hysteresis;

  static const _barHeight = 10.0;
  static const _markerHeight = 18.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scale = math.max(2.0 * (diffMin + hysteresis), difference);
    double fraction(num value) => scale <= 0 ? 0 : (value / scale).clamp(0.0, 1.0);

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  i18n(context).difference_title,
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: difference.formatFixed(i18n(context).localeName),
                  children: const [TextSpan(text: ' K', style: TextStyle(fontSize: 15))],
                ),
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: scheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: _markerHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                Widget marker(num value, Color color) => Positioned(
                      left: fraction(value) * width - 1,
                      top: 0,
                      child: Container(width: 2, height: _markerHeight, color: color),
                    );
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: (_markerHeight - _barHeight) / 2,
                      child: Container(
                        height: _barHeight,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(_barHeight / 2),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: fraction(difference),
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(_barHeight / 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    marker(diffMin, scheme.onSurface),
                    marker(diffMin + hysteresis, scheme.onSurfaceVariant),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            i18n(context).hysteresis(diffMin, hysteresis),
            style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
