import 'package:dpfa/bloc/selected_override_bloc.dart';
import 'package:dpfa/bloc/selected_override_event.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionChoice extends StatelessWidget {
  const ActionChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SelectedOverrideBloc>().state;

    return SegmentedButton<int>(
      segments: <ButtonSegment<int>>[
        ButtonSegment<int>(
          value: 0,
          label: Text(i18n(context).action_auto),
          icon: const Icon(Icons.auto_mode),
        ),
        ButtonSegment<int>(
          value: 1,
          label: Text(i18n(context).action_on),
          icon: const Icon(Icons.play_arrow),
        ),
        ButtonSegment<int>(
          value: 2,
          label: Text(i18n(context).action_off),
          icon: const Icon(Icons.mode_fan_off),
        ),
      ],
      selected: <int>{state.data},
      onSelectionChanged: state.disabled
          ? null
          : (Set<int> newSelection) {
              context.read<SelectedOverrideBloc>().add(const SelectedOverrideUserTap());
              context.read<DewPointRepository>().setOverride(newSelection.first);
            },
    );
  }
}
