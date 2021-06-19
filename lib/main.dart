import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weather_app/Models/CurrentCityDataModel.dart';

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
  late Future<CurrentCityDataModel> futureCityData;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureCityData = SendRequestCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my App"),
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
      body: Container(
        color: Colors.black,
        child: FutureBuilder<CurrentCityDataModel>(
          future: futureCityData,
          builder: (context, snapshot){
            if(snapshot.hasData){
              CurrentCityDataModel? cityDataModel = snapshot.data;

              return Center(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      cityDataModel!.cityName,
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
                    child: Icon(
                      Icons.light_mode_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      cityDataModel.temp.toString(),
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
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                cityDataModel.temp_max.toString(),
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
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
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                cityDataModel.temp_min.toString(),
                                style: TextStyle(fontSize: 16, color: Colors.white),
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
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              return daysWeatherView();
                            }),
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
                              Text("wind speed",style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(cityDataModel.windSpeed.toString(),style: TextStyle(fontSize: 12, color: Colors.white)),
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
                                Text("sunrise",style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text("6:19 PM",style: TextStyle(fontSize: 12, color: Colors.white)),
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
                            child: Column(
                                children: [
                                  Text("sunset",style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text("9:3 AM",style: TextStyle(fontSize: 12, color: Colors.white)),
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
                            child: Column(
                                children: [
                                  Text("humidity",style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text("72%",style: TextStyle(fontSize: 12, color: Colors.white)),
                                  ),
                                ]),
                          ),
                        ]),
                  )
                ]),
              );
            }else{
              return Center(child: JumpingDotsProgressIndicator(color: Colors.white,fontSize: 60,dotSpacing: 2,));
            }
          },



        ),
      ),
    );
  }

  Future<CurrentCityDataModel> SendRequestCurrentWeather() async{
    var api_key = 'ca5e39190e532d726ebd7985846865be';
    var city = 'sari';

    var response = await Dio().get(
        "http://api.openweathermap.org/data/2.5/weather",
        queryParameters: {'q': city, 'appid': api_key, 'units': 'metric'});
    
    var dataModel = CurrentCityDataModel(response.data["name"],response.data["coord"]["lon"], response.data["coord"]["lat"], response.data["weather"][0]["main"], response.data["weather"][0]["description"], response.data["main"]["temp"], response.data["main"]["temp_min"], response.data["main"]["temp_max"], response.data["main"]["pressure"], response.data["main"]["humidity"], response.data["wind"]["speed"], response.data["dt"], response.data["sys"]["country"], response.data["sys"]["sunrise"], response.data["sys"]["sunset"]);
    print(response.data);
    return dataModel;
  }

  Card daysWeatherView() {
    return Card(
      color: Colors.black,
      elevation: 10,
      child: Container(
          width: 50,
          height: 50,
          child: Column(
            children: [
              Text("11pm",style: TextStyle(fontSize: 12, color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(Icons.cloud,color: Colors.white,size: 20,),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text("14^",style: TextStyle(fontSize: 13, color: Colors.white)),
              )),
            ],
          )),
    );
  }
}
