import 'dart:async';

import 'package:alarm_clock/core/utils/shared_value.dart';
import 'package:alarm_clock/feature/alarm_page/domain/entities/alarm_info_entity.dart';
import 'package:alarm_clock/feature/alarm_page/presentation/blocs/alarm_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;
  bool _isRepeatSelected = false;
  List<AlarmInfo>? _currentAlarms;
  DateTime now = DateTime.now();

  @override
  void initState() {
    context.read<AlarmBloc>().add(LoadAlarmsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      body: BlocListener<AlarmBloc, AlarmState>(
        listener: (context, state) {
          if (state.alarmStatus == AlarmStatus.succesAddAlarm) {
            context.read<AlarmBloc>().add(LoadAlarmsEvent());
            Navigator.pop(context);
          }
          if (state.alarmStatus == AlarmStatus.succesDeleteAlarm) {
            context.read<AlarmBloc>().add(LoadAlarmsEvent());
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Alarm',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 24),
              ),
              Expanded(
                child: BlocBuilder<AlarmBloc, AlarmState>(
                  builder: (context, state) {
                    if (state.currentAlarms != null) {
                      _currentAlarms = state.currentAlarms;
                    } else {
                      _currentAlarms = [];
                    }
                    return ListView(
                      children: _currentAlarms!.map<Widget>((alarm) {
                        var alarmTime =
                            DateFormat('hh:mm aa').format(alarm.alarmDateTime!);
                        var gradientColor = GradientTemplate
                            .gradientTemplate[alarm.gradientColorIndex!].colors;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColor,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColor.last.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(4, 4),
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.label,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        alarm.title!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'avenir'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Text(
                                'Mon-Fri',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'avenir'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    alarmTime,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'avenir',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      context.read<AlarmBloc>().add(
                                            DeleteAlarmEvent(
                                              id: alarm.id,
                                            ),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).followedBy([
                        if (_currentAlarms!.length < 5)
                          DottedBorder(
                            strokeWidth: 2,
                            color: CustomColors.clockOutline,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(24),
                            dashPattern: const [5, 4],
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: CustomColors.clockBG,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                              ),
                              child: MaterialButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                onPressed: () {
                                  _alarmTimeString = DateFormat('HH:mm')
                                      .format(DateTime.now());
                                  showModalBottomSheet(
                                    useRootNavigator: true,
                                    context: context,
                                    clipBehavior: Clip.antiAlias,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Container(
                                            padding: const EdgeInsets.all(32),
                                            child: Column(
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    var selectedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                    if (selectedTime != null) {
                                                      final now =
                                                          DateTime.now();
                                                      var selectedDateTime =
                                                          DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              selectedTime.hour,
                                                              selectedTime
                                                                  .minute);
                                                      _alarmTime =
                                                          selectedDateTime;
                                                      setModalState(() {
                                                        _alarmTimeString =
                                                            DateFormat('HH:mm')
                                                                .format(
                                                                    selectedDateTime);
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    _alarmTimeString,
                                                    style: const TextStyle(
                                                        fontSize: 32),
                                                  ),
                                                ),
                                                ListTile(
                                                  title: const Text('Repeat'),
                                                  trailing: Switch(
                                                    onChanged: (value) {
                                                      setModalState(() {
                                                        _isRepeatSelected =
                                                            value;
                                                      });
                                                    },
                                                    value: _isRepeatSelected,
                                                  ),
                                                ),
                                                const ListTile(
                                                  title: Text('Sound'),
                                                  trailing: Icon(
                                                      Icons.arrow_forward_ios),
                                                ),
                                                const ListTile(
                                                  title: Text('Title'),
                                                  trailing: Icon(
                                                      Icons.arrow_forward_ios),
                                                ),
                                                FloatingActionButton.extended(
                                                  onPressed: () {
                                                    context
                                                        .read<AlarmBloc>()
                                                        .add(SaveAlarmEvent(
                                                            alarmTime:
                                                                _alarmTime,
                                                            isRepeating:
                                                                _isRepeatSelected));
                                                  },
                                                  icon: const Icon(Icons.alarm),
                                                  label: const Text('Save'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                  // scheduleAlarm();
                                },
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/add_alarm.png',
                                      scale: 1.5,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Add Alarm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          const Center(
                              child: Text(
                            'Only 5 alarms allowed!',
                            style: TextStyle(color: Colors.white),
                          )),
                      ]).toList(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void onSaveAlarm(bool _isRepeating) {
  //   DateTime? scheduleAlarmDateTime;
  //   if (_alarmTime!.isAfter(DateTime.now())) {
  //     scheduleAlarmDateTime = _alarmTime;
  //   } else {
  //     scheduleAlarmDateTime = _alarmTime!.add(const Duration(days: 1));
  //   }
  //
  //   var alarmInfo = AlarmInfo(
  //     alarmDateTime: scheduleAlarmDateTime,
  //     gradientColorIndex: _currentAlarms!.length,
  //     title: 'alarm',
  //   );
  //   _alarmHelper.insertAlarm(alarmInfo);
  //   if (scheduleAlarmDateTime != null) {
  //     scheduleAlarm(scheduleAlarmDateTime, alarmInfo,
  //         isRepeating: _isRepeating);
  //   }
  //   Navigator.pop(context);
  //   loadAlarms();
  // }

  // void deleteAlarm(int? id) {
  //   _alarmHelper.delete(id);
  //   //unsubscribe for notification
  //   loadAlarms();
  // }
}
