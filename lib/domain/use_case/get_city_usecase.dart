
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/Models/city_model.dart';
import 'package:weatherBs/domain/repositories/city_repository.dart';

class GetCityUseCase  {
  final CityRepository _cityRepository;
  GetCityUseCase(this._cityRepository);

  Future<DataState<City?>> call(String params) {
    return _cityRepository.findCityByName(params);
  }
}