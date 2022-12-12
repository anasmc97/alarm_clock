part of 'clock_bloc.dart';

class ClockState extends Equatable {
  ClockStatus? clockStatus;
  DateTime? dateTime;
  int? duration = 0;
  ClockState({this.clockStatus, this.dateTime, this.duration});

  ClockState copyWith(
      {ClockStatus? clockStatus, DateTime? dateTime, int? duration}) {
    return ClockState(
        clockStatus: clockStatus ?? this.clockStatus,
        dateTime: dateTime ?? this.dateTime,
        duration: duration ?? this.duration);
  }

  @override
  String toString() {
    return '''ClockState { clockStatus: $clockStatus, dateTime: $dateTime }''';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [clockStatus, dateTime, duration];
}

enum ClockStatus {
  initial,
  success,
  failure,
  loading,
}
