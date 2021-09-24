import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'CustomException.dart';

class ApiProvider{
  // var lat = 35.6944;
  // var lon = 51.4215;


  Future<dynamic> SendRequestCurrentWeather(cityname) async {
    var apiKey = 'ff3dc1b7abb61e297479eec257ec60e8';
    var responseJson;

      var response = await Dio().get(
          "https://api.openweathermap.org/data/2.5/weather",
          queryParameters: {'q': cityname, 'appid': apiKey, 'units': 'metric'});

      // lat = response.data["coord"]["lat"];
      // lon = response.data["coord"]["lon"];

      responseJson = _response(response);
      return responseJson;
  }

  Future<dynamic> SendRequest7DaysForcast(lat,lon) async {
    var responseJson;
    var apiKey = 'ff3dc1b7abb61e297479eec257ec60e8';


    var response = await Dio().get(
          "https://api.openweathermap.org/data/2.5/onecall",
          queryParameters: {
            'lat': lat,
            'lon': lon,
            'exclude': 'minutely,hourly',
            'appid': apiKey,
            'units': 'metric'
          });

      responseJson = _response(response);

      return responseJson;
  }

  dynamic _response(response) {
    switch (response.statusCode) {
      case 200:
        // var responseJson = json.decode(response.data.toString());
        return response;
      case 400:
        throw BadRequestException(response.requestOptions.baseUrl + response.data.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}