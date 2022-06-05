part of 'fw_bloc.dart';

@immutable
abstract class FwState {}

// loading state
class FwLoading extends FwState{}

// loaded state
class FwCompleted extends FwState{
  final ForcastDaysModel forcastDaysModel;
  FwCompleted(this.forcastDaysModel);
}

// error state
class FwError extends FwState{
  final String? message;
  FwError(this.message);
}