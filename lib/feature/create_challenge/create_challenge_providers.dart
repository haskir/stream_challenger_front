import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCurrencyProvider =
    StateNotifierProvider<CurrencyNotifier, String>(
  (ref) => CurrencyNotifier(),
);

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('USD');

  void updateCurrency(String newCurrency) {
    state = newCurrency;
  }
}
