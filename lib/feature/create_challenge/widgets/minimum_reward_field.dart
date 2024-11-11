import 'package:flutter/material.dart';

class MinimumRewardField extends StatelessWidget {
  final TextEditingController controller;

  const MinimumRewardField({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Минимальное вознаграждение (10% - 100%)',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите минимальное вознаграждение';
        }
        if (double.tryParse(value) == null ||
            double.parse(value) < 0 ||
            double.parse(value) > 1) {
          return 'Минимальное вознаграждение должно быть от 0 до 1';
        }
        return null;
      },
    );
  }
}
