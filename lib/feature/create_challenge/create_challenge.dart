import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/data/models/currency.dart';
import 'package:stream_challenge/feature/streamer_panel/challenges_actions.dart';
import 'package:stream_challenge/providers/account_provider.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';
import 'package:stream_challenge/providers/providers.dart';

import 'create_challenge_use_case.dart';
import 'widgets/view.dart';

class CreateChallengeWidget extends ConsumerStatefulWidget {
  final String performerLogin;

  const CreateChallengeWidget({
    super.key,
    required this.performerLogin,
  });

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
  final List<TextEditingController> _controllers = [];
  static const double _margin = 10.0;

  @override
  void dispose() {
    _descriptionController.dispose();
    _minimumRewardController.dispose();
    _betController.dispose();
    _dueAtController.dispose();
    super.dispose();
  }

  Future<String> _submit(CreateChallengeDTO challenge, Requester client) async {
    return await ChallengesActions().challengeCreate(
      challenge: challenge,
      client: client,
    );
  }

  @override
  Widget build(BuildContext context) {
    final performerPref =
        ref.watch(performerPreferencesProvider(widget.performerLogin));
    final account = ref.watch(accountProvider);

    if (account == null || performerPref.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final performerPreferences = performerPref.asData?.value;
    print('performerPreferences: $performerPreferences');
    if (performerPreferences == null) {
      return const Center(child: Text("No such performer"));
    }
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле для описания
            DescriptionField(controller: _descriptionController),
            const SizedBox(height: _margin),

            // Поле для ставки и валюты
            BetSlider(
              controller: _betController,
              minBet: performerPreferences.minimum_reward_in_dollars,
              balance: account.balance,
              currency: account.currency,
            ),
            const SizedBox(height: _margin),

            // Поле для срока выполнения
            DueDateTimeField(controller: _dueAtController),
            const SizedBox(height: _margin),

            // Поле для условий испытания
            ConditionsSection(controllers: _controllers, max: 3),
            const SizedBox(height: _margin),

            // Кнопка "Создать"
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  CreateChallengeDTO challenge = CreateChallengeDTO(
                    description: _descriptionController.text,
                    minimum_reward: 0.1,
                    bet: double.parse(_betController.text),
                    currency: "RUB",
                    due_at: DateFormat('dd.MM.yyyy HH:mm')
                        .parse(_dueAtController.text),
                    conditions: _controllers.map((e) => e.text).toList(),
                    performerLogin: widget.performerLogin,
                  );
                  final result = await _submit(
                      challenge, await ref.watch(httpClientProvider.future));
                  Fluttertoast.showToast(msg: result);
                }
              },
              child: Text(AppLocalizations.of(context).translate('Create')),
            ),
          ],
        ),
      ),
    );
  }
}
