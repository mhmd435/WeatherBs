import 'package:flutter/material.dart';
import 'package:weatherBs/presentation/helpers/AppBackground.dart';
import 'package:weatherBs/presentation/screens/bookmark_screen.dart';
import 'package:weatherBs/presentation/screens/home_screen.dart';
import '../widgets/BottomNav.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key}) : super(key: key);

  final PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    final List<Widget> pageViewWidget = [
      const HomeScreen(),
      BookmarkScreen(pageController: _myPage)
    ];

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(Controller: _myPage),
      body: Container(
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AppBackground.getBackGroundImage(),
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
