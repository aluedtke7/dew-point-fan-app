import 'package:dpfa/components/custom_themes.dart';
import 'package:flutter/material.dart';

/// Flat, rounded card with a thin outline: the common frame of the cards on
/// the main page.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.radius = 20,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  /// Fill of the card, [AppColors.cardBackground] when null.
  final Color? color;

  /// Outline of the card, [ColorScheme.outlineVariant] when null.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: color ?? scheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor ?? scheme.outlineVariant),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
