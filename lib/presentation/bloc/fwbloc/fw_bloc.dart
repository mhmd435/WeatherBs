
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/use_case/get_forecast_weather_usecase.dart';
import '../../../data/Models/ForcastDaysModel.dart';

part 'fw_event.dart';
part 'fw_state.dart';

class FwBloc extends Bloc<FwEvent, FwState> {
  final GetForecastWeatherUseCase _getForecastWeatherUseCase;

  FwBloc(this._getForecastWeatherUseCase) : super(FwLoading()) {

    on<LoadFwEvent>((event, emit) async {

      // change state to loading
      emit(FwLoading());

      DataState dataState = await _getForecastWeatherUseCase(event.forecastParams);

      if(dataState is DataSuccess){
        emit(FwCompleted(dataState.data));
      }

      if(dataState is DataFailed){
        emit(FwError(dataState.error));
      }

    });
  }
}
