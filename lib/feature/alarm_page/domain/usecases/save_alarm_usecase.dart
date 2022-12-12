import 'dart:developer';
import 'package:alarm_clock/core/error/failure.dart';
import 'package:alarm_clock/core/usecase/usecase.dart';
import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:alarm_clock/feature/alarm_page/domain/repositories/alarm_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SaveAlarmUsecase implements UseCase<void, ParamsSaveAlarm> {
  final AlarmRepository repository;

  SaveAlarmUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(ParamsSaveAlarm params) async {
    try {
      final response = await repository.saveAlarm(params.alarmInfoModel);
      return right(response);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return left(DatabaseFailure(message: 'Cant save data to db'));
    }
  }
}

class ParamsSaveAlarm extends Equatable {
  final AlarmInfoModel? alarmInfoModel;

  const ParamsSaveAlarm({required this.alarmInfoModel});

  @override
  List<Object?> get props => [alarmInfoModel];
}
