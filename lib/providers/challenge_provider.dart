import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/models/challenge.dart';
import 'package:stream_challenge/providers/providers.dart';

class GetStruct {
  final List<String> statuses;
  final int page;
  final int size;
  final bool isAuthor;

  GetStruct({
    required this.statuses,
    required this.page,
    required this.size,
    required this.isAuthor,
  });

  Map<String, dynamic> toMap() {
    return {
      'statuses': statuses,
      'page': page.toString(),
      'size': size.toString(),
      'is_author': isAuthor.toString(),
    };
  }
}

class ChallengeGetter {
  static const path = '/challenge';

  static Future<Either<ErrorDTO, Challenge>> getChallenge({
    required int id,
    required Requester client,
  }) async {
    final response = await client.get('$path/$id');
    return response.fold(
      (left) => Left(left),
      (right) => Right(Challenge.fromMap(right)),
    );
  }

  static Future<Either<ErrorDTO, List<Challenge>>> getChallenges({
    required GetStruct getStruct,
    required Requester client,
  }) async {
    final response = await client.get(
      path,
      getStruct.toMap(),
    );
    try {
      return response.fold((error) => Left(error), (array) {
        if (array == null) {
          return Right(List<Challenge>.empty());
        }
        final challenges = (array as List<dynamic>).map((e) => Challenge.fromMap(e)).toList();

        return Right(challenges);
      });
    } catch (e) {
      return Left(
        ErrorDTO(message: "Error fetching challenges: $e", type: "clientError", code: -500),
      );
    }
  }
}

final challengeProvider = FutureProvider.family<Either<ErrorDTO, Challenge>, int>((ref, id) async {
  final client = await ref.watch(httpClientProvider.future);
  final result = await ChallengeGetter.getChallenge(id: id, client: client);
  return result;
});

final challengesProvider = FutureProvider.family<List<Challenge>?, GetStruct>((ref, getStruct) async {
  try {
    final result = await ChallengeGetter.getChallenges(
      getStruct: getStruct,
      client: await ref.watch(httpClientProvider.future),
    );
    return result.fold(
      (error) {
        if (kDebugMode) print("authorChallengesProvider0 $error");
        return null;
      },
      (challenges) => challenges,
    );
  } catch (error) {
    print("authorChallengesProvider1 error: $error");
    return null;
  }
});
