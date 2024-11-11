import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/providers.dart';
import 'widgets/view.dart';

class CreateChallengeWidget extends ConsumerStatefulWidget {
  const CreateChallengeWidget({super.key});

  @override
  ConsumerState<CreateChallengeWidget> createState() =>
      _CreateChallengeWidgetState();
}

class _CreateChallengeWidgetState extends ConsumerState<CreateChallengeWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _minimumRewardController = TextEditingController();
  final _betController = TextEditingController();
  final _dueAtController = TextEditingController();
  String _selectedCurrency = 'RUB';

  @override
  void dispose() {
    _descriptionController.dispose();
    _minimumRewardController.dispose();
    _betController.dispose();
    _dueAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле для описания
            DescriptionField(controller: _descriptionController),
            const SizedBox(height: 16),

            // Поле для минимального вознаграждения в процентах
            MinimumRewardField(controller: _minimumRewardController),
            const SizedBox(height: 16),

            // Поле для ставки
            BetField(controller: _betController),
            const SizedBox(height: 16),

            // Выпадающий список для выбора валюты
            CurrencyPickWidget(
              selectedCurrency: _selectedCurrency,
              onCurrencyChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Поле для срока выполнения
            DueDateField(controller: _dueAtController),
            const SizedBox(height: 16),

            // Поле для условий испытания
            ConditionsSection(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Send data to server here
                  // ...
                }
              },
              child: const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}
