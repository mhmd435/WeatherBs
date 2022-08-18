
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:weatherBs/features/feature_bookmark/data/repository/city_repositoryimpl.dart';
import 'package:weatherBs/features/feature_bookmark/domain/entities/city_model.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';
import 'city_repository_impl_test.mocks.dart';

@GenerateMocks([CityDao])
void main(){
  late CityRepository cityRepository;
  MockCityDao cityDao = MockCityDao();

  setUp((){
    cityRepository = CityRepositoryImpl(cityDao);
  });

  String cityName = 'tehran';
  City city = City(name: cityName);

  group('test saveCityToDB', () {
    test('saveCityToDB DataSuccess', () async {

      /// arrange
      when(cityDao.findCityByName(any)).thenAnswer((_) => Future.value(null));
      when(cityDao.insertCity(any)).thenAnswer((_) => Future.value());

      /// act
      final result = await cityRepository.saveCityToDB(cityName);

      /// assert
      expect(result, isA<DataSuccess<City>>());
      expect(result.data, city);
      verify(cityDao.findCityByName(cityName));
      verify(cityDao.insertCity(city));
    });

    test('saveCityToDB DataFailed', () async {

      /// arrange
      when(cityDao.findCityByName(any)).thenAnswer((_) => Future.value(city));
      when(cityDao.insertCity(any)).thenAnswer((_) => Future.value());

      /// act
      final result = await cityRepository.saveCityToDB(cityName);

      /// assert
      expect(result, isA<DataFailed>());
      verify(cityDao.findCityByName(cityName));
    });
  });

  group('test getAllCityFromDB', () {
    List<City> cities = [];
    test('getAllCityFromDB DataSuccess', () async {

      /// arrange
      when(cityDao.getAllCity()).thenAnswer((_) => Future.value(cities));

      /// act
      final result = await cityRepository.getAllCityFromDB();

      /// assert
      expect(result, isA<DataSuccess<List<City>>>());
    });
  });

  group('test findCityByName', () {
    test('findCityByName DataSuccess', () async {

      /// arrange
      when(cityDao.findCityByName(cityName)).thenAnswer((_) => Future.value(city));

      /// act
      final result = await cityRepository.findCityByName(cityName);

      /// assert
      expect(result, isA<DataSuccess<City?>>());
    });

  });

  group('test deleteCityByName', () {
    test('deleteCityByName DataSuccess', () async {

      /// arrange
      when(cityDao.deleteCityByName(cityName)).thenAnswer((_) => Future.value());

      /// act
      final result = await cityRepository.deleteCityByName(cityName);

      /// assert
      expect(result, isA<DataSuccess<String>>());
    });
  });
}