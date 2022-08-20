
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherBs/core/bloc/bottom_icon_cubit.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'core/widgets/main_wrapper.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => locator<BookmarkBloc>()),
          BlocProvider(create: (_) => locator<BottomIconCubit>()),
        ],
        child: MainWrapper(),
    )
  ));
}

