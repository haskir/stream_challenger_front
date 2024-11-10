import 'package:stream_challenge/data/models/challenge.dart';

abstract class AbstractChallengeRequester {
  Future<void> acceptChallenge(Challenge challenge);
  Future<void> rejectChallenge(Challenge challenge);
  Future<void> reportChallenge(Challenge challenge);
  Future<void> endChallenge(Challenge challenge);
  Future<List<Challenge>> getChallenges();
}

class ChallengesActions extends AbstractChallengeRequester {
  @override
  Future<void> acceptChallenge(Challenge challenge) async {}

  @override
  Future<void> rejectChallenge(Challenge challenge) async {}

  @override
  Future<void> reportChallenge(Challenge challenge) async {}

  @override
  Future<void> endChallenge(Challenge challenge) async {}

  @override
  Future<List<Challenge>> getChallenges() async {
    return [
      Challenge.testAccepted(),
      Challenge.testPending(),
      Challenge.testRejected(),
      Challenge.testReported()
    ];
  }
}
