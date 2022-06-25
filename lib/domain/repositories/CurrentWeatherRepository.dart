
import 'package:weatherBs/core/resources/data_state.dart';
import '../../data/Models/CurrentCityModel.dart';

abstract class CurrentWeatherRepository{

  Future<DataState<CurrentCityModel>> fetchCurrentWeatherData(String cityName);

}