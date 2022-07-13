
import 'package:dio/dio.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/data/models/CurrentCityModel.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
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
        CurrentCityEntity currentCityEntity = CurrentCityModel.fromJson(response.data);
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
  Future<DataState<ForcastDaysModel>> fetchForecastWeatherData(ForecastParams params) async {
    try{
      Response response = await _apiProvider.sendRequest7DaysForcast(params);

      if(response.statusCode == 200){
        ForcastDaysModel forecastDaysModel = ForcastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysModel);
      }else{
        return DataFailed("Something Went Wrong. try again...");
      }
    }catch(e){
      print(e.toString());
      return DataFailed("please check your connection...");
    }
  }
}