import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dpfa/bloc/dew_point_event.dart';
import 'package:dpfa/bloc/dew_point_state.dart';
import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/repository/dew_point_repository.dart';

class DewPointBloc extends Bloc<DewPointEvent, DewPointState> {
  final DewPointRepository _dewPointRepository;

  DewPointBloc({required DewPointRepository repo})
      : _dewPointRepository = repo,
        super(DewPointFirst(DewPointData())) {
    on<DewPointInitial>((event, emit) async {
      await emit.forEach(_dewPointRepository.dewPoints(), onData: (DewPointData dpd) {
        return DewPointNew(dpd);
      });
    });
    on<DewPointNewData>((event, emit) async {
      await emit.forEach(_dewPointRepository.dewPoints(), onData: (DewPointData dpd) {
        return DewPointNew(dpd);
      });
    });
    on<DewPointError>((event, emit) async {
      await emit.forEach(_dewPointRepository.dewPoints(), onData: (DewPointData dpd) {
        return DewPointNoData(dpd);
      });
    });
  }
}
