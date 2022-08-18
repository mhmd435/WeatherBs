
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';

import 'delete_city_usecase_test.mocks.dart';

@GenerateMocks([CityRepository])
void main(){
  late DeleteCityUseCase deleteCityUseCase;
  MockCityRepository mockCityRepository = MockCityRepository();

  setUp(() {
    deleteCityUseCase = DeleteCityUseCase(mockCityRepository);
  });

  String cityName = 'Tehran';

  test('should delete city', () async {
        DataState<String> dataState = DataSuccess(cityName);

        /// arrange
        when(mockCityRepository.deleteCityByName(cityName)).thenAnswer((_) => Future.value(dataState));

        /// act
        final result = await deleteCityUseCase(cityName);

        /// assert
        expect(result.data, dataState.data);
        /// verify api called with "tehran" cityName and don't changed in UseCase
        verify(mockCityRepository.deleteCityByName(cityName));
      }
  );

}