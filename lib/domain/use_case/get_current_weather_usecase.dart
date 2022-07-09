
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/repositories/weather_repository.dart';
import '../Models/CurrentCityModel.dart';


class GetCurrentWeatherUseCase {
  final WeatherRepository _weatherRepository;
  GetCurrentWeatherUseCase(this._weatherRepository);

  Future<DataState<CurrentCityModel>> call(String params) {
    return _weatherRepository.fetchCurrentWeatherData(params);
  }

}