
import 'package:dio/dio.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/data/data_sources/remote/ApiProvider.dart';
import 'package:weatherBs/domain/Models/CurrentCityModel.dart';
import 'package:weatherBs/domain/Models/ForcastDaysModel.dart';
import '../../domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository{
  ApiProvider _apiProvider;

  WeatherRepositoryImpl(this._apiProvider);

  @override
  Future<DataState<CurrentCityModel>> fetchCurrentWeatherData(String cityName) async {
    try{
      Response response = await _apiProvider.sendRequestCurrentWeather(cityName);

      if(response.statusCode == 200){
        CurrentCityModel currentCityDataModel = CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityDataModel);
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