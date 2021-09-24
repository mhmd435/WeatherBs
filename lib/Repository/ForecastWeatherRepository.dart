import 'package:intl/intl.dart';
import 'package:weather_app/Models/ForecastDaysModel.dart';
import 'package:weather_app/networking/ApiProvider.dart';

class ForecastWeatherRepository{
  ApiProvider _provider = ApiProvider();

  Future<List<ForecastDaysModel>> fetchForecastWeatherData(lat,lon) async {
    List<ForecastDaysModel> list = [];

    final response = await _provider.SendRequest7DaysForcast(lat,lon);
    final formatter = DateFormat.MMMd();

    for (int i = 0; i < 8; i++) {
      var model = response.data['daily'][i];

      //change dt to our dateFormat ---Jun 23--- for Example
      var dt = formatter.format(new DateTime.fromMillisecondsSinceEpoch(
          model['dt'] * 1000,
          isUtc: true));

      ForecastDaysModel forecastDaysModel = new ForecastDaysModel(
        dt,
        model['temp']['day'],
        model['weather'][0]['main'],
        model['weather'][0]['description'],
        model['humidity'],
      );
      list.add(forecastDaysModel);
    }
    return list;
  }
}