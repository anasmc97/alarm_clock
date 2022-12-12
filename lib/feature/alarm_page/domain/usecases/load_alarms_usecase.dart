import 'dart:developer';
import 'package:alarm_clock/core/error/failure.dart';
import 'package:alarm_clock/core/usecase/usecase.dart';
import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:alarm_clock/feature/alarm_page/domain/repositories/alarm_repository.dart';
import 'package:dartz/dartz.dart';

class LoadAlarmsUsecase implements UseCase<List<AlarmInfoModel>, NoParams> {
  final AlarmRepository repository;

  LoadAlarmsUsecase(this.repository);

  @override
  Future<Either<Failure, List<AlarmInfoModel>>> call(NoParams params) async {
    try {
      final response = await repository.loadAlarms();
      return right(response);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return left(DatabaseFailure(message: 'Cant get data from db'));
    }
  }
}
