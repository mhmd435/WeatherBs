
import 'package:dio/dio.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/utlis/constants.dart';

class ApiProvider{
  // var lat = 35.6944;
  // var lon = 51.4215;

  Dio _dio = Dio();


  Future<dynamic> sendRequestCurrentWeather(cityname) async {
    var apiKey = 'ff3dc1b7abb61e297479eec257ec60e8';

    var response = await _dio.get(
        Constants.baseUrl + "/data/2.5/weather",
        queryParameters: {'q': cityname, 'appid': apiKey, 'units': 'metric'});

      // lat = response.data["coord"]["lat"];
      // lon = response.data["coord"]["lon"];

    return response;
  }

  Future<dynamic> sendRequest7DaysForcast(ForecastParams params) async {
    var apiKey = 'ff3dc1b7abb61e297479eec257ec60e8';


    var response = await _dio.get(
          Constants.baseUrl + "/data/2.5/onecall",
          queryParameters: {
            'lat': params.lat,
            'lon': params.lon,
            'exclude': 'minutely,hourly',
            'appid': apiKey,
            'units': 'metric'
          });

    return response;
  }

  Future<dynamic> sendRequestCitySuggestion(String prefix) async {

    var response = await _dio.get(
        "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
        queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

    return response;
  }
}