import 'dart:developer';
import 'package:alarm_clock/core/error/failure.dart';
import 'package:alarm_clock/core/usecase/usecase.dart';
import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:alarm_clock/feature/alarm_page/domain/repositories/alarm_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteAlarmUsecase implements UseCase<int?, ParamsDeleteAlarm> {
  final AlarmRepository repository;

  DeleteAlarmUsecase(this.repository);

  @override
  Future<Either<Failure, int?>> call(ParamsDeleteAlarm params) async {
    try {
      final response = await repository.deleteAlarm(params.id);
      return right(response!);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return left(DatabaseFailure(message: 'Cant delete data from db'));
    }
  }
}

class ParamsDeleteAlarm extends Equatable {
  final int? id;

  const ParamsDeleteAlarm({required this.id});

  @override
  List<Object?> get props => [id];
}
