import 'package:weather_app/data/Models/ForcastDaysModel.dart';
import 'package:weather_app/data/dataProviders/ApiProvider.dart';


class ForecastWeatherRepository{
  ApiProvider _provider = ApiProvider();

  Future<ForcastDaysModel> fetchForecastWeatherData(lat,lon) async {

    final response = await _provider.sendRequest7DaysForcast(lat,lon);

    ForcastDaysModel forecastDaysModel = ForcastDaysModel.fromJson(response.data);

    return forecastDaysModel;
  }
}