
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_weather/data/models/CurrentCityModel.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:weatherBs/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';

import 'get_current_weather_usecase_test.mocks.dart';

// class MockWeatherRepository extends Mock implements WeatherRepository{}

@GenerateMocks([WeatherRepository])
void main(){
  late GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  late MockWeatherRepository mockWeatherRepository;

  setUp((){
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });

  String cityName = 'Tehran';
  DataSuccess<CurrentCityEntity> dataSuccess = DataSuccess(CurrentCityEntity(name: 'Tehran'));

  test(
      'should get the current city weather',
       () async {
        /// arrange
        when(mockWeatherRepository.fetchCurrentWeatherData(cityName)).thenAnswer((_) => Future.value(dataSuccess));

        /// act
        final result = await getCurrentWeatherUseCase.call(cityName);

        /// assert
        expect(result.data?.name, dataSuccess.data?.name);
        /// verify api called with "tehran" cityName and don't changed in UseCase
        verify(mockWeatherRepository.fetchCurrentWeatherData(cityName));
       }
      );
}