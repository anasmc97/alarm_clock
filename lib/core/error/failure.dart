import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class DatabaseFailure extends Failure {
  final String message;

  DatabaseFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String get failureMessage => message;
}
