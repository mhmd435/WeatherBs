

import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';

import '../entities/city_model.dart';

class SaveCityUseCase{
  final CityRepository _cityRepository;
  SaveCityUseCase(this._cityRepository);

  Future<DataState<City>> call(String params) {
    return _cityRepository.saveCityToDB(params);
  }
}