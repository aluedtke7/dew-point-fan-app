import 'dart:math' as math;

import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/widgets/surface_card.dart';

import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.dewPointData,
  });

  final DewPointData dewPointData;

  /// Reason codes of the controller (see `reasons` in the ARB files).
  static const _reasonNoData = 1;
  static const _overrideReasons = {9, 10};

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final connected = dewPointData.update != null;
    final venting = connected && dewPointData.venting;
    final foreground = venting ? scheme.onPrimary : scheme.onSurface;
    // An override reason already names the override, the mode line would repeat it.
    final showOverride = connected && !_overrideReasons.contains(dewPointData.reason);

    return SurfaceCard(
      radius: 24,
      padding: const EdgeInsets.all(20),
      color: venting ? scheme.primary : null,
      borderColor: venting ? scheme.primary : null,
      child: IconTheme.merge(
        data: IconThemeData(color: foreground),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foreground),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: foreground.withValues(alpha: 0.12),
                    ),
                    child: _FanIcon(spinning: venting),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i18n(context).fan_label.toUpperCase(),
                          style: textTheme.labelLarge?.copyWith(color: foreground, letterSpacing: 1),
                        ),
                        Text(
                          connected ? i18n(context).fan_state(venting.toString()) : i18n(context).fan_unknown,
                          style: textTheme.headlineMedium?.copyWith(color: foreground, fontWeight: FontWeight.w800),
                        ),
                        if (showOverride)
                          Text(
                            i18n(context).remote_override(dewPointData.remoteOverride),
                            style: textTheme.titleSmall?.copyWith(color: foreground),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: foreground.withValues(alpha: 0.08),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        i18n(context).reasons((connected ? dewPointData.reason : _reasonNoData).toString()),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fan symbol that keeps turning while [spinning] is set.
class _FanIcon extends StatefulWidget {
  const _FanIcon({required this.spinning});

  final bool spinning;

  @override
  State<_FanIcon> createState() => _FanIconState();
}

class _FanIconState extends State<_FanIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(_FanIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  void _update() {
    if (widget.spinning && !MediaQuery.disableAnimationsOf(context)) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: const Size.square(56),
        painter: _FanPainter(IconTheme.of(context).color!),
      ),
    );
  }
}

/// Paints a three-bladed fan, as Material has no fan icon.
class _FanPainter extends CustomPainter {
  const _FanPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;
    final paint = Paint()..color = color;
    final blade = Path()
      ..moveTo(0, 0)
      ..cubicTo(-r * 0.7, -r * 0.05, -r * 0.75, -r * 0.9, -r * 0.1, -r * 0.98)
      ..cubicTo(r * 0.35, -r * 1.02, r * 0.6, -r * 0.75, r * 0.32, -r * 0.5)
      ..cubicTo(r * 0.15, -r * 0.33, r * 0.25, -r * 0.1, 0, 0)
      ..close();

    canvas.translate(size.width / 2, size.height / 2);
    for (var i = 0; i < 3; i++) {
      canvas.drawPath(blade, paint);
      canvas.rotate(2 * math.pi / 3);
    }
    canvas.drawCircle(Offset.zero, r * 0.18, paint);
  }

  @override
  bool shouldRepaint(_FanPainter oldDelegate) => oldDelegate.color != color;
}
