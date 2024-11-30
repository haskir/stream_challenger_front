import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers/api.dart';

class ChallengesActions {
  static String url = '${ApiPath.http}/challenges';

  static Future<Either<ErrorDTO, Challenge>> challengeCreate({
    required CreateChallengeDTO challenge,
    required Requester client,
  }) async {
    return (await client.post(url, body: challenge.toMap())).fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }

  static Future<Either> challengeAction({
    required Challenge challenge,
    required Requester requester,
    required String action,
  }) async {
    final result = await requester.post('/challenges/${challenge.id}',
        query: {'action': action.toUpperCase()});
    return result;
  }

  static Future<Either<ErrorDTO, Challenge?>> payFailedChallenge({
    required Challenge challenge,
    required Requester client,
    required double decimalPercentage,
  }) async {
    final result = (await client.post(
      '/challenges/${challenge.id}/pay',
      body: ({'percentage': decimalPercentage}),
    ));
    return result.fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }
}
