
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';

class GetForecastWeatherUseCase {
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  Future<DataState<ForecastDaysEntity>> call(params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }

}