import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/error/exception.dart';
import 'package:stream_challenge/core/error/failure.dart';
import 'package:stream_challenge/core/platform/network_info.dart';
import 'package:stream_challenge/feature/data/datasources/person_remote_data_source.dart';
import 'package:stream_challenge/feature/domain/repositories/abstract_repository.dart';

import '../models/user.dart';

class PersonRepositoryImpl implements AbstractRepository {
  final UserRequester remoteDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<User>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDataSource.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<User>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDataSource.searchPerson(query);
    });
  }

  Future<Either<Failure, List<User>>> _getPersons(
      Future<List<User>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPersons();
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
/*       try {
        final localPerson = await localDataSource.getLastPersonsFromCache();
        return Right(localPerson);
      } on CacheException {
        return Left(CacheFailure());
      } */
    }
  }
}
