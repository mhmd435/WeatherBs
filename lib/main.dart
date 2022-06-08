
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/logic/bloc/cwbloc/cw_bloc.dart';
import 'package:weather_app/logic/bloc/fwbloc/fw_bloc.dart';
import 'package:weather_app/presentation/pages/HomePage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CwBloc()),
          BlocProvider(create: (_) => FwBloc()),
        ],
        child: Homepage(),
    )
  ));
}

