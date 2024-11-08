// ignore_for_file: non_constant_identifier_names

class ChllangeAuthor {
  final int id;
  final String name;
  final String imageUrl;

  ChllangeAuthor({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ChllangeAuthor.fromJson(Map<String, dynamic> json) {
    return ChllangeAuthor(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }
}

enum ChallengeStatus {
  pending,
  accepted,
  rejected,
  completed,
  expired,
  reported
}

class Challenge {
  final int id;
  final String description;
  List<String> conditions;
  final String currency;
  final double minimum_reward;
  final double bet;
  final ChallengeStatus status;
  final bool is_visible;
  final ChllangeAuthor author;
  final int performer_id;
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
    required this.performer_id,
    required this.created_at,
    required this.due_at,
  });

  // From JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      description: json['description'],
      currency: json['currency'],
      minimum_reward: json['minimum_reward'],
      bet: json['bet'],
      status: json['status'],
      is_visible: json['is_visible'],
      performer_id: json['performer_id'],
      conditions: List<String>.from(json['conditions']),
      author: ChllangeAuthor.fromJson(json['author']),
      created_at: DateTime.parse(json['created_at']),
      due_at: DateTime.parse(json['due_at']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'conditions': conditions,
      'currency': currency,
      'minimum_reward': minimum_reward,
      'bet': bet,
      'status': status,
      'is_visible': is_visible,
      'author_id': author.id,
      'performer_id': performer_id,
      'created_at': created_at.toIso8601String(),
      'due_at': due_at.toIso8601String(),
    };
  }
}
