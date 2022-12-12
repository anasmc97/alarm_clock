import 'package:alarm_clock/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<ReturnType, Params> {
  const UseCase();
  Future<Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
