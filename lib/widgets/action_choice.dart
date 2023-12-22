import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/provider/dew_point_provider.dart';

class ActionChoice extends ConsumerStatefulWidget {
  const ActionChoice({super.key});

  @override
  ConsumerState<ActionChoice> createState() => _ActionChoiceState();
}

class _ActionChoiceState extends ConsumerState<ActionChoice> {
  @override
  Widget build(BuildContext context) {
    final selectedOverrideRef = ref.watch(selectedOverrideProvider);

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
      selected: <int>{selectedOverrideRef},
      onSelectionChanged: (Set<int> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          // widget.selectedAction = newSelection.first;
          ref.read(dewPointDataProvider.notifier).setOverride(newSelection.first);
        });
      },
    );
  }
}
