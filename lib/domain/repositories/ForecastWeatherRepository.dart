
import 'package:weatherBs/core/params/ForecastParams.dart';

import '../../core/resources/data_state.dart';
import '../../data/Models/ForcastDaysModel.dart';

abstract class ForecastWeatherRepository{

  Future<DataState<ForcastDaysModel>> fetchForecastWeatherData(ForecastParams params);

}