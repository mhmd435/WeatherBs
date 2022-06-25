
import 'package:dio/dio.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import '../../domain/repositories/ForecastWeatherRepository.dart';
import '../Models/ForcastDaysModel.dart';
import '../data_sources/remote/ApiProvider.dart';


class ForecastWeatherRepositoryImpl extends ForecastWeatherRepository{

  final ApiProvider _apiProvider;

  ForecastWeatherRepositoryImpl(this._apiProvider);

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
      return DataFailed("please check your connection");
    }
  }
}