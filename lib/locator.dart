import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'data/Repositories/CurrentWeatherRepository.dart';
import 'data/Repositories/ForecastWeatherRepository.dart';
import 'data/Repositories/SuggestCityRepository.dart';
import 'data/dataProviders/ApiProvider.dart';

GetIt locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());
  locator.registerSingleton<CurrentWeatherRepository>(CurrentWeatherRepository());
  locator.registerSingleton<ForecastWeatherRepository>(ForecastWeatherRepository());
  locator.registerSingleton<SuggestCityRepository>(SuggestCityRepository());
  // locator.registerLazySingleton<Dio>(() => Dio());

// Alternatively you could write it if you don't like global variables
//   GetIt.I.registerSingleton<AppModel>(AppModel());
}