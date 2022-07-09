
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/params/ForecastParams.dart';
import '../../../core/resources/data_state.dart';
import '../../../domain/use_case/get_current_weather_usecase.dart';
import '../../../domain/use_case/get_forecast_weather_usecase.dart';
import 'cw_status.dart';
import 'fw_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase _getForecastWeatherUseCase;

  HomeBloc(this._getCurrentWeatherUseCase, this._getForecastWeatherUseCase) : super(HomeState(cwStatus: CwLoading(), fwStatus: FwLoading())) {

    /// load current city Event
    on<LoadCwEvent>((event, emit) async {

      /// emit State to Loading for just Cw
      emit(state.copyWith(CwLoading(), null));

      DataState dataState = await _getCurrentWeatherUseCase.call(event.cityName);

      /// emit State to Completed for Just Cw
      if(dataState is DataSuccess){
        emit(state.copyWith(CwCompleted(dataState.data), null));
      }

      /// emit State to Error for Just Cw
      if(dataState is DataFailed){
        emit(state.copyWith(CwError(dataState.error), null));
      }
    });


    /// load 7 days Forecast weather for city Event
    on<LoadFwEvent>((event, emit) async {

      /// emit State to Loading for just Fw
      emit(state.copyWith(null, FwLoading()));

      DataState dataState = await _getForecastWeatherUseCase.call(event.forecastParams);

      /// emit State to Completed for just Fw
      if(dataState is DataSuccess){
        emit(state.copyWith(null, FwCompleted(dataState.data)));
      }

      /// emit State to Error for just Fw
      if(dataState is DataFailed){
        emit(state.copyWith(null, FwError(dataState.error)));
      }

    });

  }
}
