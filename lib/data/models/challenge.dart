// ignore_for_file: non_constant_identifier_names

class ChallengeAuthor {
  final String name;
  final String urlImage;

  ChallengeAuthor({
    required this.name,
    required this.urlImage,
  });

  factory ChallengeAuthor.fromJson(Map<String, dynamic> json) {
    return ChallengeAuthor(
      name: json['name'],
      urlImage: json['urlImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url': urlImage,
    };
  }
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
      conditions: List<String>.from(json['conditions']),
      currency: json['currency'],
      minimum_reward: json['minimum_reward'],
      bet: json['bet'],
      status: json['status'],
      is_visible: json['is_visible'],
      performer_id: json['performer_id'],
      author: ChallengeAuthor.fromJson(json['author']),
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
      'performer_id': performer_id,
      'created_at': created_at.toIso8601String(),
      'due_at': due_at.toIso8601String(),
    };
  }

  factory Challenge.testPending() {
    return Challenge.fromJson({
      "id": 1,
      "description":
          "Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?Эй, тебе не свабо?",
      "conditions": ["Гойдануть", "Побриться налысо"],
      "currency": "RUB",
      "minimum_reward": 10.0,
      "bet": 300.0,
      "status": "PENDING",
      "is_visible": true,
      "performer_id": 76288410,
      "author": {
        "name": "LapkiNaStol",
        "urlImage":
            "https://static-cdn.jtvnw.net/jtv_user_pictures/3692e68b-45b8-4ded-81ac-65af55627721-profile_image-300x300.png"
      },
      "created_at": "2024-11-08 18:37:05",
      "due_at": "2024-11-29 12:00:00",
    });
  }
  factory Challenge.testAccepted() {
    return Challenge.fromJson({
      "id": 1,
      "description": "Эй, тебе не свабо?",
      "conditions": ["Гойдануть", "Побриться налысо"],
      "currency": "RUB",
      "minimum_reward": 10.0,
      "bet": 300.0,
      "status": "ACCEPTED",
      "is_visible": true,
      "performer_id": 76288410,
      "author": {
        "name": "LapkiNaStol",
        "urlImage":
            "https://static-cdn.jtvnw.net/jtv_user_pictures/3692e68b-45b8-4ded-81ac-65af55627721-profile_image-300x300.png"
      },
      "created_at": "2024-11-08 18:37:05",
      "due_at": "2024-11-29 12:00:00",
    });
  }
  factory Challenge.testRejected() {
    return Challenge.fromJson({
      "id": 1,
      "description": "Эй, тебе не свабо?",
      "conditions": ["Гойдануть", "Побриться налысо"],
      "currency": "RUB",
      "minimum_reward": 10.0,
      "bet": 300.0,
      "status": "REJECTED",
      "is_visible": true,
      "performer_id": 76288410,
      "author": {
        "name": "LapkiNaStol",
        "urlImage":
            "https://static-cdn.jtvnw.net/jtv_user_pictures/3692e68b-45b8-4ded-81ac-65af55627721-profile_image-300x300.png"
      },
      "created_at": "2024-11-08 18:37:05",
      "due_at": "2024-11-29 12:00:00",
    });
  }

  factory Challenge.testReported() {
    return Challenge.fromJson({
      "id": 1,
      "description": "Эй, тебе не свабо?",
      "conditions": ["Гойдануть", "Побриться налысо"],
      "currency": "RUB",
      "minimum_reward": 10.0,
      "bet": 300.0,
      "status": "REPORTED",
      "is_visible": false,
      "performer_id": 76288410,
      "author": {
        "name": "LapkiNaStol",
        "urlImage":
            "https://static-cdn.jtvnw.net/jtv_user_pictures/3692e68b-45b8-4ded-81ac-65af55627721-profile_image-300x300.png"
      },
      "created_at": "2024-11-08 18:37:05",
      "due_at": "2024-11-29 12:00:00",
    });
  }
}
