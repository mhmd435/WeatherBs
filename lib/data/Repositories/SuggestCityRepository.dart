
import '../../locator.dart';
import '../Models/SuggestCityModel.dart';
import '../dataProviders/ApiProvider.dart';

class SuggestCityRepository{
  ApiProvider _provider = locator<ApiProvider>();

  Future<List<Data>> fetchSuggestData(cityName) async {

    final response = await _provider.sendRequestCitySuggestion(cityName);

    SuggestCityModel suggestCityModel = SuggestCityModel.fromJson(response.data);

    return suggestCityModel.data!;
  }
}