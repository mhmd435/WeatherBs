
import 'package:weather_app/data/Models/CurrentCityModel.dart';
import 'package:weather_app/data/Models/SuggestCityModel.dart';
import 'package:weather_app/data/dataProviders/ApiProvider.dart';

class SuggestCityRepository{
  ApiProvider _provider = ApiProvider();

  Future<List<Data>> fetchSuggestData(cityName) async {

    final response = await _provider.sendRequestCitySuggestion(cityName);

    SuggestCityModel suggestCityModel = SuggestCityModel.fromJson(response.data);

    return suggestCityModel.data!;
  }
}