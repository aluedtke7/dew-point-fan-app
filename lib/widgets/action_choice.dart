import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dpfa/bloc/selected_override_bloc.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/repository/dew_point_repository.dart';

class ActionChoice extends StatefulWidget {
  const ActionChoice({super.key});

  @override
  State<ActionChoice> createState() => _ActionChoiceState();
}

class _ActionChoiceState extends State<ActionChoice> {
  final dewPointRepo = DewPointRepository();

  @override
  Widget build(BuildContext context) {
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
      selected: <int>{BlocProvider.of<SelectedOverrideBloc>(context, listen: true).state.data},
      onSelectionChanged: (Set<int> newSelection) {
        // By default there is only a single segment that can be
        // selected at one time, so its value is always the first
        // item in the selected set.
        dewPointRepo.setOverride(newSelection.first);
      },
    );
  }
}
