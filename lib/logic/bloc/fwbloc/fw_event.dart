part of 'fw_bloc.dart';

@immutable
abstract class FwEvent {}

class LoadFwEvent extends FwEvent {
  final double lat;
  final double lon;
  LoadFwEvent(this.lat, this.lon);
}
