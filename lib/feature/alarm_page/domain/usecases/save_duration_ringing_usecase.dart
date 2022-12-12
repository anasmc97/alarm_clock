import 'dart:developer';
import 'package:alarm_clock/core/error/failure.dart';
import 'package:alarm_clock/core/usecase/usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/repositories/alarm_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SaveDurationRingingUsecase
    implements UseCase<int?, ParamsSaveDurationRinging> {
  final AlarmRepository repository;

  SaveDurationRingingUsecase(this.repository);

  @override
  Future<Either<Failure, int?>> call(ParamsSaveDurationRinging params) async {
    try {
      final response =
          await repository.saveDurationRinging(params.duration, params.id);
      return right(response);
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
      return left(DatabaseFailure(message: 'Cant save data to db'));
    }
  }
}

class ParamsSaveDurationRinging extends Equatable {
  final String? duration;
  final String? id;

  const ParamsSaveDurationRinging({required this.duration, required this.id});

  @override
  List<Object?> get props => [duration, id];
}
