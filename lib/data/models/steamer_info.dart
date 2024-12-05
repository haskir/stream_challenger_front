import 'dart:convert';

import 'package:stream_challenge/core/platform/datetime_format.dart';

class StreamerInfo {
  final String login;
  final String displayName;
  final String urlImage;
  final double minimumRewardInDollars;
  final String currency;
  final bool isOnline;
  final bool isOnChallenge;
  final Map<String, double> currencyRates;

  const StreamerInfo({
    required this.login,
    required this.displayName,
    required this.urlImage,
    required this.minimumRewardInDollars,
    required this.currency,
    required this.isOnline,
    required this.isOnChallenge,
    required this.currencyRates,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'login': login,
      'display_name': displayName,
      'url_image': urlImage,
      'minimum_reward_in_dollars': minimumRewardInDollars,
      'currency': currency,
      'is_online': isOnline,
      'is_on_challenge': isOnChallenge,
    };
  }

  factory StreamerInfo.fromMap(Map<String, dynamic> map) {
    return StreamerInfo(
      login: map['login'],
      displayName: map['display_name'],
      urlImage: map['url_image'],
      minimumRewardInDollars: map['minimum_reward_in_dollars'],
      currency: map['currency'],
      isOnline: map['is_online'],
      isOnChallenge: map['is_on_challenge'],
      currencyRates: Map.from(map['currency_rates']),
    );
  }

  factory StreamerInfo.fromJson(String source) =>
      StreamerInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  @override
  String toString() => prettyJson(toMap());
}
