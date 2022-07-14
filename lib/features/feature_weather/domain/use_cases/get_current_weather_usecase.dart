
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/core/usecases/UseCase.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';


class GetCurrentWeatherUseCase implements UseCase<DataState<CurrentCityEntity>, String>{
  final WeatherRepository _weatherRepository;
  GetCurrentWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<CurrentCityEntity>> call(String params) {
    return _weatherRepository.fetchCurrentWeatherData(params);
  }

}