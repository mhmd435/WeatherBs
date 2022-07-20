
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weatherBs/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'get_current_weather_usecase_test.mocks.dart';

// class MockWeatherRepository extends Mock implements WeatherRepository{}

@GenerateMocks([WeatherRepository])
void main(){
  late GetForecastWeatherUseCase getForecastWeatherUseCase;
  late MockWeatherRepository mockWeatherRepository;

  setUp((){
    mockWeatherRepository = MockWeatherRepository();
    getForecastWeatherUseCase = GetForecastWeatherUseCase(mockWeatherRepository);
  });

  ForecastParams forecastParams = ForecastParams(35.6944, 51.4215);
  DataSuccess<ForecastDaysEntity> dataSuccess = DataSuccess(ForecastDaysEntity(lat: 35.6944,lon: 51.4215));

  test(
      'should get the forecast of all city weather',
       () async {
        /// arrange
        when(mockWeatherRepository.fetchForecastWeatherData(forecastParams)).thenAnswer((_) => Future.value(dataSuccess));

        /// act
        final result = await getForecastWeatherUseCase(forecastParams);

        /// assert
        expect(result.data, dataSuccess.data);
        /// verify api called with "tehran" cityName and don't changed in UseCase
        verify(mockWeatherRepository.fetchForecastWeatherData(forecastParams));
       }
      );
}