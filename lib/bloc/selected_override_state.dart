import 'package:equatable/equatable.dart';

sealed class SelectedOverrideState extends Equatable {
  const SelectedOverrideState(this.data, {this.disabled = false});

  final int data;
  final bool disabled;

  @override
  List<Object> get props => [data, disabled];
}

final class SelectedOverrideFirst extends SelectedOverrideState {
  const SelectedOverrideFirst(super.data, {super.disabled = false});

  @override
  String toString() => 'SelectedOverrideFirst {$data, disabled: $disabled}';
}

final class SelectedOverrideNew extends SelectedOverrideState {
  const SelectedOverrideNew(super.data, {super.disabled = false});

  @override
  String toString() => 'SelectedOverrideNew {$data, disabled: $disabled}';
}
