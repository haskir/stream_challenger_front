import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers.dart';

class _ChallenegeGetter {
  static Future<Either<ErrorDTO, Challenge>> getChallenge({
    required int id,
    required Requester client,
  }) async {
    final response = await client.get('/challenges/$id');
    return response.fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }
}

final challengeProvider =
    FutureProvider.family<Either<ErrorDTO, Challenge>, int>((ref, id) async {
  final client = await ref.watch(httpClientProvider.future);

  final result = await _ChallenegeGetter.getChallenge(
    id: id,
    client: client,
  );

  return result.fold(
    (error) => left(error),
    (challenge) => right(challenge),
  );
});
