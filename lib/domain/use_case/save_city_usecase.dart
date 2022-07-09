

import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/Models/city_model.dart';
import 'package:weatherBs/domain/repositories/city_repository.dart';

class SaveCityUseCase{
  final CityRepository _cityRepository;
  SaveCityUseCase(this._cityRepository);

  Future<DataState<City>> call(String params) {
    return _cityRepository.saveCityToDB(params);
  }
}