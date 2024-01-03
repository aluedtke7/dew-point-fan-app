import 'package:equatable/equatable.dart';

sealed class SelectedOverrideState extends Equatable {
  const SelectedOverrideState(this.data);

  final int data;

  @override
  List<Object> get props => [data];
}

final class SelectedOverrideFirst extends SelectedOverrideState {
  const SelectedOverrideFirst(super.data);

  @override
  String toString() => 'SelectedOverrideFirst {$data}';
}

final class SelectedOverrideNew extends SelectedOverrideState {
  const SelectedOverrideNew(super.data);

  @override
  String toString() => 'SelectedOverrideNew {$data}';
}
