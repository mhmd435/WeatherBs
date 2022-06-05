part of 'cw_bloc.dart';

@immutable
abstract class CwState {}

// loading state
class CwLoading extends CwState{}

// loaded state
class CwCompleted extends CwState{
  final CurrentCityModel currentCityModel;
  CwCompleted(this.currentCityModel);
}

// error state
class CwError extends CwState{
  final String? message;
  CwError(this.message);
}
