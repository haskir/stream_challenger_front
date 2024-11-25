import 'package:stream_challenge/data/models/currency.dart';

double calcMinimumReward(
  double minInUSd,
  String authCurrency,
) {
  return CurrencyConverter().convert(authCurrency, "USD", minInUSd);
}

double calcMinimumRewardPercentage(
  double minInUSd,
  double balance,
  String authCurrency,
) {
  return calcMinimumReward(minInUSd, authCurrency) / balance * 100;
}
