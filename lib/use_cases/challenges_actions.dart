import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers/api.dart';

abstract class AbstractChallengeRequester {
  Future<Either> challengeAction({
    required Challenge challenge,
    required Requester requester,
    required String action,
  });
  Future<Either<ErrorDTO, Challenge>> challengeCreate({
    required CreateChallengeDTO challenge,
    required Requester client,
  });

  Future<Either<ErrorDTO, Challenge?>> payFailedChallenge({
    required int id,
    required double percentage,
    required Requester client,
  });
}

class ChallengesActions implements AbstractChallengeRequester {
  static String url = '${ApiPath.http}/challenges';

  @override
  Future<Either<ErrorDTO, Challenge>> challengeCreate({
    required CreateChallengeDTO challenge,
    required Requester client,
  }) async {
    return (await client.post(url, body: challenge.toMap())).fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }

  @override
  Future<Either> challengeAction({
    required Challenge challenge,
    required Requester requester,
    required String action,
  }) async {
    final result = await requester.post('/challenges/${challenge.id}',
        query: {'action': action.toUpperCase()});
    if (kDebugMode) {
      print(result);
    }
    return result;
  }

  @override
  Future<Either<ErrorDTO, Challenge?>> payFailedChallenge({
    required int id,
    required double percentage,
    required Requester client,
  }) async {
    final result = (await client.post(
      '/challenges/$id/pay',
      body: ({'percentage': percentage}),
    ));
    result.fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
    return Right(null);
  }
}
