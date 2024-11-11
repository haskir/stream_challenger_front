import 'package:flutter/material.dart';

class DueDateField extends StatelessWidget {
  final TextEditingController controller;

  const DueDateField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Срок выполнения',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите срок выполнения';
        }
        return null;
      },
    );
  }
}
