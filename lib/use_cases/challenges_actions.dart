import 'package:dartz/dartz.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/models/challenge.dart';

class ChallengesActions {
  static const path = "/challenge";

  static Future<Either<ErrorDTO, Challenge>> challengeCreate({
    required CreateChallengeDTO challenge,
    required Requester client,
  }) async {
    return (await client.post(path, body: challenge.toMap())).fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }

  static Future<Either> challengeAction({
    required Challenge challenge,
    required Requester requester,
    required String action,
  }) async {
    final result = await requester.post('$path/${challenge.id}/action', query: {'action': action.toUpperCase()});
    return result;
  }

  static Future<Either<ErrorDTO, Challenge?>> payFailedChallenge({
    required Challenge challenge,
    required Requester client,
    required double decimalPercentage,
  }) async {
    final result = await client.post(
      '$path/${challenge.id}/pay',
      body: ({'percentage': decimalPercentage}),
    );
    return result.fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }

  static Future<Either<ErrorDTO, Report?>> reportChallege({
    required Challenge challenge,
    required Requester client,
    required CreateReportDTO report,
  }) async {
    report.reason = report.reason.toUpperCase();
    final result = (await client.post(
      '/reports',
      body: report.toMap(),
    ));
    return result.fold(
      (left) => Left(left),
      (right) => Right(Report.fromMap(right)),
    );
  }

  static Future<Either<ErrorDTO, Challenge?>> rateChallenge({
    required Challenge challenge,
    required Requester client,
    required int rating,
  }) async {
    final result = await client.post(
      '$path/${challenge.id}/rate',
      query: ({'value': rating}),
    );
    return result.fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }
}
