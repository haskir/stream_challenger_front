class StreamerInfo {
  final String name;
  final String urlImage;
  final double minimumReward;
  final String currency;
  final String? game;
  final int? viewers;
  final String? language;
  final bool? isOnline;
  final bool? isOnChallenge;

  StreamerInfo({
    required this.name,
    required this.urlImage,
    required this.minimumReward,
    required this.currency,
    this.game,
    this.viewers,
    this.language,
    this.isOnline,
    this.isOnChallenge,
  });

  factory StreamerInfo.fromJson(Map<String, dynamic> json) {
    return StreamerInfo(
      name: json['name'],
      urlImage: json['urlImage'],
      minimumReward: json['minimumReward'],
      currency: json['currency'],
      game: json['game'],
      viewers: json['viewers'],
      language: json['language'],
      isOnline: json['isOnline'],
      isOnChallenge: json['isOnChallenge'],
    );
  }
}
