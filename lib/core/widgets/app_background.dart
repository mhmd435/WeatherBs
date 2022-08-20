
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppBackground {

  static AssetImage getBackGroundImage(String formattedDate){
    if(6 > int.parse(formattedDate)){
      return AssetImage('images/nightpic.jpg');
    }else if(18 > int.parse(formattedDate)){
      return AssetImage('images/pic_bg.jpg');
    }else{
      return AssetImage('images/nightpic.jpg');
    }
  }

  static Image setIconForMain(description, height) {
    if (description == "clear sky") {
      return Image(
          image: AssetImage(
            'images/icons8-sun-96.png',
          ),height: height,);
    } else if (description == "few clouds") {
      return Image(image: AssetImage('images/icons8-partly-cloudy-day-80.png'),height: height);
    } else if (description.contains("clouds")) {
      return Image(image: AssetImage('images/icons8-clouds-80.png'),height: height);
    } else if (description.contains("thunderstorm")) {
      return Image(image: AssetImage('images/icons8-storm-80.png'),height: height);
    } else if (description.contains("drizzle")) {
      return Image(image: AssetImage('images/icons8-rain-cloud-80.png'),height: height);
    } else if (description.contains("rain")) {
      return Image(image: AssetImage('images/icons8-heavy-rain-80.png'),height: height);
    } else if (description.contains("snow")) {
      return Image(image: AssetImage('images/icons8-snow-80.png'),height: height);
    } else {
      return Image(image: AssetImage('images/icons8-windy-weather-80.png'),height: height);
    }
  }

}