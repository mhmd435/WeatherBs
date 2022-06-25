
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherBs/presentation/bloc/cwbloc/cw_bloc.dart';
import 'package:weatherBs/presentation/bloc/fwbloc/fw_bloc.dart';
import 'package:weatherBs/presentation/pages/HomePage.dart';
import 'locator.dart';

Future<void> main() async {
  await setup();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => locator<CwBloc>()),
          BlocProvider(create: (_) => locator<FwBloc>()),
        ],
        child: Homepage(),
    )
  ));
}

