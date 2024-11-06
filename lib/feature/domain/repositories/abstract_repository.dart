import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/error/failure.dart';
import 'package:stream_challenge/feature/data/models/user.dart';

abstract class AbstractRepository {
  Future<Either<Failure, List<User>>> getAllPersons(int page);
  Future<Either<Failure, List<User>>> searchPerson(String query);
}
