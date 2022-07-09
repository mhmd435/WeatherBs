
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/Models/city_model.dart';
import 'package:weatherBs/domain/repositories/city_repository.dart';


class GetAllCityUseCase {
  final CityRepository _cityRepository;
  GetAllCityUseCase(this._cityRepository);

  Future<DataState<List<City>>> call() {
    return _cityRepository.getAllCityFromDB();
  }
}