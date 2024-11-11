import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinimumRewardField extends StatelessWidget {
  final TextEditingController controller;

  const MinimumRewardField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 3,
      decoration: const InputDecoration(
        labelText: 'Минимальное вознаграждение (10% - 100%)',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите минимальное вознаграждение';
        }
        if (double.tryParse(value) == null ||
            double.parse(value) < 0 ||
            double.parse(value) > 100) {
          return 'Минимальное вознаграждение должно быть от 0 до 100 %';
        }
        return null;
      },
    );
  }
}
