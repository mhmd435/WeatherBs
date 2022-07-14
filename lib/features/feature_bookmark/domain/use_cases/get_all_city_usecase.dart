
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';

import '../entities/city_model.dart';


class GetAllCityUseCase {
  final CityRepository _cityRepository;
  GetAllCityUseCase(this._cityRepository);

  Future<DataState<List<City>>> call() {
    return _cityRepository.getAllCityFromDB();
  }
}