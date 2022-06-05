import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/data/Repositories/ForecastWeatherRepository.dart';

import '../../../data/Models/ForcastDaysModel.dart';

part 'fw_event.dart';
part 'fw_state.dart';

class FwBloc extends Bloc<FwEvent, FwState> {
  FwBloc() : super(FwLoading()) {

    final ForecastWeatherRepository forecastWeatherRepository = ForecastWeatherRepository();

    on<LoadFwEvent>((event, emit) async {

      // change state to loading
      emit(FwLoading());

      try{
        final response = await forecastWeatherRepository.fetchForecastWeatherData(event.lat, event.lon);
        emit(FwCompleted(response));
      }catch(e){
        emit(FwError(e.toString()));
        print(e);
      }
    });
  }
}
