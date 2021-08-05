import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/Models/CurrentCityDataModel.dart';
import 'package:weather_app/Models/ForecastDaysModel.dart';
import 'package:weather_app/Models/SuggestCityModel.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin{
  TextEditingController textEditingController = TextEditingController();
  var cityName = "Tehran";
  var lat;
  var lon;
  late StreamController<CurrentCityDataModel> streamCityData;
  late StreamController<List<ForecastDaysModel>> StreamForecastdays;
  late StreamController<List<ForecastDaysModel>> StreamForecastdaysPageView;

  PageController _pageController = PageController();

  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation = Tween(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: animationController, curve: Interval(0.5, 1,curve: Curves.decelerate)));
    animationController.forward();


    streamCityData = StreamController<CurrentCityDataModel>();
    StreamForecastdays = StreamController<List<ForecastDaysModel>>();
    StreamForecastdaysPageView = StreamController<List<ForecastDaysModel>>();
    CallRequests();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<CurrentCityDataModel>(
        stream: streamCityData.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CurrentCityDataModel? cityDataModel = snapshot.data;
            SendRequest7DaysForcast(lat, lon);

            final formatter = DateFormat.jm();
            var sunrise = formatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                    cityDataModel!.sunrise * 1000,
                    isUtc: true));
            var sunset = formatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                    cityDataModel.sunset * 1000,
                    isUtc: true));

            return GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
                new TextEditingController().clear();
              },
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: getBackGroundImage(),
                        fit: BoxFit.cover)),
                child: Center(
                  child: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                            onSubmitted: (String prefix){
                                              setState(() {
                                                textEditingController.text = prefix;
                                                SendRequestCurrentWeather(textEditingController.text, context);
                                              });
                                            },
                                            controller: textEditingController,
                                            style:
                                                DefaultTextStyle.of(context).style.copyWith(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                              hintText: "Enter a City...",
                                              hintStyle: TextStyle(color: Colors.white),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                          )),
                                      suggestionsCallback: (String prefix) async {
                                        return SendRequestCitySuggestion(prefix);
                                      },
                                      itemBuilder: (context, SuggestCityModel model) {
                                        return ListTile(
                                          leading: Icon(Icons.location_on),
                                          title: Text(model.Name),
                                          subtitle:
                                              Text(model.region + ", " + model.country),
                                        );
                                      },
                                      onSuggestionSelected: (SuggestCityModel model) {
                                        setState(() {
                                          textEditingController.text = model.Name;
                                          SendRequestCurrentWeather(textEditingController.text, context);
                                        });
                                      },
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        child: PageView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            allowImplicitScrolling: true,
                            controller: _pageController,
                            itemCount: 2,
                            itemBuilder: (context, position) {
                              if (position == 0) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Text(
                                        cityDataModel.cityName,
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        cityDataModel.description,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: setIconForMain(cityDataModel),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        cityDataModel.temp.round().toString() +
                                            "\u00B0",
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "max",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  cityDataModel.temp_max
                                                          .round()
                                                          .toString() +
                                                      "\u00B0",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: Container(
                                              color: Colors.grey,
                                              width: 2,
                                              height: 40,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "min",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Text(
                                                  cityDataModel.temp_min
                                                          .round()
                                                          .toString() +
                                                      "\u00B0",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                  height: 400,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: double.infinity,
                                      height: 250,
                                      child: StreamBuilder<
                                          List<ForecastDaysModel>>(
                                        stream:
                                            StreamForecastdaysPageView.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<ForecastDaysModel>? model =
                                                snapshot.data;
                                            return Column(
                                              children: [
                                                Text("Humidity",style: TextStyle(color: Colors.white,fontSize: 17),),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        bottom: 20,
                                                        right: 40,
                                                        left: 20),
                                                    child: LineChart(
                                                      sampleData1(model!),
                                                      swapAnimationDuration:
                                                          Duration(milliseconds: 150),
                                                      // Optional
                                                      swapAnimationCurve:
                                                          Curves.linear, // Optional
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    JumpingDotsProgressIndicator(
                                              color: Colors.white,
                                              fontSize: 60,
                                              dotSpacing: 2,
                                            ));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                    SmoothPageIndicator(
                        controller: _pageController,
                        // PageController
                        count: 2,
                        effect: ExpandingDotsEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            spacing: 5,
                            dotColor: Colors.grey,
                            activeDotColor: Colors.white),
                        // your preferred effect
                        onDotClicked: (index) => _pageController.animateToPage(
                            index,
                            duration: Duration(microseconds: 500),
                            curve: Curves.bounceOut)),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Center(
                            child: StreamBuilder<List<ForecastDaysModel>>(
                                stream: StreamForecastdays.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<ForecastDaysModel>? forcastmodel =
                                        snapshot.data;
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 6,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return daysWeatherView(
                                              forcastmodel![index + 1]);
                                        });
                                  } else {
                                    return Center(
                                        child: JumpingDotsProgressIndicator(
                                      color: Colors.white,
                                      fontSize: 60,
                                      dotSpacing: 2,
                                    ));
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("wind speed",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.amber)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      cityDataModel.windSpeed.toString() +
                                          " m/s",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white24,
                                height: 30,
                                width: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                children: [
                                  Text("sunrise",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.amber)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(sunrise,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white24,
                                height: 30,
                                width: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(children: [
                                Text("sunset",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.amber)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(sunset,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                color: Colors.white24,
                                height: 30,
                                width: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(children: [
                                Text("humidity",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.amber)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      cityDataModel.humidity.toString() + "%",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)),
                                ),
                              ]),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text("powered by Besenior",style: TextStyle(color: Colors.white,fontSize: 15),),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            );
          } else {
            return Center(
                child: JumpingDotsProgressIndicator(
              color: Colors.white,
              fontSize: 60,
              dotSpacing: 2,
            ));
          }
        },
      ),
    );
  }

  Image setIconForMain(model) {
    String description = model.description;

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

  void SendRequestCurrentWeather(cityname, [BuildContext? context]) async {
    var apiKey = 'ca5e39190e532d726ebd7985846865be';
    var city = cityname;
    var dataModel;

    try {
      var response = await Dio().get(
          "http://api.openweathermap.org/data/2.5/weather",
          queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'});

      lat = response.data["coord"]["lat"];
      lon = response.data["coord"]["lon"];

      dataModel = CurrentCityDataModel(
          response.data["name"],
          response.data["coord"]["lon"],
          response.data["coord"]["lat"],
          response.data["weather"][0]["main"],
          response.data["weather"][0]["description"],
          response.data["main"]["temp"],
          response.data["main"]["temp_min"],
          response.data["main"]["temp_max"],
          response.data["main"]["pressure"],
          response.data["main"]["humidity"],
          response.data["wind"]["speed"],
          response.data["dt"],
          response.data["sys"]["country"],
          response.data["sys"]["sunrise"],
          response.data["sys"]["sunset"]);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text("City Not Found")));
    }
    streamCityData.add(dataModel);
  }

  void SendRequest7DaysForcast(lat, lon) async {
    List<ForecastDaysModel> list = [];
    var apiKey = 'ca5e39190e532d726ebd7985846865be';

    try {
      var response = await Dio().get(
          "http://api.openweathermap.org/data/2.5/onecall",
          queryParameters: {
            'lat': lat,
            'lon': lon,
            'exclude': 'minutely,hourly',
            'appid': apiKey,
            'units': 'metric'
          });

      final formatter = DateFormat.MMMd();

      for (int i = 0; i < 8; i++) {
        var model = response.data['daily'][i];

        //change dt to our dateFormat ---Jun 23--- for Example
        var dt = formatter.format(new DateTime.fromMillisecondsSinceEpoch(
            model['dt'] * 1000,
            isUtc: true));
        // print(dt + " : " +model['weather'][0]['description']);

        ForecastDaysModel forecastDaysModel = new ForecastDaysModel(
          dt,
          model['temp']['day'],
          model['weather'][0]['main'],
          model['weather'][0]['description'],
          model['humidity'],
        );
        list.add(forecastDaysModel);
      }
      StreamForecastdays.add(list);
      StreamForecastdaysPageView.add(list);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("there is an")));
    }
  }

  Future<List<SuggestCityModel>> SendRequestCitySuggestion(String prefix) async {
    List<SuggestCityModel> list = [];

    try {
      var response = await Dio().get(
          "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
          queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

      for (var item in response.data['data']) {
        list.add(SuggestCityModel(item['name'], item['region'], item['country'],
            item['countryCode']));
      }
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("there is an")));
    }

    return list;
  }

  AnimatedBuilder daysWeatherView(ForecastDaysModel forecastDaysModel) {
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
                      Text(forecastDaysModel.datetime,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: setIconForMain(forecastDaysModel)),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                                forecastDaysModel.temp.round().toString() + "\u00B0",
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

  void CallRequests() {
    SendRequestCurrentWeather(cityName);
  }

  LineChartData sampleData1(List<ForecastDaysModel> model) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffe6dcff),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 15,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return model[0].datetime;
              case 3:
                return model[2].datetime;
              case 5:
                return model[4].datetime;
              case 7:
                return model[6].datetime;
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffefeffc),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0%';
              case 25:
                return '25%';
              case 50:
                return '50%';
              case 75:
                return '75%';
              case 100:
                return '100%';
            }
            return '';
          },
          margin: 15,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xffffffff),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 7,
      maxY: 100,
      minY: 0,
      lineBarsData: linesBarData1(model),
    );
  }

  List<LineChartBarData> linesBarData1(List<ForecastDaysModel> model) {
    final lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(0, double.parse(model[0].humidity.toString())),
        FlSpot(1, double.parse(model[1].humidity.toString())),
        FlSpot(2, double.parse(model[2].humidity.toString())),
        FlSpot(3, double.parse(model[3].humidity.toString())),
        FlSpot(4, double.parse(model[4].humidity.toString())),
        FlSpot(5, double.parse(model[5].humidity.toString())),
        FlSpot(7, double.parse(model[6].humidity.toString())),
      ],
      isCurved: true,
      colors: [
        const Color(0xff3700ff),
        const Color(0xff4e00bf),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        colors: [
          const Color(0x708167ff),
          const Color(0x5b401df5),
        ],
        show: true,
      ),
    );

    return [
      lineChartBarData1,
    ];
  }

  AssetImage getBackGroundImage(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk').format(now);
    print(formattedDate);
    if(6 > int.parse(formattedDate)){
      return AssetImage('images/nightpic.jpg');
    }else if(18 > int.parse(formattedDate)){
      return AssetImage('images/pic_bg.jpg');
    }else{
      return AssetImage('images/nightpic.jpg');
    }
  }
}
