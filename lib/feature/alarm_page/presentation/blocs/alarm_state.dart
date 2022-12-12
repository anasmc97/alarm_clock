part of 'alarm_bloc.dart';

class AlarmState extends Equatable {
  AlarmStatus? alarmStatus;
  int? seconds = 0;
  List<AlarmInfoModel>? currentAlarms;
  Option<Either<Failure, List<AlarmInfoModel>>>? currentAlarmsOrFailureOption;

  AlarmState(
      {this.alarmStatus,
      this.currentAlarms,
      this.currentAlarmsOrFailureOption,
      this.seconds});

  AlarmState copyWith(
      {AlarmStatus? alarmStatus,
      List<AlarmInfoModel>? currentAlarms,
      Option<Either<Failure, List<AlarmInfoModel>>>?
          currentAlarmsOrFailureOption,
      int? seconds}) {
    return AlarmState(
        alarmStatus: alarmStatus ?? this.alarmStatus,
        currentAlarms: currentAlarms ?? this.currentAlarms,
        currentAlarmsOrFailureOption:
            currentAlarmsOrFailureOption ?? this.currentAlarmsOrFailureOption,
        seconds: seconds ?? this.seconds);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [alarmStatus, currentAlarms, currentAlarmsOrFailureOption, seconds];
}

enum AlarmStatus {
  initial,
  success,
  failure,
  loading,
  successLoadAlarm,
  succesAddAlarm,
  succesDeleteAlarm,
  selectedAlarmNotification,
}
