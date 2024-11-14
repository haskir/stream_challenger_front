import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

abstract class AbstractChallengeRequester {
  Future<void> acceptChallenge(Challenge challenge, Requester requester);
  /* Future<void> rejectChallenge(Challenge challenge, Requester requester);
  Future<void> reportChallenge(Challenge challenge, Requester requester);
  static Future<void> endChallenge(Challenge challenge, Requester requester); */
  Future<bool> createChallenge({
    required CreateChallengeDTO challenge,
    required Requester client,
  });
}

class ChallengesActions implements AbstractChallengeRequester {
  static String url = '${ApiPath.http}/challenges';

  @override
  Future<void> acceptChallenge(Challenge challenge, Requester requester) async {
    final result = await requester.post(
      '/challenges/${challenge.id}',
      {'status': 'ACCEPTED'},
      null,
    );
    if (kDebugMode) {
      print(result);
    }
  }

/*    @override
  Future<void> rejectChallenge(Challenge challenge) async {}

  @override
  Future<void> reportChallenge(Challenge challenge) async {}

  @override
  Future<void> endChallenge(Challenge challenge) async {} */

  @override
  Future<bool> createChallenge({
    required CreateChallengeDTO challenge,
    required Requester client,
  }) async {
    Either response = await client.post(url, challenge.toMap(), {});
    return response.isRight();
  }
}
