

import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/core/usecases/UseCase.dart';
import 'package:weatherBs/domain/repositories/CurrentWeatherRepository.dart';

import '../../data/Models/CurrentCityModel.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentCityModel>, String> {

  final CurrentWeatherRepository _currentWeatherRepository;

  GetCurrentWeatherUseCase(this._currentWeatherRepository);


  @override
  Future<DataState<CurrentCityModel>> call(String params) {
    return _currentWeatherRepository.fetchCurrentWeatherData(params);
  }

}