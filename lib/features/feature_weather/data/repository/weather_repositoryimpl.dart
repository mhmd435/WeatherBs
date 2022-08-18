
import 'package:dio/dio.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/data/models/CurrentCityModel.dart';
import 'package:weatherBs/features/feature_weather/data/models/SuggestCityModel.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/suggest_city_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../data_source/remote/ApiProvider.dart';
import '../models/ForcastDaysModel.dart';

class WeatherRepositoryImpl extends WeatherRepository{
  ApiProvider _apiProvider;

  WeatherRepositoryImpl(this._apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName) async {
    try{
      Response response = await _apiProvider.sendRequestCurrentWeather(cityName);

      if(response.statusCode == 200){
        /// init model
        CurrentCityEntity currentCityEntity = CurrentCityModel.fromJson(response.data);
        /// convert Model to Entity
        // CurrentCityEntity currentCityEntity = currentCityModel.toEntity();
        return DataSuccess(currentCityEntity);
      }else{
        return DataFailed("Something Went Wrong. try again...");
      }
    }catch(e){
      print(e.toString());
      return DataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params) async {
    try{
      Response response = await _apiProvider.sendRequest7DaysForcast(params);

      if(response.statusCode == 200){
        ForecastDaysEntity forecastDaysEntity = ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      }else{
        return DataFailed("Something Went Wrong. try again...");
      }
    }catch(e){
      print(e.toString());
      return DataFailed("please check your connection...");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {

    Response response = await _apiProvider.sendRequestCitySuggestion(cityName);

    SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);

    return suggestCityEntity.data!;

  }
}