import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

class _ChallenegeGetter {
  static Future<Challenge?> getChallenge({
    required int id,
    required Requester client,
  }) async {
    final response = await client.get('/challenges/$id');
    return response.fold(
      (left) => null,
      (right) => Challenge.fromJson(right["data"]),
    );
  }
}

final challengeProvider =
    FutureProvider.family<Challenge?, int>((ref, id) async {
  return _ChallenegeGetter.getChallenge(
    id: id,
    client: ref.read(httpClientProvider),
  );
});
