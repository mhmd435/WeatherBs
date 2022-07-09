
import 'package:dio/dio.dart';
import '../../domain/Models/SuggestCityModel.dart';
import '../data_sources/remote/ApiProvider.dart';

class SuggestCityRepositoryImpl{
  final ApiProvider _apiProvider;

  SuggestCityRepositoryImpl(this._apiProvider);


  Future<List<Data>> fetchSuggestData(cityName) async {

      Response response = await _apiProvider.sendRequestCitySuggestion(cityName);

      SuggestCityModel suggestCityModel = SuggestCityModel.fromJson(response.data);

      return suggestCityModel.data!;

  }
}