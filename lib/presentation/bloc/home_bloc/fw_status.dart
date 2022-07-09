
import 'package:flutter/material.dart';
import '../../../domain/Models/ForcastDaysModel.dart';

@immutable
abstract class FwStatus {}

// loading state
class FwLoading extends FwStatus{}

// loaded state
class FwCompleted extends FwStatus{
  final ForcastDaysModel forcastDaysModel;
  FwCompleted(this.forcastDaysModel);
}

// error state
class FwError extends FwStatus{
  final String? message;
  FwError(this.message);
}