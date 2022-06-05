
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class DotLoadingWidget extends StatelessWidget {
  const DotLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: JumpingDotsProgressIndicator(
          color: Colors.white,
          fontSize: 60,
          dotSpacing: 2,
        ));
  }
}
