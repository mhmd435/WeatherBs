
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/core/usecases/UseCase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/entities/city_model.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';

import 'delete_city_usecase_test.mocks.dart';

void main(){
  late GetAllCityUseCase getAllCityUseCase;
  MockCityRepository mockCityRepository = MockCityRepository();

  setUp(() {
    getAllCityUseCase = GetAllCityUseCase(mockCityRepository);
  });

  test('should delete city', () async {
    List<City> cities = [];
    DataState<List<City>> dataState = DataSuccess(cities);

    /// arrange
    when(mockCityRepository.getAllCityFromDB()).thenAnswer((_) => Future.value(dataState));

    /// act
    final result = await getAllCityUseCase(NoParams());

    /// assert
    expect(result.data, dataState.data);
  });
}