
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/params/ForecastParams.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/use_cases/get_current_weather_usecase.dart';
import '../../domain/use_cases/get_forecast_weather_usecase.dart';
import 'cw_status.dart';
import 'fw_status.dart';
part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase _getForecastWeatherUseCase;

  HomeBloc(this._getCurrentWeatherUseCase, this._getForecastWeatherUseCase) : super(HomeState(cwStatus: CwLoading(), fwStatus: FwLoading())) {

    /// load current city Event
    on<LoadCwEvent>((event, emit) async {

      /// emit State to Loading for just Cw
      emit(state.copyWith(newCwStatus: CwLoading()));

      DataState dataState = await _getCurrentWeatherUseCase(event.cityName);

      /// emit State to Completed for Just Cw
      if(dataState is DataSuccess){
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }

      /// emit State to Error for Just Cw
      if(dataState is DataFailed){
        emit(state.copyWith(newCwStatus: CwError(dataState.error)));
      }
    });


    /// load 7 days Forecast weather for city Event
    on<LoadFwEvent>((event, emit) async {

      /// emit State to Loading for just Fw
      emit(state.copyWith(newFwStatus: FwLoading()));

      DataState dataState = await _getForecastWeatherUseCase(event.forecastParams);

      /// emit State to Completed for just Fw
      if(dataState is DataSuccess){
        emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
      }

      /// emit State to Error for just Fw
      if(dataState is DataFailed){
        emit(state.copyWith(newFwStatus: FwError(dataState.error)));
      }

    });

  }
}
