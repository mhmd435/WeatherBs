
import 'package:weather_app/data/Models/CurrentCityModel.dart';
import 'package:weather_app/data/dataProviders/ApiProvider.dart';

class CurrentWeatherRepository{
  ApiProvider _provider = ApiProvider();

  Future<CurrentCityModel> fetchCurrentWeatherData(cityname) async {

    final response = await _provider.sendRequestCurrentWeather(cityname);

    CurrentCityModel currentCityDataModel = CurrentCityModel.fromJson(response.data);

    return currentCityDataModel;
  }
}