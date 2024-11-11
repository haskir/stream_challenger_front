import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyPickWidget extends ConsumerWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;

  const CurrencyPickWidget({
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      items: ['RUB', 'USD', 'EUR']
          .map((currency) => DropdownMenuItem(
                value: currency,
                child: Text(currency),
              ))
          .toList(),
      onChanged: null,
      decoration: const InputDecoration(
        labelText: 'Валюта',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, выберите валюту';
        }
        return null;
      },
    );
  }
}
