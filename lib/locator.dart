import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:weatherBs/data/repositories/CurrentWeatherRepositoryImpl.dart';
import 'package:weatherBs/data/repositories/ForecastWeatherRepositoryImpl.dart';
import 'package:weatherBs/data/repositories/SuggestCityRepositoryImpl.dart';
import 'package:weatherBs/domain/use_case/get_current_weather_usecase.dart';
import 'package:weatherBs/domain/use_case/get_forecast_weather_usecase.dart';
import 'package:weatherBs/presentation/bloc/cwbloc/cw_bloc.dart';
import 'package:weatherBs/presentation/bloc/fwbloc/fw_bloc.dart';
import 'data/data_sources/remote/ApiProvider.dart';
import 'domain/repositories/CurrentWeatherRepository.dart';
import 'domain/repositories/ForecastWeatherRepository.dart';

GetIt locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  // inject Repositories
  locator.registerSingleton<CurrentWeatherRepository>(CurrentWeatherRepositoryImpl(locator()));
  locator.registerSingleton<ForecastWeatherRepository>(ForecastWeatherRepositoryImpl(locator()));
  locator.registerSingleton<SuggestCityRepositoryImpl>(SuggestCityRepositoryImpl(locator()));

  // inject UseCases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUseCase>(GetForecastWeatherUseCase(locator()));

  locator.registerSingleton<CwBloc>(CwBloc(locator()));
  locator.registerSingleton<FwBloc>(FwBloc(locator()));
  // locator.registerLazySingleton<Dio>(() => Dio());

// Alternatively you could write it if you don't like global variables
//   GetIt.I.registerSingleton<AppModel>(AppModel());
}