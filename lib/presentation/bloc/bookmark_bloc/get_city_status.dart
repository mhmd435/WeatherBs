
import '../../../domain/Models/city_model.dart';

abstract class GetCityStatus {}

// loading state
class GetCityLoading extends GetCityStatus{}

// loaded state
class GetCityCompleted extends GetCityStatus{
  final City? city;
  GetCityCompleted(this.city);
}

// error state
class GetCityError extends GetCityStatus{
  final String? message;
  GetCityError(this.message);
}