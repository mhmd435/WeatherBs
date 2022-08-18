part of 'home_bloc.dart';

class HomeState extends Equatable{
  final CwStatus cwStatus;
  final FwStatus fwStatus;

  HomeState({required this.cwStatus, required this.fwStatus});

  HomeState copyWith({
    CwStatus? newCwStatus,
    FwStatus? newFwStatus
  }){
    return HomeState(
        cwStatus: newCwStatus ?? this.cwStatus,
        fwStatus: newFwStatus ?? this.fwStatus
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    cwStatus,
    fwStatus
  ];
}
