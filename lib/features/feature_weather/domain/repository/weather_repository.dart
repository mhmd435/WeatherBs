
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/data/models/SuggestCityModel.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import '../../../../core/params/ForecastParams.dart';

abstract class WeatherRepository{

  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);

}