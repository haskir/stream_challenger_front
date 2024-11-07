// ignore_for_file: non_constant_identifier_names

class Challenge {
  final int id;
  final String description;
  List<String> conditions;
  final String currency;
  final double minimum_reward;
  final double bet;
  final String status;
  final bool is_visible;
  final int author_id;
  final int performer_id;
  final DateTime created_at;

  Challenge({
    required this.id,
    required this.description,
    required this.conditions,
    required this.currency,
    required this.minimum_reward,
    required this.bet,
    required this.status,
    required this.is_visible,
    required this.author_id,
    required this.performer_id,
    required this.created_at,
  });

  // From JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      description: json['description'],
      conditions: List<String>.from(json['conditions']),
      currency: json['currency'],
      minimum_reward: json['minimum_reward'],
      bet: json['bet'],
      status: json['status'],
      is_visible: json['is_visible'],
      author_id: json['author_id'],
      performer_id: json['performer_id'],
      created_at: DateTime.parse(json['created_at']),
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
      'author_id': author_id,
      'performer_id': performer_id,
      'created_at': created_at.toIso8601String(),
    };
  }
}
