
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/core/usecases/UseCase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/entities/city_model.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/get_city_usecase.dart';

import 'delete_city_usecase_test.mocks.dart';

void main(){
  late GetCityUseCase getCityUseCase;
  MockCityRepository mockCityRepository = MockCityRepository();

  setUp(() {
    getCityUseCase = GetCityUseCase(mockCityRepository);
  });

  String cityName = 'Tehran';

  test('should delete city', () async {
    DataState<City?> dataState = DataSuccess(City(name: cityName));

    /// arrange
    when(mockCityRepository.findCityByName(cityName)).thenAnswer((_) => Future.value(dataState));

    /// act
    final result = await getCityUseCase(cityName);

    /// assert
    expect(result.data, dataState.data);
  });
}