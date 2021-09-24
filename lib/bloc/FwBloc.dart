import 'dart:async';
import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:weather_app/Models/CurrentCityDataModel.dart';
import 'package:weather_app/Models/ForecastDaysModel.dart';
import 'package:weather_app/Repository/ForecastWeatherRepository.dart';
import 'package:weather_app/networking/ResponseModel.dart';

class FwBloc{
  late ForecastWeatherRepository _forecastWeatherRepository;
  final StreamController _forcastStreamController = BehaviorSubject<ResponseModel<dynamic>>();

  StreamSink<dynamic>? get FWSink => _forcastStreamController.sink;

  Stream<dynamic>? get FWStream => _forcastStreamController.stream;

  FwBloc() {
    _forecastWeatherRepository = ForecastWeatherRepository();
  }

  fetchForecastWeather(lat,lon) async {
    FWSink!.add(ResponseModel.loading('Getting forecast Weather...'));
    try {
      List<ForecastDaysModel> list = await _forecastWeatherRepository.fetchForecastWeatherData(lat,lon);
      FWSink!.add(ResponseModel.completed(list));
    } catch (e) {
      FWSink!.add(ResponseModel.error(e.toString()));
      log("this is catch error fw " + e.toString());
    }
  }

  dispose() {
    _forcastStreamController.close();
  }
}