
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherBs/presentation/pages/HomePage.dart';
import 'locator.dart';
import 'logic/bloc/cwbloc/cw_bloc.dart';
import 'logic/bloc/fwbloc/fw_bloc.dart';

Future<void> main() async {
  await setup();
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

