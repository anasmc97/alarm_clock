part of 'alarm_bloc.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();
}

class SaveAlarmEvent extends AlarmEvent {
  DateTime? alarmTime;
  bool isRepeating;
  SaveAlarmEvent({this.alarmTime, this.isRepeating = false});
  @override
  // TODO: implement props
  List<Object?> get props => [alarmTime, isRepeating];
}

class SaveDurationRingingEvent extends AlarmEvent {
  String? duration;
  String? id;
  SaveDurationRingingEvent({this.duration, this.id});
  @override
  // TODO: implement props
  List<Object?> get props => [duration, id];
}

class LoadAlarmsEvent extends AlarmEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DeleteAlarmEvent extends AlarmEvent {
  int? id;
  DeleteAlarmEvent({required this.id});
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class InitAlarmNotificationEvent extends AlarmEvent {
  bool? initScheduled;
  InitAlarmNotificationEvent({this.initScheduled = false});
  @override
  // TODO: implement props
  List<Object?> get props => [initScheduled];
}

class ScheduleAlarmNotificationEvent extends AlarmEvent {
  int? id;
  AlarmInfoModel? alarmInfoModel;
  String? payload;
  DateTime? scheduledDate;
  ScheduleAlarmNotificationEvent(
      {this.id,
      this.alarmInfoModel,
      this.payload,
      required this.scheduledDate});
  @override
  // TODO: implement props
  List<Object?> get props => [id, alarmInfoModel, payload, scheduledDate];
}

class SelectedAlarmNotificationEvent extends AlarmEvent {
  String? payload;
  SelectedAlarmNotificationEvent({this.payload});
  @override
  // TODO: implement props
  List<Object?> get props => [payload];
}

class AddSecondsEvent extends AlarmEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitBackGroundServiceTimerEvent extends AlarmEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
