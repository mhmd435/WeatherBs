
import 'package:dio/dio.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/suggest_city_entity.dart';
import '../data_source/remote/ApiProvider.dart';
import '../models/SuggestCityModel.dart';

class SuggestCityRepositoryImpl{
  final ApiProvider _apiProvider;

  SuggestCityRepositoryImpl(this._apiProvider);

  Future<List<Data>> fetchSuggestData(cityName) async {

      Response response = await _apiProvider.sendRequestCitySuggestion(cityName);

      SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);

      return suggestCityEntity.data!;

  }
}