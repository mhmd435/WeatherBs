
import '../../locator.dart';
import '../Models/ForcastDaysModel.dart';
import '../dataProviders/ApiProvider.dart';


class ForecastWeatherRepository{
  ApiProvider _provider = locator<ApiProvider>();

  Future<ForcastDaysModel> fetchForecastWeatherData(lat,lon) async {

    final response = await _provider.sendRequest7DaysForcast(lat,lon);

    ForcastDaysModel forecastDaysModel = ForcastDaysModel.fromJson(response.data);

    return forecastDaysModel;
  }
}