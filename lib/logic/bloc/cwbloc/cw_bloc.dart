
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherBs/locator.dart';
import '../../../data/Models/CurrentCityModel.dart';
import '../../../data/Repositories/CurrentWeatherRepository.dart';

part 'cw_event.dart';
part 'cw_state.dart';

class CwBloc extends Bloc<CwEvent, CwState> {
  CwBloc() : super(CwLoading()) {

    final CurrentWeatherRepository currentWeatherRepository = locator<CurrentWeatherRepository>();

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
