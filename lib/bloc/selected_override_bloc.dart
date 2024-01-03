import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dpfa/bloc/selected_override_event.dart';
import 'package:dpfa/bloc/selected_override_state.dart';
import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/repository/dew_point_repository.dart';

class SelectedOverrideBloc extends Bloc<SelectedOverrideEvent, SelectedOverrideState> {
  final DewPointRepository _dewPointRepository;

  SelectedOverrideBloc({required DewPointRepository repo})
      : _dewPointRepository = repo,
        super(const SelectedOverrideFirst(0)) {
    on<SelectedOverrideInitial>((event, emit) async {
      await emit.forEach(_dewPointRepository.dewPoints(),
          onData: (DewPointData dpd) => SelectedOverrideNew(dpd.remoteOverride));
    });
    on<SelectedOverrideNewData>((event, emit) async {
      await emit.forEach(_dewPointRepository.dewPoints(),
          onData: (DewPointData dpd) => SelectedOverrideNew(dpd.remoteOverride));
    });
  }
}
