// ignore_for_file: non_constant_identifier_names

class Account {
  late final double balance;
  late final String currency;

  Account({
    required this.balance,
    required this.currency,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      balance: json['balance'] as double,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'balance': balance,
      'currency': currency,
    };
  }

  @override
  String toString() {
    return 'Account{balance: $balance, currency: $currency}';
  }
}

class Preferences {
  late final double minimum_reward_in_dollars;
  late final String language;
  late final String timezone;

  Preferences({
    required this.minimum_reward_in_dollars,
    required this.language,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'minimum_reward_in_dollars': minimum_reward_in_dollars,
      'language': language,
      'timezone': timezone,
    };
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      minimum_reward_in_dollars: json['minimum_reward_in_dollars'] as double,
      language: json['language'] as String,
      timezone: json['timezone'] as String,
    );
  }

  @override
  String toString() {
    return 'Preferences{minimum_reward_in_dollars: $minimum_reward_in_dollars, language: $language, timezone: $timezone}';
  }
}
