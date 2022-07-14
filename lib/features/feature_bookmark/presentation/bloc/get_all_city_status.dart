

import '../../domain/entities/city_model.dart';

abstract class GetAllCityStatus {}

// loading state
class GetAllCityLoading extends GetAllCityStatus{}

// loaded state
class GetAllCityCompleted extends GetAllCityStatus{
  final List<City> cities;
  GetAllCityCompleted(this.cities);
}

// error state
class GetAllCityError extends GetAllCityStatus{
  final String? message;
  GetAllCityError(this.message);
}