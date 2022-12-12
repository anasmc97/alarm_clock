import 'dart:async';

import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  ClockBloc() : super(ClockState()) {
    on<DateTimeValueChanged>(_onDateTimeValueChanged);
  }

  FutureOr<void> _onDateTimeValueChanged(
      DateTimeValueChanged event, Emitter<ClockState> emit) async {
    var dateTime = DateTime.now();
    emit(state.copyWith(dateTime: dateTime));
  }
}
