// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:stream_challenge/core/platform/datetime_format.dart';

class Preferences extends Equatable {
  double minimumRewardInDollars;
  String language;
  String timezone;
  bool darkMode;

  Preferences({
    required this.minimumRewardInDollars,
    required this.language,
    required this.timezone,
    required this.darkMode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'minimum_reward_in_dollars': minimumRewardInDollars,
      'language': language,
      'timezone': timezone,
      'dark_mode': darkMode,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      minimumRewardInDollars: map['minimum_reward_in_dollars'] as double,
      language: map['language'] as String,
      timezone: map['timezone'] as String,
      darkMode: map['dark_mode'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());

  factory Preferences.fromJson(String source) =>
      Preferences.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Preferences.defaultPreferences() => Preferences(
        minimumRewardInDollars: 1.0,
        language: 'EN',
        timezone: 'UTC',
        darkMode: false,
      );

  @override
  List<Object?> get props => [
        minimumRewardInDollars,
        language,
        timezone,
        darkMode,
      ];
}
