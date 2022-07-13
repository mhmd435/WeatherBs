
import 'package:weatherBs/core/resources/data_state.dart';
import '../../data/models/city_model.dart';

abstract class CityRepository{

  Future<DataState<City>> saveCityToDB(String cityName);

  Future<DataState<List<City>>> getAllCityFromDB();

  Future<DataState<City?>> findCityByName(String name);

  Future<DataState<String>> deleteCityByName(String name);


// Future<DataState<String>> deleteCityFromDB(String cityName);

}