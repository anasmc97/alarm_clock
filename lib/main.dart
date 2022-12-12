import 'dart:async';
import 'dart:developer';

import 'package:alarm_clock/feature/alarm_page/presentation/blocs/alarm_bloc.dart';
import 'package:alarm_clock/feature/clock_page/presentation/bloc/clock_bloc.dart';
import 'package:alarm_clock/feature/clock_page/presentation/ui/clock_page.dart';
import 'package:alarm_clock/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await di.init();
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ClockBloc(),
          ),
          BlocProvider(
            create: (context) => sl<AlarmBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'Clock App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const ClockPage(),
        ),
      ),
    );
  }
}
