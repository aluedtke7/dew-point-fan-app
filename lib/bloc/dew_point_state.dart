import 'package:equatable/equatable.dart';

import 'package:dpfa/models/dew_point_data.dart';

sealed class DewPointState extends Equatable {
  const DewPointState(this.data);
  final DewPointData data;

  @override
  List<Object> get props => [data];
}

final class DewPointFirst extends DewPointState {
  const DewPointFirst(super.data);

  @override
  String toString() => 'DewPointFirst {$data}';
}

final class DewPointNew extends DewPointState {
  const DewPointNew(super.data);

  @override
  String toString() => 'DewPointNew {$data}';
}

final class DewPointNoData extends DewPointState {
  const DewPointNoData(super.data);

  @override
  String toString() => 'DewPointNoData {$data}';
}
