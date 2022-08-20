

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherBs/core/widgets/app_background.dart';

void main() {

  group('getBackGroundImage test', () {

    test('14 AM should be return light pic', () {
      var result = AppBackground.getBackGroundImage("14");
      expect(result, AssetImage('images/pic_bg.jpg'));
    });

    test('22 AM should be return night pic', () {
      var result = AppBackground.getBackGroundImage("22");
      expect(result, AssetImage('images/nightpic.jpg'));
    });

    test('4 AM should be return night pic', () {
      var result = AppBackground.getBackGroundImage("4");
      expect(result, AssetImage('images/nightpic.jpg'));
    });

  });

  group('setIconForMain test', () {

    test('clear sky should be return this pic', () {
      var result = AppBackground.setIconForMain("clear sky",1);
      expect(result.image, AssetImage('images/icons8-sun-96.png',));
    });

    test('drizzle should be return this pic', () {
      var result = AppBackground.setIconForMain("drizzle",1);
      expect(result.image, AssetImage('images/icons8-rain-cloud-80.png'));
    });

    test('snow should be return this pic', () {
      var result = AppBackground.setIconForMain("snow",1);
      expect(result.image, AssetImage('images/icons8-snow-80.png'));
    });

  });

}