
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/data/data_source/remote/ApiProvider.dart';
import 'package:weatherBs/features/feature_weather/data/repository/weather_repositoryimpl.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';

import 'weather_repository_impl_test.mocks.dart';

@GenerateMocks([ApiProvider])
void main(){
  late WeatherRepository weatherRepository;
  MockApiProvider mockApiProvider = MockApiProvider();

  setUp((){
    weatherRepository = WeatherRepositoryImpl(mockApiProvider);
  });

  String cityName = 'tehran';
  ForecastParams forecastParams = ForecastParams(35.6944, 51.4215);


  group('weather repository', () {

    test('test fetchCurrentWeatherData', () async {
      /// arrange
      when(mockApiProvider.sendRequestCurrentWeather(any)).thenAnswer((_) => Future.value(Response(requestOptions: RequestOptions(path: ''))));

      /// act
      final result = await weatherRepository.fetchCurrentWeatherData(cityName);

      /// assert
      expect(result, isA<DataState<CurrentCityEntity>>());
      verify(mockApiProvider.sendRequestCurrentWeather(cityName));
    });


    test('test fetchForecastWeatherData', () async {
      /// arrange
      when(mockApiProvider.sendRequest7DaysForcast(any)).thenAnswer((_) => Future.value(Response(requestOptions: RequestOptions(path: ''))));

      /// act
      final result = await weatherRepository.fetchForecastWeatherData(forecastParams);

      /// assert
      expect(result, isA<DataState<ForecastDaysEntity>>());
      verify(mockApiProvider.sendRequest7DaysForcast(forecastParams));
    });


    // test('test fetchSuggestData', () async {
    //   /// arrange
    //   when(mockApiProvider.sendRequestCitySuggestion(any)).thenAnswer((_) => Future.value(Response(requestOptions: RequestOptions(path: ''))));
    //
    //   /// act
    //   final result = await weatherRepository.fetchSuggestData(cityName);
    //
    //   /// assert
    //   expect(result, isA<List<Data>>());
    //   verify(mockApiProvider.sendRequestCitySuggestion(cityName));
    // });
  });

}