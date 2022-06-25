part of 'fw_bloc.dart';

@immutable
abstract class FwEvent {}

class LoadFwEvent extends FwEvent {
  ForecastParams forecastParams;
  LoadFwEvent(this.forecastParams);
}
