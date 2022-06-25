
import 'package:dio/dio.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import '../../domain/repositories/CurrentWeatherRepository.dart';
import '../Models/CurrentCityModel.dart';
import '../data_sources/remote/ApiProvider.dart';

class CurrentWeatherRepositoryImpl extends CurrentWeatherRepository{
  final ApiProvider _apiProvider;

  CurrentWeatherRepositoryImpl(this._apiProvider);

  @override
  Future<DataState<CurrentCityModel>> fetchCurrentWeatherData(cityName) async {
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
        return DataFailed("please check your connection");
      }
  }
}