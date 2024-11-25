// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class ChallengeAuthor {
  final String name;
  final String urlImage;

  ChallengeAuthor({
    required this.name,
    required this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'urlImage': urlImage,
    };
  }

  factory ChallengeAuthor.fromMap(Map<String, dynamic> map) {
    return ChallengeAuthor(
      name: map['name'] as String,
      urlImage: map['urlImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengeAuthor.fromJson(String source) =>
      ChallengeAuthor.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Challenge {
  final int id;
  final String description;
  final List<String> conditions;
  final String currency;
  final double minimum_reward;
  final double bet;
  final String status;
  final bool is_visible;
  final ChallengeAuthor author;
  final String performerLogin;
  final DateTime created_at;
  final DateTime due_at;

  Challenge({
    required this.id,
    required this.description,
    required this.conditions,
    required this.currency,
    required this.minimum_reward,
    required this.bet,
    required this.status,
    required this.is_visible,
    required this.author,
    required this.performerLogin,
    required this.created_at,
    required this.due_at,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'conditions': conditions,
      'currency': currency,
      'minimum_reward': minimum_reward,
      'bet': bet,
      'status': status,
      'is_visible': is_visible,
      'author': author.toMap(),
      'performerLogin': performerLogin,
      'created_at': created_at.millisecondsSinceEpoch,
      'due_at': due_at.millisecondsSinceEpoch,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    final c = Challenge(
      id: map['id'] as int,
      description: map['description'] as String,
      conditions: List<String>.from((map['conditions'])),
      currency: map['currency'] as String,
      minimum_reward: map['minimum_reward'] as double,
      bet: map['bet'] as double,
      status: map['status'] as String,
      is_visible: map['is_visible'] as bool,
      author: ChallengeAuthor.fromMap(map['author']),
      performerLogin: map['performer_id'],
      created_at: dateTimeFormat.parse(map['created_at'] as String),
      due_at: dateTimeFormat.parse(map['created_at'] as String),
    );
    return c;
  }

  String toJson() => json.encode(toMap());

  factory Challenge.fromJson(String source) =>
      Challenge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}

class CreateChallengeDTO {
  final String description;
  final List<String> conditions;
  final String performerLogin;
  final double minimum_reward;
  final double bet;
  final String currency;
  final DateTime due_at;
  final bool is_visible = true;

  CreateChallengeDTO({
    required this.description,
    required this.conditions,
    required this.performerLogin,
    required this.minimum_reward,
    required this.bet,
    required this.currency,
    required this.due_at,
  });

  @override
  String toString() => prettyJson(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'conditions': conditions,
      'performerLogin': performerLogin,
      'minimum_reward': minimum_reward,
      'bet': bet,
      'currency': currency,
      'due_at': due_at.millisecondsSinceEpoch,
    };
  }

  factory CreateChallengeDTO.fromMap(Map<String, dynamic> map) {
    return CreateChallengeDTO(
      description: map['description'] as String,
      conditions: List<String>.from((map['conditions'] as List<String>)),
      performerLogin: map['performerLogin'] as String,
      minimum_reward: map['minimum_reward'] as double,
      bet: map['bet'] as double,
      currency: map['currency'] as String,
      due_at: DateTime.fromMillisecondsSinceEpoch(map['due_at'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateChallengeDTO.fromJson(String source) =>
      CreateChallengeDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
