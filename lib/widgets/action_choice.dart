import 'package:dpfa/bloc/selected_override_bloc.dart';
import 'package:dpfa/bloc/selected_override_event.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/widgets/surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionChoice extends StatelessWidget {
  const ActionChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SelectedOverrideBloc>().state;

    void select(int value) {
      context.read<SelectedOverrideBloc>().add(const SelectedOverrideUserTap());
      context.read<DewPointRepository>().setOverride(value);
    }

    Widget segment(int value, String label, IconData icon) {
      final selected = state.data == value;
      return Expanded(
        child: _Segment(
          label: label,
          icon: icon,
          selected: selected,
          // The selected segment stays enabled for screen readers; tapping it again changes nothing.
          onTap: state.disabled
              ? null
              : () {
                  if (!selected) {
                    select(value);
                  }
                },
        ),
      );
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(5),
      radius: 18,
      child: Row(
        spacing: 4,
        children: [
          segment(0, i18n(context).action_auto, Icons.auto_mode),
          segment(1, i18n(context).action_on, Icons.play_arrow),
          segment(2, i18n(context).action_off, Icons.mode_fan_off),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    var foreground = selected ? scheme.onPrimary : scheme.onSurface;
    if (onTap == null) {
      foreground = foreground.withValues(alpha: 0.38);
    }

    return Semantics(
      button: true,
      enabled: onTap != null,
      selected: selected,
      child: Material(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
