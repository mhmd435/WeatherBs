
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherBs/features/feature_weather/data/models/CurrentCityModel.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){

  var WeatherModel = CurrentCityModel(
    coord: Coord(lon: -122.08,lat: 37.39),
    weather: [Weather()],
    base: 'stations',
    main: Main(),
    visibility: 10000,
    wind: Wind(),
    clouds: Clouds(),
    dt: 1560350645,
    sys: Sys(),
    timezone: -25200,
    id: 420006353,
    name: 'Mountain View',
    cod: 200
  );

  test(
  'should be a subclass of currentCityEntity',
  (){
      expect(WeatherModel, isA<CurrentCityEntity>());
    }
  );


  group('from json', () {
    test(
      'should return a valid model from json',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('current_weather.json')
        );

        // act
        final result = CurrentCityModel.fromJson(jsonMap);

        // assert
        expect(result.coord?.lat, WeatherModel.coord?.lat);
      },
    );
  });
}