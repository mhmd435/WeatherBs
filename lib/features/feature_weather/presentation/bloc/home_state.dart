part of 'home_bloc.dart';

class HomeState{
  CwStatus cwStatus;
  FwStatus fwStatus;

  HomeState({required this.cwStatus, required this.fwStatus});

  HomeState copyWith(
      CwStatus? newCwStatus,
      FwStatus? newFwStatus
  ){
    return HomeState(
        cwStatus: newCwStatus ?? this.cwStatus,
        fwStatus: newFwStatus ?? this.fwStatus
    );
  }
}
