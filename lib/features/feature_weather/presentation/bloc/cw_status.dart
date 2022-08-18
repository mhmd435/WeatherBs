
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';

@immutable
abstract class CwStatus extends Equatable{}

/// loading state
class CwLoading extends CwStatus{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// loaded state
class CwCompleted extends CwStatus{
  final CurrentCityEntity currentCityEntity;
  CwCompleted(this.currentCityEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [
    currentCityEntity,
  ];
}

/// error state
class CwError extends CwStatus{
  final String? message;
  CwError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [
    message
  ];
}
