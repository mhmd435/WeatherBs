import 'package:get_it/get_it.dart';
import 'package:weatherBs/data/Repositories/city_repositoryimpl.dart';
import 'package:weatherBs/data/Repositories/weather_repositoryimpl.dart';
import 'package:weatherBs/data/data_sources/local/database.dart';
import 'package:weatherBs/data/repositories/SuggestCityRepositoryImpl.dart';
import 'package:weatherBs/domain/repositories/city_repository.dart';
import 'package:weatherBs/domain/repositories/weather_repository.dart';
import 'package:weatherBs/domain/use_case/delete_city_usecase.dart';
import 'package:weatherBs/domain/use_case/get_all_city_usecase.dart';
import 'package:weatherBs/domain/use_case/get_current_weather_usecase.dart';
import 'package:weatherBs/domain/use_case/get_forecast_weather_usecase.dart';
import 'package:weatherBs/domain/use_case/save_city_usecase.dart';
import 'package:weatherBs/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:weatherBs/presentation/bloc/home_bloc/home_bloc.dart';
import 'data/data_sources/remote/ApiProvider.dart';
import 'domain/use_case/get_city_usecase.dart';

GetIt locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  locator.registerSingleton<AppDatabase>(database);

  // inject Repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));
  locator.registerSingleton<SuggestCityRepositoryImpl>(SuggestCityRepositoryImpl(locator()));
  locator.registerSingleton<CityRepository>(CityRepositoryImpl(database.cityDao));

  // inject UseCases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUseCase>(GetForecastWeatherUseCase(locator()));
  locator.registerSingleton<SaveCityUseCase>(SaveCityUseCase(locator()));
  locator.registerSingleton<GetAllCityUseCase>(GetAllCityUseCase(locator()));
  locator.registerSingleton<GetCityUseCase>(GetCityUseCase(locator()));
  locator.registerSingleton<DeleteCityUseCase>(DeleteCityUseCase(locator()));

  locator.registerSingleton<BookmarkBloc>(BookmarkBloc(locator(),locator(),locator(),locator()));
  locator.registerSingleton<HomeBloc>(HomeBloc(locator(),locator()));
  // locator.registerLazySingleton<Dio>(() => Dio());

// Alternatively you could write it if you don't like global variables
//   GetIt.I.registerSingleton<AppModel>(AppModel());
}