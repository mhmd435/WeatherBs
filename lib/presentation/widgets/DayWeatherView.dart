
import 'package:flutter/material.dart';
import 'package:weatherBs/domain/Models/ForcastDaysModel.dart';

import '../helpers/DateConverter.dart';

class DaysWeatherView extends StatefulWidget {
  Daily daily;
  DaysWeatherView({Key? key, required this.daily}) : super(key: key);

  @override
  State<DaysWeatherView> createState() => _DaysWeatherViewState();
}

class _DaysWeatherViewState extends State<DaysWeatherView> with SingleTickerProviderStateMixin{

  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: animationController, curve: Interval(0.5, 1,curve: Curves.decelerate)));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context,child){
        return Transform(
          transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                  width: 50,
                  height: 50,
                  child: Column(
                    children: [
                      Text(DateConverter.changeDtToDateTime(widget.daily.dt).toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: setIconForMain(widget.daily.weather![0].description!)),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                widget.daily.temp!.day!.round().toString() + "\u00B0",
                                style: TextStyle(fontSize: 15, color: Colors.white)),
                          )),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  Image setIconForMain(description) {

    if (description == "clear sky") {
      return Image(
          image: AssetImage(
            'images/icons8-sun-96.png',
          ));
    } else if (description == "few clouds") {
      return Image(image: AssetImage('images/icons8-partly-cloudy-day-80.png'));
    } else if (description.contains("clouds")) {
      return Image(image: AssetImage('images/icons8-clouds-80.png'));
    } else if (description.contains("thunderstorm")) {
      return Image(image: AssetImage('images/icons8-storm-80.png'));
    } else if (description.contains("drizzle")) {
      return Image(image: AssetImage('images/icons8-rain-cloud-80.png'));
    } else if (description.contains("rain")) {
      return Image(image: AssetImage('images/icons8-heavy-rain-80.png'));
    } else if (description.contains("snow")) {
      return Image(image: AssetImage('images/icons8-snow-80.png'));
    } else {
      return Image(image: AssetImage('images/icons8-windy-weather-80.png'));
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    // _fwBloc.dispose();
    // _cwBloc.dispose();
    super.dispose();
  }
}
