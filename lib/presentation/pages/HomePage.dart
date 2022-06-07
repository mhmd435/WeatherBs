
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/data/Models/CurrentCityModel.dart';
import 'package:weather_app/data/Models/ForcastDaysModel.dart';
import 'package:weather_app/presentation/helpers/DateConverter.dart';
import 'package:weather_app/presentation/widgets/DayWeatherView.dart';
import 'package:weather_app/presentation/widgets/DotLoadingWidget.dart';

import '../../data/Models/SuggestCityModel.dart';
import '../../logic/bloc/cwbloc/cw_bloc.dart';
import '../../logic/bloc/fwbloc/fw_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>{

  TextEditingController textEditingController = TextEditingController();
  var cityName = "Tehran";

  PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // call event (call api)
    BlocProvider.of<CwBloc>(context).add(LoadCwEvent(cityName));
  }




  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: getBackGroundImage(),
              fit: BoxFit.cover,)),
        child: BlocBuilder<CwBloc, CwState>(
              builder: (BuildContext context, state) {
                if(state is CwLoading){
                  return DotLoadingWidget();
                }else if(state is CwCompleted){

                  // get data from state
                  CurrentCityModel cityDataModel = state.currentCityModel;
                  BlocProvider.of<FwBloc>(context).add(LoadFwEvent(cityDataModel.coord!.lat!, cityDataModel.coord!.lon!));

                  final formatter = DateFormat.jm();
                  var sunrise = formatter.format(
                      new DateTime.fromMillisecondsSinceEpoch(
                          (cityDataModel.sys!.sunrise! * 1000) + cityDataModel.timezone! * 1000,
                          isUtc: true));
                  var sunset = formatter.format(
                      new DateTime.fromMillisecondsSinceEpoch(
                          (cityDataModel.sys!.sunset! * 1000) + cityDataModel.timezone! * 1000,
                          isUtc: true));

                  return GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      new TextEditingController().clear();
                    },
                    child: ListView(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.only(top: height * 0.02, left: width * 0.03, right: width * 0.03),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                          onSubmitted: (String prefix){
                                              textEditingController.text = prefix;
                                              BlocProvider.of<CwBloc>(context).add(LoadCwEvent(prefix));
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
                                        return sendRequestCitySuggestion(prefix);
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
                                          textEditingController.text = model.Name;
                                          BlocProvider.of<CwBloc>(context).add(LoadCwEvent(model.Name));
                                      },
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.02),
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
                                              cityDataModel.name!,
                                              style: TextStyle(
                                                  fontSize: 30, color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text(
                                              cityDataModel.weather![0].description!,
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: setIconForMain(cityDataModel.weather![0].description!),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text(
                                              cityDataModel.main!.temp!.round().toString() +
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
                                                        cityDataModel.main!.tempMax!
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
                                                        cityDataModel.main!.tempMin!
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
                                            child: BlocBuilder<FwBloc, FwState>(
                                              builder: (BuildContext context, state) {
                                                if(state is FwLoading){
                                                  return DotLoadingWidget();
                                                }else if(state is FwCompleted){
                                                  ForcastDaysModel forecastDaysModel = state.forcastDaysModel;

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
                                                            sampleData1(forecastDaysModel),
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
                                                }else if(state is FwError){
                                                  return Center(
                                                    child: Text(state.message!),
                                                  );
                                                }else{
                                                  return Container();
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
                          Center(
                            child: SmoothPageIndicator(
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
                          ),
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
                                  child: BlocBuilder<FwBloc, FwState>(
                                    builder: (BuildContext context, state) {
                                      if(state is FwLoading){
                                        return DotLoadingWidget();
                                      }else if(state is FwCompleted){
                                        ForcastDaysModel forcastDaysModel = state.forcastDaysModel;
                                        List<Daily> mainDaily = forcastDaysModel.daily!;

                                        return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 8,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              return DaysWeatherView(daily: mainDaily[index]);
                                            });
                                      }else if(state is FwError){
                                        return Center(
                                          child: Text(state.message!),
                                        );
                                      }else{
                                        return Container();
                                      }
                                    },
                                  ),
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
                            padding: const EdgeInsets.only(top: 10.0,bottom: 30),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("wind speed",
                                          style: TextStyle(fontSize: 17, color: Colors.amber)),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                            cityDataModel.wind!.speed!.toString() + " m/s",
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
                                            cityDataModel.main!.humidity!.toString() + "%",
                                            style: TextStyle(
                                                fontSize: 14, color: Colors.white)),
                                      ),
                                    ]),
                                  ),
                                ]),
                          ),
                          // Align(
                          //   alignment: FractionalOffset.bottomCenter,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(bottom: 5),
                          //     child: Text("powered by Besenior",style: TextStyle(color: Colors.white,fontSize: 15),),
                          //   ),
                          // )
                        ]),
                  );
                }else if(state is CwError){
                  return Center(
                    child: Text(state.message!),
                  );
                }else{
                  return Container();
                }
              },
            ),
      )
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

  Future<List<SuggestCityModel>> sendRequestCitySuggestion(String prefix) async {
    List<SuggestCityModel> list = [];

    try{

      var response = await Dio().get(
          "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
          queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

      for (var item in response.data['data']) {
        list.add(SuggestCityModel(item['name'], item['region'], item['country'],
            item['countryCode']));
      }

    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection lost...")));
    }


    return list;
  }

  LineChartData sampleData1(ForcastDaysModel forecastDaysModel) {
    List<Daily> mainDaily = forecastDaysModel.daily!;

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
          getTextStyles: (value, d) => const TextStyle(
            color: Color(0xffe6dcff),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 15,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return DateConverter.changeDtToDateTime(mainDaily[0].dt);
              case 3:
                return DateConverter.changeDtToDateTime(mainDaily[2].dt);
              case 5:
                return DateConverter.changeDtToDateTime(mainDaily[4].dt);
              case 7:
                return DateConverter.changeDtToDateTime(mainDaily[6].dt);
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value, d) => const TextStyle(
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
      lineBarsData: linesBarData1(mainDaily),
    );
  }

  List<LineChartBarData> linesBarData1(List<Daily> model) {
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
      return AssetImage('images/pic_bg.jpg');
    }else if(18 > int.parse(formattedDate)){
      return AssetImage('images/pic_bg.jpg');
    }else{
      return AssetImage('images/pic_bg.jpg');
    }
  }

}