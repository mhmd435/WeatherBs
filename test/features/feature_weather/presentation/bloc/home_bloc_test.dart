
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:weatherBs/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/home_bloc.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeatherUseCase,GetForecastWeatherUseCase])
void main(){
  late HomeBloc homeBloc;
  MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
  MockGetForecastWeatherUseCase mockGetForecastWeatherUseCase = MockGetForecastWeatherUseCase();

  setUp((){
    homeBloc = HomeBloc(mockGetCurrentWeatherUseCase, mockGetForecastWeatherUseCase);
  });

  tearDown(() {
    homeBloc.close();
  });


  String cityName = 'Tehran';
  String error = 'error';

  group('Cw Event test', () {
    /// First Way
    when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess(CurrentCityEntity())));

    blocTest<HomeBloc, HomeState>(
      'emit Loading and Completed state',
      build: () => HomeBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase),
      act: (bloc) {
        bloc.add(LoadCwEvent(cityName));
      },
      expect: () => <HomeState>[
        HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        HomeState(cwStatus: CwCompleted(CurrentCityEntity()), fwStatus: FwLoading()),
      ],
    );


    /// Second Way
    test('emit Loading and Error state', () {
      when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      final bloc = HomeBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase);
      bloc.add(LoadCwEvent(cityName));

      expectLater(bloc.stream,emitsInOrder([
        HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        HomeState(cwStatus: CwError(error), fwStatus: FwLoading()),
      ]));
    });
  });


  group('Fw Event test', () {
    ForecastParams forecastParams = ForecastParams(35.715298, 51.404343);
    when(mockGetForecastWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess(ForecastDaysEntity())));

    blocTest<HomeBloc, HomeState>(
      'emit Loading and Completed state',
      build: () => HomeBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase),
      act: (bloc) {
        bloc.add(LoadFwEvent(forecastParams));
      },
      expect: () => <HomeState>[
        HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        HomeState(cwStatus: CwLoading(), fwStatus: FwCompleted(ForecastDaysEntity())),
      ],

    );


    test('emit Loading and Error state', () {
      when(mockGetForecastWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      final bloc = HomeBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase);
      bloc.add(LoadFwEvent(forecastParams));

      expectLater(bloc.stream,emitsInOrder([
        HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        HomeState(cwStatus: CwLoading(), fwStatus: FwError(error)),
      ]));
    });
  });
}