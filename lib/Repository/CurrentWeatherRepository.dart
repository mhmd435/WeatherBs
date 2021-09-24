import 'package:weather_app/Models/CurrentCityDataModel.dart';
import 'package:weather_app/networking/ApiProvider.dart';

class CurrentWeatherRepository{
  ApiProvider _provider = ApiProvider();

  Future<CurrentCityDataModel> fetchCurrentWeatherData(cityname) async {
    var dataModel;

    final response = await _provider.SendRequestCurrentWeather(cityname);

    dataModel = CurrentCityDataModel(
        response.data["name"],
        response.data["coord"]["lon"],
        response.data["coord"]["lat"],
        response.data["weather"][0]["main"],
        response.data["weather"][0]["description"],
        response.data["main"]["temp"],
        response.data["main"]["temp_min"],
        response.data["main"]["temp_max"],
        response.data["main"]["pressure"],
        response.data["main"]["humidity"],
        response.data["wind"]["speed"],
        response.data["dt"],
        response.data["sys"]["country"],
        response.data["sys"]["sunrise"],
        response.data["sys"]["sunset"]);
    return dataModel;
  }
}