import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:alarm_clock/core/error/failure.dart';
import 'package:alarm_clock/core/usecase/usecase.dart';
import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/delete_alarm_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/load_alarms_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/save_alarm_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/save_duration_ringing_usecase.dart';
import 'package:alarm_clock/main.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:alarm_clock/core/extensions/dartz_extension.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:collection/collection.dart';

part 'alarm_event.dart';
part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  static final _notifications = FlutterLocalNotificationsPlugin();
  final SaveAlarmUsecase saveAlarm;
  final LoadAlarmsUsecase loadAlarms;
  final DeleteAlarmUsecase deleteAlarm;
  final SaveDurationRingingUsecase saveDurationRinging;
  final FlutterLocalNotificationsPlugin notifications;
  AlarmBloc({
    required this.saveAlarm,
    required this.loadAlarms,
    required this.deleteAlarm,
    required this.saveDurationRinging,
    required this.notifications,
  }) : super(AlarmState()) {
    on<SaveAlarmEvent>(_onSaveAlarmEvent);
    on<LoadAlarmsEvent>(_onLoadAlarmsEvent);
    on<DeleteAlarmEvent>(_onDeleteAlarmEvent);
    on<InitAlarmNotificationEvent>(_onInitAlarmNotificationEvent);
    on<SelectedAlarmNotificationEvent>(_onSelectedAlarmNotificationEvent);
    on<ScheduleAlarmNotificationEvent>(_onScheduleAlarmNotificationEvent);
    on<SaveDurationRingingEvent>(_onSaveDurationRingingEvent);
    on<AddSecondsEvent>(_onAddSecondsEvent);
  }
  late Timer timer;
  FutureOr<void> _onSaveAlarmEvent(
      SaveAlarmEvent event, Emitter<AlarmState> emit) async {
    DateTime? scheduleAlarmDateTime;
    if (event.alarmTime!.isAfter(DateTime.now())) {
      scheduleAlarmDateTime = event.alarmTime;
    } else {
      scheduleAlarmDateTime = event.alarmTime?.add(const Duration(days: 1));
    }
    var id = '${scheduleAlarmDateTime?.hour}${scheduleAlarmDateTime?.minute}';
    var alarmInfoModel = AlarmInfoModel(
        alarmDateTime: scheduleAlarmDateTime,
        gradientColorIndex: state.currentAlarms?.length ?? 0,
        title: 'alarm',
        duration: null,
        id: int.parse(id));
    saveAlarm.call(ParamsSaveAlarm(alarmInfoModel: alarmInfoModel));
    add(ScheduleAlarmNotificationEvent(
        scheduledDate: scheduleAlarmDateTime, alarmInfoModel: alarmInfoModel));
    emit(state.copyWith(alarmStatus: AlarmStatus.succesAddAlarm));
    emit(state.copyWith(alarmStatus: AlarmStatus.initial));
  }

  FutureOr<void> _onDeleteAlarmEvent(
      DeleteAlarmEvent event, Emitter<AlarmState> emit) async {
    await notifications.cancel(event.id!);
    deleteAlarm.call(ParamsDeleteAlarm(id: event.id));
    emit(state.copyWith(alarmStatus: AlarmStatus.succesDeleteAlarm));
    emit(state.copyWith(alarmStatus: AlarmStatus.initial));
  }

  FutureOr<void> _onLoadAlarmsEvent(
      LoadAlarmsEvent event, Emitter<AlarmState> emit) async {
    final result = await loadAlarms(NoParams());
    if (result.isLeft()) {
      state.copyWith(
        currentAlarmsOrFailureOption: optionOf(
          left(result.getLeft()!),
        ),
      );
    }
    if (result.isRight()) {
      state.copyWith(
        currentAlarmsOrFailureOption: optionOf(
          right(result.getRight()!),
        ),
      );
      emit(
        state.copyWith(
            currentAlarmsOrFailureOption: none(),
            currentAlarms: result.getRight(),
            alarmStatus: AlarmStatus.successLoadAlarm),
      );
      emit(state.copyWith(alarmStatus: AlarmStatus.initial));
    }
  }

  FutureOr<void> _onInitAlarmNotificationEvent(
      InitAlarmNotificationEvent event, Emitter<AlarmState> emit) async {
    String navigationActionId = 'id_3';
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: IOS);

    ///when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      add(SelectedAlarmNotificationEvent(
          payload: details.notificationResponse?.payload ?? ''));
    }
    await _notifications.initialize(settings, onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          add(
            SelectedAlarmNotificationEvent(
                payload: notificationResponse.payload),
          );
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            add(
              SelectedAlarmNotificationEvent(
                  payload: notificationResponse.payload),
            );
          }
          break;
      }
    });
    if (event.initScheduled ?? false) {
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  FutureOr<void> _onSelectedAlarmNotificationEvent(
      SelectedAlarmNotificationEvent event, Emitter<AlarmState> emit) async {
    emit(state.copyWith(alarmStatus: AlarmStatus.selectedAlarmNotification));
    emit(state.copyWith(alarmStatus: AlarmStatus.initial));
  }

  FutureOr<void> _onScheduleAlarmNotificationEvent(
      ScheduleAlarmNotificationEvent event, Emitter<AlarmState> emit) async {
    notifications.zonedSchedule(
        event.alarmInfoModel?.id ?? 0,
        event.alarmInfoModel?.title ?? "",
        "Your Alarm is Ringing",
        // ]),
        tz.TZDateTime.from(event.scheduledDate!, tz.local),
        await notificationDetails(),
        payload: "alarm.abs",
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  FutureOr<void> _onSaveDurationRingingEvent(
      SaveDurationRingingEvent event, Emitter<AlarmState> emit) async {
    saveDurationRinging.call(
      ParamsSaveDurationRinging(id: event.id, duration: event.duration),
    );
    emit(state.copyWith(seconds: 0));
  }

  FutureOr<void> _onAddSecondsEvent(
      AddSecondsEvent event, Emitter<AlarmState> emit) async {
    emit(
      state.copyWith(seconds: state.seconds! + 1),
    );
  }

  static Future notificationDetails() async {
    const sound = 'a_long_cold_sting.wav';
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id 4',
          'channel name',
          channelDescription: 'channel description',
          sound: RawResourceAndroidNotificationSound(sound.split('.').first),
          importance: Importance.max,
        ),
        iOS: const DarwinNotificationDetails());
  }
}
