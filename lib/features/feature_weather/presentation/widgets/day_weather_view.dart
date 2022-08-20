
import 'package:flutter/material.dart';
import 'package:weatherBs/config/responsive.dart';
import 'package:weatherBs/core/widgets/app_background.dart';

import '../../../../core/utlis/date_converter.dart';
import '../../data/models/ForcastDaysModel.dart';

class DaysWeatherView extends StatefulWidget {
  final Daily daily;
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
    final double height = MediaQuery.of(context).size.height;

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
              child: Column(
                children: [
                  Text(DateConverter.changeDtToDateTime(widget.daily.dt).toString(),
                      style: TextStyle(fontSize: height * 0.015, color: Colors.grey)),
                  SizedBox(height: height * 0.005,),

                  Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AppBackground.setIconForMain(widget.daily.weather![0].description!,height * 0.06)),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                            widget.daily.temp!.day!.round().toString() + "\u00B0",
                            style: TextStyle(fontSize: height * 0.015, color: Colors.white)),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
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
