
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';

import '../../data/models/ForcastDaysModel.dart';

class GetForecastWeatherUseCase {
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  Future<DataState<ForcastDaysModel>> call(params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }

}