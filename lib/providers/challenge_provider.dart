// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/providers/providers.dart';

class GetStruct {
  final String status;
  final int page;
  final int size;

  GetStruct({required this.status, required this.page, required this.size});

  Map<String, String> toMap() {
    return {
      'status': status,
      'page': page.toString(),
      'size': size.toString(),
    };
  }

  factory GetStruct.fromMap(Map<String, dynamic> map) {
    return GetStruct(
      status: map['status'] as String,
      page: map['page'] as int,
      size: map['size'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetStruct.fromJson(String source) =>
      GetStruct.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ChallengeGetter {
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

  static Future<Either<ErrorDTO, List<Challenge>>> getChallenges({
    required GetStruct getStruct,
    required Requester client,
    required bool isAuthor,
  }) async {
    final response = await client.get(
      isAuthor ? '/challenges/author' : '/challenges/performer',
      getStruct.toMap(),
    );
    try {
      return response.fold((error) => Left(error), (array) {
        if (array == null) {
          return Right(List<Challenge>.empty());
        }
        final challenges =
            (array as List<dynamic>).map((e) => Challenge.fromMap(e)).toList();

        return Right(challenges);
      });
    } catch (e) {
      return Left(
        ErrorDTO(
            message: "Error fetching challenges: $e",
            type: "clientError",
            code: -500),
      );
    }
  }
}

final challengeProvider =
    FutureProvider.family<Either<ErrorDTO, Challenge>, int>((ref, id) async {
  final client = await ref.watch(httpClientProvider.future);
  final result = await ChallengeGetter.getChallenge(id: id, client: client);
  return result;
});

final authorChallengesProvider =
    FutureProvider.family<List<Challenge>?, GetStruct>((ref, getStruct) async {
  try {
    final result = await ChallengeGetter.getChallenges(
      getStruct: getStruct,
      client: await ref.watch(httpClientProvider.future),
      isAuthor: true,
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

final performerChallengesProvider =
    FutureProvider.family<List<Challenge>?, GetStruct>((ref, getStruct) async {
  try {
    final result = await ChallengeGetter.getChallenges(
      getStruct: getStruct,
      client: await ref.watch(httpClientProvider.future),
      isAuthor: false,
    );
    return result.fold(
      (error) {
        if (kDebugMode) print("performerChallengesProvider $error");
        return null;
      },
      (challenges) => challenges,
    );
  } catch (error) {
    print("performerChallengesProvider error: $error");
    return null;
  }
});
