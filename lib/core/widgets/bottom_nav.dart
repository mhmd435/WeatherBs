import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherBs/core/bloc/bottom_icon_cubit.dart';


class BottomNav extends StatelessWidget {
  final PageController controller;
  BottomNav({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    var state = context.watch<BottomIconCubit>().state;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: primaryColor,
      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: (){
                  BlocProvider.of<BottomIconCubit>(context).gotoHome();
                  controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
                icon: Icon(state == 0 ? Icons.home : Icons.home_outlined)),
            SizedBox(),
            IconButton(onPressed: (){
              BlocProvider.of<BottomIconCubit>(context).gotoBookMark();
              controller.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            }, icon: Icon(state == 1 ? Icons.bookmark : Icons.bookmark_border_rounded)),
          ],
        ),
      ),
    );
  }
}