

import '../../locator.dart';
import '../Models/CurrentCityModel.dart';
import '../dataProviders/ApiProvider.dart';

class CurrentWeatherRepository{
  ApiProvider _provider = locator<ApiProvider>();

  Future<CurrentCityModel> fetchCurrentWeatherData(cityname) async {

    final response = await _provider.sendRequestCurrentWeather(cityname);

    CurrentCityModel currentCityDataModel = CurrentCityModel.fromJson(response.data);

    return currentCityDataModel;
  }
}