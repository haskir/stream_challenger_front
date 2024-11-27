import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/core/platform/response.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/feature/streamer_panel/challenges_actions.dart';
import 'package:stream_challenge/providers/account_provider.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
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
  final List<TextEditingController> _controllers = [];
  static const double _margin = 10.0;

  @override
  void dispose() {
    _descriptionController.dispose();
    _minimumRewardController.dispose();
    _betController.dispose();
    super.dispose();
  }

  void _submit(CreateChallengeDTO challenge, Requester client) async {
    dynamic result = await ChallengesActions().challengeCreate(
      challenge: challenge,
      client: client,
    );
    if (result.runtimeType == Challenge) {
      Fluttertoast.showToast(
        msg: "Challenge created",
      );
      ref.read(accountProvider.notifier).refresh();
    }
    if (result.runtimeType == ErrorDTO) {
      Fluttertoast.showToast(
        msg: result.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    if (account == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final minimumInCurrency =
        ref.watch(minimumInCurrencyProvider(widget.performerLogin));

    return minimumInCurrency.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text("No such user")),
        data: (minimum) {
          if (minimum == null) return const Center(child: Text("No such user"));
          if (account.balance < minimum) {
            return Center(
                child: Text(AppLocalizations.of(context).translate(
                    'Not enough balance, minimum is $minimum ${account.currency}')));
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
                    minBet: minimum,
                    balance: account.balance,
                    currency: account.currency,
                  ),
                  const SizedBox(height: _margin),

                  // Поле для условий испытания
                  ConditionsSection(controllers: _controllers, max: 5),
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
                          conditions: _controllers.map((e) => e.text).toList(),
                          performerLogin: widget.performerLogin,
                        );
                        _submit(
                          challenge,
                          await ref.watch(httpClientProvider.future),
                        );
                      }
                    },
                    child:
                        Text(AppLocalizations.of(context).translate('Create')),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
