// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class ConfirmationDialogExample extends StatelessWidget {
  const ConfirmationDialogExample({super.key});

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтверждение'),
          content: Text('Вы уверены, что хотите продолжить?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Отменить
              },
              child: Text('Нет'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Подтвердить
              },
              child: Text('Да'),
            ),
          ],
        );
      },
    );
  }

  void _onButtonPressed(BuildContext context) async {
    final bool? confirmed = await showConfirmationDialog(context);
    if (confirmed == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь подтвердил действие')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь отменил действие')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Пример диалога подтверждения')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(context),
          child: Text('Показать диалог'),
        ),
      ),
    );
  }
}
