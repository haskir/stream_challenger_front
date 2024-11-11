import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

abstract class AbstractChallengeRequester {
/*   Future<void> acceptChallenge(Challenge challenge);
  Future<void> rejectChallenge(Challenge challenge);
  Future<void> reportChallenge(Challenge challenge);
  Future<void> endChallenge(Challenge challenge); */
  Future<bool> createChallenge({
    required CreateChallengeDTO challenge,
    required Requester client,
  });
}

class ChallengesActions implements AbstractChallengeRequester {
  final String url = '${ApiPath.http}/challenges';
/*   @override
  Future<void> acceptChallenge(Challenge challenge) async {}

  @override
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
    dynamic response = await client.post(url, challenge.toJson());
    print(response);
    if (response.isRight) {
      return true;
    }
    return false;
  }
}
