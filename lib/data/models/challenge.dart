import 'dart:convert';
import 'package:stream_challenge/core/platform/datetime_format.dart';

class ChallengePerson {
  final String name;
  final String urlImage;

  ChallengePerson({
    required this.name,
    required this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url_image': urlImage,
    };
  }

  factory ChallengePerson.fromMap(Map<String, dynamic> map) {
    return ChallengePerson(
      name: map['name'] as String,
      urlImage: map['url_image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengePerson.fromJson(String source) =>
      ChallengePerson.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CreateChallengeDTO {
  final String description;
  final List<String> conditions;
  final String performerLogin;
  final double minimumReward;
  final double bet;
  final String currency;
  final bool isVisible = true;

  CreateChallengeDTO({
    required this.description,
    required this.conditions,
    required this.performerLogin,
    required this.minimumReward,
    required this.bet,
    required this.currency,
  });

  @override
  String toString() => prettyJson(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'conditions': conditions,
      'performer_login': performerLogin,
      'minimum_reward': minimumReward,
      'bet': bet,
      'currency': currency,
    };
  }

  factory CreateChallengeDTO.fromMap(Map<String, dynamic> map) {
    return CreateChallengeDTO(
      description: map['description'] as String,
      conditions: List<String>.from((map['conditions'] as List<String>)),
      performerLogin: map['performer_login'] as String,
      minimumReward: map['minimum_reward'] as double,
      bet: map['bet'] as double,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateChallengeDTO.fromJson(String source) =>
      CreateChallengeDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Challenge {
  final int id;
  final String description;
  final List<String> conditions;
  final String currency;
  final double minimumReward;
  final double bet;
  String status;
  double? payout;
  final bool isVisible;
  final ChallengePerson author;
  final ChallengePerson performer;
  final String performerLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  Challenge({
    required this.id,
    required this.description,
    required this.conditions,
    required this.currency,
    required this.minimumReward,
    required this.bet,
    required this.status,
    required this.isVisible,
    required this.payout,
    required this.author,
    required this.performer,
    required this.performerLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'conditions': conditions,
      'currency': currency,
      'minimum_reward': minimumReward,
      'bet': bet,
      'status': status,
      'is_visible': isVisible,
      'payout': payout,
      'author': author.toMap(),
      'performer': performer.toMap(),
      'performer_login': performerLogin,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'],
      description: map['description'],
      conditions: List<String>.from((map['conditions'])),
      currency: map['currency'],
      minimumReward: map['minimum_reward'],
      bet: map['bet'],
      status: map['status'],
      isVisible: map['is_visible'],
      payout: map['payout'],
      author: ChallengePerson.fromMap(map['author']),
      performer: ChallengePerson.fromMap(map['performer']),
      performerLogin: map['performer_login'],
      createdAt: dateTimeFormat.parse(map['created_at']),
      updatedAt: dateTimeFormat.parse(map['updated_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Challenge.fromJson(String source) =>
      Challenge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}
