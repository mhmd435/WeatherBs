
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherBs/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:weatherBs/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:weatherBs/presentation/screens/MainWrapper.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => locator<BookmarkBloc>()),
          BlocProvider(create: (_) => locator<HomeBloc>()),
        ],
        child: MainWrapper(),
    )
  ));
}

