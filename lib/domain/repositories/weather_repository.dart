
import 'package:weatherBs/core/resources/data_state.dart';

import '../../core/params/ForecastParams.dart';
import '../Models/CurrentCityModel.dart';
import '../Models/ForcastDaysModel.dart';

abstract class WeatherRepository{

  Future<DataState<CurrentCityModel>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForcastDaysModel>> fetchForecastWeatherData(ForecastParams params);

}