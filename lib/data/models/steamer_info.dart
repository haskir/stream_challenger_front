import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StreamerInfo {
  final String name;
  final String urlImage;
  final double minimumReward;
  final String currency;
  final String? game;
  final int? viewers;
  final String? language;
  final bool? isOnline;
  final bool? isOnChallenge;
  StreamerInfo({
    required this.name,
    required this.urlImage,
    required this.minimumReward,
    required this.currency,
    this.game,
    this.viewers,
    this.language,
    this.isOnline,
    this.isOnChallenge,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'urlImage': urlImage,
      'minimumReward': minimumReward,
      'currency': currency,
      'game': game,
      'viewers': viewers,
      'language': language,
      'isOnline': isOnline,
      'isOnChallenge': isOnChallenge,
    };
  }

  factory StreamerInfo.fromMap(Map<String, dynamic> map) {
    return StreamerInfo(
      name: map['name'] as String,
      urlImage: map['urlImage'] as String,
      minimumReward: map['minimumReward'] as double,
      currency: map['currency'] as String,
      game: map['game'] != null ? map['game'] as String : null,
      viewers: map['viewers'] != null ? map['viewers'] as int : null,
      language: map['language'] != null ? map['language'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      isOnChallenge:
          map['isOnChallenge'] != null ? map['isOnChallenge'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamerInfo.fromJson(String source) =>
      StreamerInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}
