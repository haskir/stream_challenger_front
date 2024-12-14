// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final double bet;
  final String currency;
  final bool isVisible = true;

  CreateChallengeDTO({
    required this.description,
    required this.conditions,
    required this.performerLogin,
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
      'bet': bet,
      'currency': currency,
    };
  }

  factory CreateChallengeDTO.fromMap(Map<String, dynamic> map) {
    return CreateChallengeDTO(
      description: map['description'] as String,
      conditions: List<String>.from((map['conditions'] as List<String>)),
      performerLogin: map['performer_login'] as String,
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
  final double bet;
  int? rating;
  double? payout;
  String status;
  String? reportStatus;
  final ChallengePerson author;
  final ChallengePerson performer;
  final String performerLogin;
  final DateTime createdAt;
  DateTime updatedAt;
  Report? report;
  String? predictID;
  String? pollID;

  Challenge({
    required this.id,
    required this.description,
    required this.conditions,
    required this.currency,
    required this.bet,
    required this.rating,
    required this.payout,
    required this.status,
    required this.reportStatus,
    required this.author,
    required this.performer,
    required this.performerLogin,
    required this.createdAt,
    required this.updatedAt,
    required this.report,
    required this.predictID,
    required this.pollID,
  });

  void update(Map<String, dynamic> map) {
    status = map["status"];
    predictID = map["predict_id"];
    pollID = map["poll_id"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'conditions': conditions,
      'currency': currency,
      'bet': bet,
      'rating': rating,
      'payout': payout,
      'status': status,
      'report_status': reportStatus,
      'author': author.toMap(),
      'performer': performer.toMap(),
      'performer_login': performerLogin,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'report': report?.toMap(),
      'predict_id': predictID,
      'poll_id': pollID,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'],
      description: map['description'],
      conditions: List<String>.from((map['conditions'])),
      currency: map['currency'],
      bet: map['bet'],
      rating: map['rating'] as int?,
      payout: map['payout'] as double?,
      status: map['status'],
      reportStatus: map['report_status'],
      author: ChallengePerson.fromMap(map['author']),
      performer: ChallengePerson.fromMap(map['performer']),
      performerLogin: map['performer_login'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      report: map['report'] != null ? Report.fromMap(map['report']) : null,
      predictID: map['predict_id'],
      pollID: map['poll_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Challenge.fromJson(String source) =>
      Challenge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}

class CreateReportDTO {
  final int challengeId;
  String reason;
  final String? comment;

  CreateReportDTO({
    required this.challengeId,
    required this.reason,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'challenge_id': challengeId,
      'reason': reason,
      'comment': comment,
    };
  }

  factory CreateReportDTO.fromMap(Map<String, dynamic> map) {
    return CreateReportDTO(
      challengeId: map['challenge_id'] as int,
      reason: map['reason'] as String,
      comment: map['comment'] != null ? map['comment'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateReportDTO.fromJson(String source) =>
      CreateReportDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}

class Report {
  final int id;
  final int challengeId;
  final String reason;
  final String? comment;
  final DateTime createdAt;
  String status;

  Report({
    required this.id,
    required this.challengeId,
    required this.reason,
    required this.comment,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'challenge_id': challengeId,
      'reason': reason,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      challengeId: map['challenge_id'],
      reason: map['reason'],
      comment: map['comment'] != null ? map['comment'] as String : null,
      createdAt: DateTime.parse(map['created_at']),
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => prettyJson(toMap());
}
