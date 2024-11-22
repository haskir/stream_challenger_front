class CurrencyConverter {
  late Map<String, double> _currencyRates;

  CurrencyConverter() {
    _currencyRates = {
      'EUR': 0.919,
      'KZT': 487.765,
      'RUB': 97.349,
      'UAH': 41.186,
      'USD': 1.0
    };
  }

  double convert(String fromCurrency, String toCurrency, double amount) {
    double fromRate = _currencyRates[fromCurrency] ?? 1.0;
    double toRate = _currencyRates[toCurrency] ?? 1.0;
    return amount * fromRate / toRate;
  }

  get currencyRates => _currencyRates;

  static List<String> getCurrencyList() {
    return ['EUR', 'KZT', 'RUB', 'UAH', 'USD'];
  }
}
