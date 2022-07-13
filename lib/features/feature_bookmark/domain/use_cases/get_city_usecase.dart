
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';

import '../../data/models/city_model.dart';

class GetCityUseCase  {
  final CityRepository _cityRepository;
  GetCityUseCase(this._cityRepository);

  Future<DataState<City?>> call(String params) {
    return _cityRepository.findCityByName(params);
  }
}