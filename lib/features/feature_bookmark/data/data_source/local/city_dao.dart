
import 'package:floor/floor.dart';

import '../../../domain/entities/city_model.dart';

@dao
abstract class CityDao {
  @Query('SELECT * FROM City')
  Future<List<City>> getAllCity();

  @Query('SELECT * FROM City WHERE name = :name')
  Future<City?> findCityByName(String name);

  @insert
  Future<void> insertCity(City person);

  @Query('DELETE FROM City WHERE name = :name')
  Future<void> deleteCityByName(String name);
}