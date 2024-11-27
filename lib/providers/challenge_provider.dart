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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'page': page,
      'size': size,
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

class _ChallengeGetter {
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
    return response.fold(
      (left) => Left(left),
      (right) =>
          Right((right as List).map((e) => Challenge.fromMap(e)).toList()),
    );
  }

  static Future<Either<ErrorDTO, List<Challenge>>> getPerformerChallenges(
      {required GetStruct getStruct, required Requester client}) async {
    return await getChallenges(
        getStruct: getStruct, client: client, isAuthor: false);
  }

  static Future<Either<ErrorDTO, List<Challenge>>> getAuthorChallenges(
      {required GetStruct getStruct, required Requester client}) async {
    return await getChallenges(
        getStruct: getStruct, client: client, isAuthor: true);
  }
}

final challengeProvider =
    FutureProvider.family<Either<ErrorDTO, Challenge>, int>((ref, id) async {
  final client = await ref.watch(httpClientProvider.future);

  final result = await _ChallengeGetter.getChallenge(
    id: id,
    client: client,
  );

  return result.fold(
    (error) => left(error),
    (challenge) => right(challenge),
  );
});

final authorChallengesProvider =
    FutureProvider.family<List<Challenge>?, GetStruct>(
  (ref, getStruct) async {
    final client = await ref.watch(httpClientProvider.future);

    final result = await _ChallengeGetter.getAuthorChallenges(
      getStruct: getStruct,
      client: client,
    );

    return result.fold(
      (error) {
        if (kDebugMode) print(error);
        return null;
      },
      (challenges) => challenges,
    );
  },
);

final performerChallengesProvider =
    FutureProvider.family<List<Challenge>?, GetStruct>(
  (ref, getStruct) async {
    final client = await ref.watch(httpClientProvider.future);

    final result = await _ChallengeGetter.getPerformerChallenges(
      getStruct: getStruct,
      client: client,
    );

    return result.fold(
      (error) {
        if (kDebugMode) print(error);
        return null;
      },
      (challenges) => challenges,
    );
  },
);
