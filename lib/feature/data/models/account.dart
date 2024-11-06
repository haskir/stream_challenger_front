// ignore_for_file: non_constant_identifier_names

class Account {
  final int id;
  final double balance;
  final String currency;
  final int user_id;

  Account({
    required this.id,
    required this.balance,
    required this.currency,
    required this.user_id,
  });

  // From JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      balance: json['balance'],
      currency: json['currency'],
      user_id: json['user_id'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'currency': currency,
      'user_id': user_id,
    };
  }
}

class UserPreferences {
  final int id;
  final double minimum_reward_in_dollars;
  final String language;
  final String timezone;

  UserPreferences({
    required this.id,
    required this.minimum_reward_in_dollars,
    required this.language,
    required this.timezone,
  });

  // From JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'],
      minimum_reward_in_dollars: json['minimum_reward_in_dollars'],
      language: json['language'],
      timezone: json['timezone'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minimum_reward_in_dollars': minimum_reward_in_dollars,
      'language': language,
      'timezone': timezone,
    };
  }
}
