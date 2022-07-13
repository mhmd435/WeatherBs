import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weatherBs/core/params/ForecastParams.dart';
import 'package:weatherBs/core/utlis/DateConverter.dart';
import 'package:weatherBs/core/widgets/AppBackground.dart';
import 'package:weatherBs/core/widgets/DotLoadingWidget.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherBs/features/feature_weather/data/data_source/remote/ApiProvider.dart';
import 'package:weatherBs/features/feature_weather/data/models/CurrentCityModel.dart';
import 'package:weatherBs/features/feature_weather/data/models/ForcastDaysModel.dart';
import 'package:weatherBs/features/feature_weather/data/models/SuggestCityModel.dart';
import 'package:weatherBs/features/feature_weather/data/repository/SuggestCityRepositoryImpl.dart';
import 'package:weatherBs/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weatherBs/features/feature_weather/presentation/widgets/DayWeatherView.dart';
import 'package:weatherBs/features/feature_weather/presentation/widgets/bookmark_icon.dart';
import 'package:weatherBs/locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController = TextEditingController();
  String cityName = "Tehran";

  final PageController _pageController = PageController();

  // Inject
  SuggestCityRepositoryImpl suggestCityRepository =
      SuggestCityRepositoryImpl(locator<ApiProvider>());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    // call event (call api)

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
      },
      child: SafeArea(
        child: Column(
          children: [
            /// searchBox and bookmark icon
            Padding(
              padding: EdgeInsets.only(
                  top: height * 0.02,
                  left: width * 0.03,
                  right: width * 0.03,),
              child: Row(
                children: [
                  /// Search Box
                  Expanded(
                      child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        onSubmitted: (String prefix) {
                          textEditingController.text = prefix;
                          BlocProvider.of<HomeBloc>(context)
                              .add(LoadCwEvent(prefix));
                        },
                        controller: textEditingController,
                        style: DefaultTextStyle.of(context).style.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                          hintText: "Enter a City...",
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),),
                    suggestionsCallback: (String prefix) async {
                      return suggestCityRepository.fetchSuggestData(prefix);
                    },
                    itemBuilder: (context, Data model) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(model.name!),
                        subtitle: Text("${model.region!}, ${model.country!}"),
                      );
                    },
                    onSuggestionSelected: (Data model) {
                      textEditingController.text = model.name!;
                      BlocProvider.of<HomeBloc>(context)
                          .add(LoadCwEvent(model.name!));
                    },
                  ),),

                  const SizedBox(width: 10,),

                  /// bookmark Icon
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current){
                      if(previous.cwStatus == current.cwStatus){
                        return false;
                      }
                      return true;
                    },
                    builder: (context, state) {

                      /// show Loading State for Cw
                      if (state.cwStatus is CwLoading) {
                        return const CircularProgressIndicator();
                      }

                      /// show Error State for Cw
                      if (state.cwStatus is CwError) {
                        return IconButton(
                            onPressed: (){
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text("please load a city!"),
                              //   behavior: SnackBarBehavior.floating, // Add this line
                              // ));
                            },
                            icon: const Icon(Icons.error,color: Colors.white,size: 35),);
                      }


                      /// show Completed State for Cw
                      if (state.cwStatus is CwCompleted) {
                        final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                        BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                        return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                      }

                      /// show Default value
                      return Container();

                    },
                  ),
                ],
              ),
            ),

            /// rest of the page
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current){
                /// rebuild just when CwStatus Changed
                if(previous.cwStatus == current.cwStatus){
                  return false;
                }

                return true;
              },
              builder: (context, state) {
                /// show Loading State for Cw
                if (state.cwStatus is CwLoading) {
                  return const Expanded(child: Center(child: DotLoadingWidget()));
                }

                /// show Completed State for Cw
                if (state.cwStatus is CwCompleted) {

                  /// casting
                  final CwCompleted cwCompleted = state.cwStatus as CwCompleted;

                  /// get data from state
                  final CurrentCityEntity cityDataEntity = cwCompleted.currentCityEntity;

                  /// create params for api call
                  final ForecastParams forecastParams = ForecastParams(cityDataEntity.coord!.lat!, cityDataEntity.coord!.lon!);

                  /// start load Fw event
                  BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));

                  /// change Times to Hour --5:55 AM/PM----
                  final sunrise = DateConverter.changeDtToDateTimeHour(cityDataEntity.sys!.sunrise,cityDataEntity.timezone);
                  final sunset =  DateConverter.changeDtToDateTimeHour(cityDataEntity.sys!.sunset,cityDataEntity.timezone);

                  return Expanded(
                    child: ListView(children: [
                      // pageView
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: SizedBox(
                          width: double.infinity,
                          height: 400,
                          child: PageView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              allowImplicitScrolling: true,
                              controller: _pageController,
                              itemCount: 2,
                              itemBuilder: (context, position) {
                                if (position == 0) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 50),
                                        child: Text(
                                          cityDataEntity.name!,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20),
                                        child: Text(
                                          cityDataEntity
                                              .weather![0].description!,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20),
                                        child: AppBackground.setIconForMain(cityDataEntity.weather![0].description),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20),
                                        child: Text(
                                          "${cityDataEntity.main!.temp!
                                                  .round()}\u00B0",
                                          style: const TextStyle(
                                              fontSize: 50,
                                              color: Colors.white,),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  "max",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,),
                                                  child: Text(
                                                    "${cityDataEntity
                                                            .main!.tempMax!
                                                            .round()}\u00B0",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10,),
                                              child: Container(
                                                color: Colors.grey,
                                                width: 2,
                                                height: 40,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  "min",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,),
                                                  child: Text(
                                                    "${cityDataEntity
                                                            .main!.tempMin!
                                                            .round()}\u00B0",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,),
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
                                  return SizedBox(
                                    height: 400,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 250,
                                        child: BlocBuilder<HomeBloc, HomeState>(
                                          buildWhen: (previous, current){
                                            /// rebuild just when fwStatus Changed
                                            if(previous.fwStatus == current.fwStatus){
                                              return false;
                                            }

                                            return true;
                                          },
                                          builder: (BuildContext context, state) {

                                            /// show Loading State for Fw
                                            if (state.fwStatus is FwLoading) {
                                              return const DotLoadingWidget();
                                            }

                                            /// show Completed State for Fw
                                            if (state.fwStatus is FwCompleted) {
                                              /// casting
                                              final FwCompleted fwCompleted = state.fwStatus as FwCompleted;
                                              final ForcastDaysModel forecastDaysModel = fwCompleted.forcastDaysModel;

                                              return Column(
                                                children: [
                                                  const Text(
                                                    "Humidity",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .only(
                                                              bottom: 20,
                                                              right: 40,
                                                              left: 20,),
                                                      child: LineChart(
                                                        sampleData1(
                                                            forecastDaysModel,),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }

                                            /// show Error State for Fw
                                            if (state.fwStatus is FwError) {
                                              final FwError fwError = state.fwStatus as FwError;
                                              return Center(
                                                child: Text(fwError.message!),
                                              );
                                            }

                                            /// show Default for Fw
                                            return Container();

                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },),
                        ),
                      ),

                      // pageView Indicator
                      Center(
                        child: SmoothPageIndicator(
                            controller: _pageController,
                            // PageController
                            count: 2,
                            effect: const ExpandingDotsEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                spacing: 5,
                                activeDotColor: Colors.white,),
                            // your preferred effect
                            onDotClicked: (index) =>
                                _pageController.animateToPage(index,
                                    duration: const Duration(microseconds: 500),
                                    curve: Curves.bounceOut,),),
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
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Center(
                              child: BlocBuilder<HomeBloc, HomeState>(
                                builder: (BuildContext context, state) {

                                  /// show Loading State for Fw
                                  if (state.fwStatus is FwLoading) {
                                    return const DotLoadingWidget();
                                  }

                                  /// show Completed State for Fw
                                  if (state.fwStatus is FwCompleted) {
                                    /// casting
                                    final FwCompleted fwCompleted = state.fwStatus as FwCompleted;
                                    final ForcastDaysModel forcastDaysModel = fwCompleted.forcastDaysModel;
                                    final List<Daily> mainDaily = forcastDaysModel.daily!;

                                    return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 8,
                                        itemBuilder: (BuildContext context,
                                            int index,) {
                                          return DaysWeatherView(
                                              daily: mainDaily[index],);
                                        },);
                                  }

                                  /// show Error State for Fw
                                  if (state.fwStatus is FwError) {
                                    final FwError fwError = state.fwStatus as FwError;
                                    return Center(
                                      child: Text(fwError.message!),
                                    );
                                  }

                                  /// show Default State for Fw
                                  return Container();

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
                        padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text("wind speed",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.amber,),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                        "${cityDataEntity.wind!.speed!} m/s",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,),),
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
                                    const Text("sunrise",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.amber,),),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.0),
                                      child: Text(sunrise,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,),),
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
                                  const Text("sunset",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.amber,),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(sunset,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,),),
                                  ),
                                ],),
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
                                  const Text("humidity",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.amber,),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                        "${cityDataEntity.main!.humidity!}%",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,),),
                                  ),
                                ],),
                              ),
                            ],),
                      ),
                      // Align(
                      //   alignment: FractionalOffset.bottomCenter,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(bottom: 5),
                      //     child: Text("powered by Besenior",style: TextStyle(color: Colors.white,fontSize: 15),),
                      //   ),
                      // )
                    ],),
                  );
                }

                /// show Error State for Cw
                if (state.cwStatus is CwError) {
                  final CwError cwError = state.cwStatus as CwError;
                  return Expanded(
                    child: Center(
                      child: Text(cwError.message!,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  );
                }

                /// show Default State for Cw
                return Container();

              },
            ),
          ],
        ),
      ),
    );
  }



  LineChartData sampleData1(ForcastDaysModel forecastDaysModel) {
    final List<Daily> mainDaily = forecastDaysModel.daily!;

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
