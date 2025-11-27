import 'dart:convert';
import 'package:stream_challenge/core/platform/datetime_format.dart';

class Preferences {
  int userId;
  double? minimumRewardInDollars;
  String language;
  String timezone;
  bool? darkMode;

  Preferences({
    required this.userId,
    required this.minimumRewardInDollars,
    required this.language,
    required this.timezone,
    required this.darkMode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'minimum_reward_in_dollars': minimumRewardInDollars,
      'language': language,
      'timezone': timezone,
      'dark_mode': darkMode,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      userId: map['user_id'] as int,
      minimumRewardInDollars:
          map['minimum_reward_in_dollars'] != null ? map['minimum_reward_in_dollars'] as double : null,
      language: map['language'] as String,
      timezone: map['timezone'] as String,
      darkMode: map['dark_mode'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());

  factory Preferences.fromJson(String source) => Preferences.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Preferences.defaultPreferences() => Preferences(
        userId: 0,
        minimumRewardInDollars: 1.0,
        language: 'EN',
        timezone: 'UTC',
        darkMode: null,
      );

  static const double epsilon = 1e-9; // Допустимая погрешность
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! Preferences) return false;
    return other.language == language && other.timezone == timezone && other.darkMode == darkMode;
  }

  @override
  int get hashCode {
    return minimumRewardInDollars.hashCode ^ language.hashCode ^ darkMode.hashCode ^ timezone.hashCode;
  }
}
