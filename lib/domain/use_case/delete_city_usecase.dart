
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/domain/repositories/city_repository.dart';

class DeleteCityUseCase{
  final CityRepository _cityRepository;
  DeleteCityUseCase(this._cityRepository);

  Future<DataState<String>> call(String params) {
    return _cityRepository.deleteCityByName(params);
  }
}