import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weatherBs/core/widgets/app_background.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import 'package:weatherBs/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weatherBs/features/feature_weather/presentation/screens/home_screen.dart';
import 'package:weatherBs/locator.dart';
import '../../core/widgets/bottom_nav.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key}) : super(key: key);

  final PageController _myPage = PageController(initialPage: 0);
  final String cityName = "Tehran";

  @override
  Widget build(BuildContext context) {

    final List<Widget> pageViewWidget = [
      BlocProvider<HomeBloc>(
          create: (context) => locator<HomeBloc>()..add(LoadCwEvent(cityName)),
          child: const HomeScreen()
      ),
      BookmarkScreen(pageController: _myPage)
    ];

    var height = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk').format(now);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(Controller: _myPage),
      body: Container(
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AppBackground.getBackGroundImage(formattedDate),
              fit: BoxFit.cover,)),
        child: PageView(
          controller: _myPage,
          children: pageViewWidget,
          // physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
