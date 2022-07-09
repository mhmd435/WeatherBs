
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/Models/ForcastDaysModel.dart';
import 'package:weatherBs/domain/repositories/weather_repository.dart';

class GetForecastWeatherUseCase {
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  Future<DataState<ForcastDaysModel>> call(params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }

}