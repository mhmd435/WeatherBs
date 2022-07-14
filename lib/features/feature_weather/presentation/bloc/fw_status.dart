
import 'package:flutter/material.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/forecase_days_entity.dart';
import '../../data/models/ForcastDaysModel.dart';

@immutable
abstract class FwStatus {}

/// loading state
class FwLoading extends FwStatus{}

/// loaded state
class FwCompleted extends FwStatus{
  final ForecastDaysEntity forecastDaysEntity;
  FwCompleted(this.forecastDaysEntity);
}

/// error state
class FwError extends FwStatus{
  final String? message;
  FwError(this.message);
}