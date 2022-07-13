
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/domain/repository/city_repository.dart';

class DeleteCityUseCase{
  final CityRepository _cityRepository;
  DeleteCityUseCase(this._cityRepository);

  Future<DataState<String>> call(String params) {
    return _cityRepository.deleteCityByName(params);
  }
}