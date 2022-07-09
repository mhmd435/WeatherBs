
import 'package:flutter/foundation.dart';
import '../../../domain/Models/CurrentCityModel.dart';

@immutable
abstract class CwStatus {}

// loading state
class CwLoading extends CwStatus{}

// loaded state
class CwCompleted extends CwStatus{
  final CurrentCityModel currentCityModel;
  CwCompleted(this.currentCityModel);
}

// error state
class CwError extends CwStatus{
  final String? message;
  CwError(this.message);
}
