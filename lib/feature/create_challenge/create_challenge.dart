import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/auth_state.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/streamer_panel/challenges_actions.dart';
import 'package:stream_challenge/providers/providers.dart';
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
    late final AuthToken? user = ref.watch(authStateProvider).user;
    if (user == null) {
      return const Center(child: Text('login required'));
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

            // Поле для минимального вознаграждения в процентах
            MinimumRewardField(controller: _minimumRewardController),
            const SizedBox(height: _margin),

            // Поле для ставки
            BetField(
                controller: _betController,
                minimumBet: 100,
                //maximumBet: user.account.balance),
                maximumBet: 10000),
            const SizedBox(height: _margin),

            // Выпадающий список для выбора валюты
            CurrencyPickWidget(user: user),
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
                    minimum_reward:
                        double.parse(_minimumRewardController.text) / 100,
                    bet: double.parse(_betController.text),
                    // currency: user.account.currency,
                    currency: "RUB",
                    due_at: DateFormat('dd.MM.yyyy HH:mm')
                        .parse(_dueAtController.text),
                    conditions: _controllers.map((e) => e.text).toList(),
                    performer_id: user.id,
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
