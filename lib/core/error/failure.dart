import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class UserFailure extends Failure {}

class AuthFailure extends Failure {}

class NotFoundFailure extends Failure {}

class UnknownFailure extends Failure {}
