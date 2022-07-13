
import 'package:flutter/foundation.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import '../../data/models/CurrentCityModel.dart';

@immutable
abstract class CwStatus {}

// loading state
class CwLoading extends CwStatus{}

// loaded state
class CwCompleted extends CwStatus{
  final CurrentCityEntity currentCityEntity;
  CwCompleted(this.currentCityEntity);
}

// error state
class CwError extends CwStatus{
  final String? message;
  CwError(this.message);
}
