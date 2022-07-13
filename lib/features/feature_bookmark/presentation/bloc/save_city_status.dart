
import '../../data/models/city_model.dart';

abstract class SaveCityStatus {}

class SaveCityInitial extends SaveCityStatus {}

// loading state
class SaveCityLoading extends SaveCityStatus{}

// loaded state
class SaveCityCompleted extends SaveCityStatus{
  final City city;
  SaveCityCompleted(this.city);
}

// error state
class SaveCityError extends SaveCityStatus{
  final String? message;
  SaveCityError(this.message);
}
