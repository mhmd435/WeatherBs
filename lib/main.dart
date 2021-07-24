import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weather_app/Models/CurrentCityDataModel.dart';
import 'package:weather_app/Models/ForecastDaysModel.dart';

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

class _HomepageState extends State<Homepage> {
  TextEditingController textEditingController = TextEditingController();
  var cityName = "babol";
  var lat;
  var lon;
  late Future<CurrentCityDataModel> futureCityData;
  late StreamController<List<ForecastDaysModel>> StreamForecastdays;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CallRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Colors.grey[900],
        elevation: 20,
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return {'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder<CurrentCityDataModel>(
        future: futureCityData,
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

            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/pic_bg.jpg'),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Center(
                  child: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    futureCityData = SendRequestCurrentWeather(
                                        textEditingController.text, context);
                                  });
                                },
                                child: Text("find")),
                          ),
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'Enter a City name'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        cityDataModel.cityName,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        cityDataModel.description,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: setIconForMain(cityDataModel),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        cityDataModel.temp.round().toString() + "\u00B0",
                        style: TextStyle(fontSize: 50, color: Colors.white70),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "max",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  cityDataModel.temp_max.round().toString() +
                                      "\u00B0",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
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
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  cityDataModel.temp_min.round().toString() +
                                      "\u00B0",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        color: Colors.white24,
                        height: 2,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Center(
                            child: StreamBuilder<List<ForecastDaysModel>>(
                                stream: StreamForecastdays.stream,
                                builder: (context, snapshot) {
                                  print(snapshot.hasData);
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
                      padding: const EdgeInsets.only(top: 5),
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
                                        fontSize: 11, color: Colors.grey)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      cityDataModel.windSpeed.toString() +
                                          " m/s",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
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
                                          fontSize: 12, color: Colors.grey)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(sunrise,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
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
                                        fontSize: 12, color: Colors.grey)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(sunset,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
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
                                        fontSize: 12, color: Colors.grey)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      cityDataModel.humidity.toString() + "%",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                ),
                              ]),
                            ),
                          ]),
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
      return Image(image: AssetImage('images/icons8-sun-96.png'));
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

  Future<CurrentCityDataModel> SendRequestCurrentWeather(cityname, [BuildContext? context]) async {
    var apiKey = 'ca5e39190e532d726ebd7985846865be';
    var city = cityname;
    var dataModel;

    try {
      var response = await Dio().get(
          "http://api.openweathermap.org/data/2.5/weather",
          queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'});

      print(response.data);
      print(response.statusCode);

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
          .showSnackBar(SnackBar(content: Text("there is an error")));
    }
    return dataModel;
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
            model['weather'][0]['description']);
        list.add(forecastDaysModel);
      }
      StreamForecastdays.add(list);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("there is an")));
    }
  }

  Padding daysWeatherView(ForecastDaysModel forecastDaysModel) {
    return Padding(
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
                      style: TextStyle(fontSize: 13, color: Colors.white)),
                )),
              ],
            )),
      ),
    );
  }

  void CallRequests() {
    futureCityData = SendRequestCurrentWeather(cityName);
    StreamForecastdays = StreamController<List<ForecastDaysModel>>();
  }
}
