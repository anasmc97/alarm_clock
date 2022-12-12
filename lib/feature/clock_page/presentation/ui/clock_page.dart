import 'dart:async';
import 'dart:developer';
import 'package:alarm_clock/feature/clock_page/presentation/bloc/clock_bloc.dart';
import 'package:collection/collection.dart';
import 'package:alarm_clock/core/utils/shared_value.dart';
import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:alarm_clock/feature/alarm_page/presentation/blocs/alarm_bloc.dart';
import 'package:alarm_clock/feature/alarm_page/presentation/pages/alarm_bar_chart_page.dart';
import 'package:alarm_clock/feature/alarm_page/presentation/pages/alarm_page.dart';
import 'package:alarm_clock/feature/clock_page/presentation/widgets/clock_view.dart';
import 'package:alarm_clock/feature/clock_page/presentation/widgets/digital_clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  int seconds = 0;
  DateTime now = DateTime.now();
  @override
  void initState() {
    context
        .read<AlarmBloc>()
        .add(InitAlarmNotificationEvent(initScheduled: true));
    context.read<AlarmBloc>().add(LoadAlarmsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    return BlocListener<AlarmBloc, AlarmState>(
      listener: (context, alarmState) {
        if (alarmState.alarmStatus == AlarmStatus.selectedAlarmNotification) {
          print('detiknya nih: ' + alarmState.seconds.toString());
          context.read<AlarmBloc>().add(SaveDurationRingingEvent(
                id: '${now.hour}${now.minute}',
                duration: alarmState.seconds.toString(),
              ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<AlarmBloc>.value(
                value: context.read<AlarmBloc>(),
                child: const AlarmBarChartPage(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: CustomColors.pageBackgroundColor,
        floatingActionButton: SizedBox(
          height: 75.0,
          width: 75.0,
          child: FloatingActionButton(
            backgroundColor: CustomColors.minHandStatColor,
            child: Icon(
              Icons.alarm,
              color: CustomColors.clockOutline,
              size: 50,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<AlarmBloc>.value(
                    value: context.read<AlarmBloc>(),
                    child: const AlarmPage(),
                  ),
                ),
              );
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Clock',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const DigitalClockWidget(),
                  Text(
                    formattedDate,
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w300,
                        color: CustomColors.primaryTextColor,
                        fontSize: 20),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: ClockView(
                  size: MediaQuery.of(context).size.height / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
