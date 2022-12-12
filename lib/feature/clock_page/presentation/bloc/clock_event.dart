part of 'clock_bloc.dart';

abstract class ClockEvent extends Equatable {
  const ClockEvent();
}

class DateTimeValueChanged extends ClockEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddDurationNotification extends ClockEvent {
  List<AlarmInfoModel>? alarmInfoModels;
  AddDurationNotification({this.alarmInfoModels});
  @override
  // TODO: implement props
  List<Object?> get props => [alarmInfoModels];
}
