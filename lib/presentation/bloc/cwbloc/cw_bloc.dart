
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/use_case/get_current_weather_usecase.dart';
import '../../../data/Models/CurrentCityModel.dart';

part 'cw_event.dart';
part 'cw_state.dart';

class CwBloc extends Bloc<CwEvent, CwState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;

  CwBloc(this._getCurrentWeatherUseCase) : super(CwLoading()) {
    
    on<LoadCwEvent>((event, emit) async {

      // change state to loading
      emit(CwLoading());

      DataState dataState = await _getCurrentWeatherUseCase(event.cityName);

      if(dataState is DataSuccess){
        emit(CwCompleted(dataState.data));
      }

      if(dataState is DataFailed){
        emit(CwError(dataState.error));
      }

    });
  }
}
