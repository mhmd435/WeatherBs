
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import '../../../../core/params/ForecastParams.dart';
import '../../data/models/ForcastDaysModel.dart';

abstract class WeatherRepository{

  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForcastDaysModel>> fetchForecastWeatherData(ForecastParams params);

}