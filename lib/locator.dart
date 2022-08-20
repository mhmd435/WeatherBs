import 'package:get_it/get_it.dart';
import 'package:weatherBs/core/bloc/bottom_icon_cubit.dart';
import 'package:weatherBs/features/feature_weather/data/repository/weather_repositoryimpl.dart';
import 'package:weatherBs/features/feature_bookmark/data/data_source/local/database.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';
import 'package:weatherBs/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weatherBs/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/save_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'features/feature_bookmark/data/repository/city_repositoryimpl.dart';
import 'features/feature_bookmark/domain/use_cases/get_city_usecase.dart';
import 'features/feature_weather/data/data_source/remote/ApiProvider.dart';

GetIt locator = GetIt.instance;

Future<void> setup() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  locator.registerSingleton<AppDatabase>(database);

  // inject Repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));
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
  locator.registerSingleton<BottomIconCubit>(BottomIconCubit());
  // locator.registerLazySingleton<Dio>(() => Dio());

// Alternatively you could write it if you don't like global variables
//   GetIt.I.registerSingleton<AppModel>(AppModel());
}