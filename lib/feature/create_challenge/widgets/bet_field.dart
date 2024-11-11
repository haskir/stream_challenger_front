import 'package:flutter/material.dart';

class BetField extends StatelessWidget {
  final TextEditingController controller;

  const BetField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Ставка',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите ставку';
        }
        if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ставка должна быть больше 0';
        }
        return null;
      },
    );
  }
}
