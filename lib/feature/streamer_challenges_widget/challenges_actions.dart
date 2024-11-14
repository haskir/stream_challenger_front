import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

abstract class AbstractChallengeRequester {
  Future<Either> challengeAction(
    Challenge challenge,
    Requester requester,
    String action,
  );
  Future<String> challengeCreate({
    required CreateChallengeDTO challenge,
    required Requester client,
  });
}

class ChallengesActions implements AbstractChallengeRequester {
  static String url = '${ApiPath.http}/challenges';

  @override
  Future<String> challengeCreate({
    required CreateChallengeDTO challenge,
    required Requester client,
  }) async {
    final result = await client.post(
      url,
      body: challenge.toMap(),
    );
    return result.fold((left) => left.toString(), (right) => right.toString());
  }

  @override
  Future<Either> challengeAction(
    Challenge challenge,
    Requester requester,
    String action,
  ) async {
    final result = await requester.post('/challenges/${challenge.id}',
        query: {'action': action.toUpperCase()});
    if (kDebugMode) {
      print(result);
    }
    return result;
  }

/*    @override
  Future<void> rejectChallenge(Challenge challenge) async {}

  @override
  Future<void> reportChallenge(Challenge challenge) async {}

  @override
  Future<void> endChallenge(Challenge challenge) async {} */
}
