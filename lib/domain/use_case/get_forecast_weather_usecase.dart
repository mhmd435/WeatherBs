
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/core/usecases/UseCase.dart';
import 'package:weatherBs/data/Models/ForcastDaysModel.dart';
import 'package:weatherBs/domain/repositories/ForecastWeatherRepository.dart';

class GetForecastWeatherUseCase extends UseCase<DataState<ForcastDaysModel>, ForecastParams> {

  final ForecastWeatherRepository _forecastWeatherRepository;

  GetForecastWeatherUseCase(this._forecastWeatherRepository);


  @override
  Future<DataState<ForcastDaysModel>> call(params) {
    return _forecastWeatherRepository.fetchForecastWeatherData(params);
  }

}