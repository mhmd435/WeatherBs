
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/data/Repositories/CurrentWeatherRepository.dart';

import '../../../data/Models/CurrentCityModel.dart';

part 'cw_event.dart';
part 'cw_state.dart';

class CwBloc extends Bloc<CwEvent, CwState> {
  CwBloc() : super(CwLoading()) {

    final CurrentWeatherRepository currentWeatherRepository = CurrentWeatherRepository();

    on<LoadCwEvent>((event, emit) async {

      // change state to loading
      emit(CwLoading());

      try{
        final response = await currentWeatherRepository.fetchCurrentWeatherData(event.cityName);
        emit(CwCompleted(response));
      }catch(e){
        emit(CwError(e.toString()));
      }

    });
  }
}
