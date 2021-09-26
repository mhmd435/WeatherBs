import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weather_app/Models/CurrentCityDataModel.dart';
import 'package:weather_app/Repository/CurrentWeatherRepository.dart';
import 'package:weather_app/networking/ResponseModel.dart';

class CWBloc{
  late CurrentWeatherRepository _currentWeatherRepository;
  final StreamController _currntWeatherController = BehaviorSubject<ResponseModel<dynamic>>();

  StreamSink<dynamic>? get CWSink => _currntWeatherController.sink;

  Stream<dynamic>? get CWStream => _currntWeatherController.stream;

  CWBloc(String cityName) {
    _currentWeatherRepository = CurrentWeatherRepository();
    fetchCurrntWeather(cityName);
  }

  void fetchCurrntWeather(String cityname) async {
    CWSink!.add(ResponseModel.loading('Getting Current Weather...'));
    try {
      CurrentCityDataModel currentCityDataModel = await _currentWeatherRepository.fetchCurrentWeatherData(cityname);
      CWSink!.add(ResponseModel.completed(currentCityDataModel));
    } catch (e) {
      CWSink!.add(ResponseModel.error("Check your connection..."));
      print(e);
    }
  }

  dispose() {
    _currntWeatherController.close();
  }
}