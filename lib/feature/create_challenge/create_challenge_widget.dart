import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/common/text_consts.dart';

import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/data/models/account.dart';
import 'package:stream_challenge/data/models/challenge.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';
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
  late Account account;
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _createChallenge() async {
    CreateChallengeDTO challenge = CreateChallengeDTO(
      description: _descriptionController.text,
      bet: double.parse(_betController.text),
      currency: account.currency.toUpperCase(),
      conditions: _controllers.map((e) => e.text).toList(),
      performerLogin: widget.performerLogin,
    );
    bool result = await _submit(
      challenge,
      await ref.watch(httpClientProvider.future),
    );
    if (result) dispose();
  }

  Future<bool> _submit(CreateChallengeDTO challenge, Requester client) async {
    Either result = await ChallengesActions.challengeCreate(
      challenge: challenge,
      client: client,
    );
    result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
      return false;
    }, (right) async {
      Fluttertoast.showToast(
          msg: AppLocale.of(context).translate(mChallengeCreated));
      return true;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final providedAccount = ref.watch(accountProvider);
    if (providedAccount == null) {
      return const Center(child: CircularProgressIndicator());
    }
    account = providedAccount;

    final minimumInCurrency =
        ref.watch(minimumInCurrencyProvider(widget.performerLogin));

    return minimumInCurrency.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text(mNoSuchUser)),
        data: (minimum) {
          if (minimum == null) {
            return const Center(child: Text(mCantCreateChallengeForThisUser));
          }
          if (account.balance < minimum) {
            return Center(
                child: Text(AppLocale.of(context).translate(
                    '${AppLocale.of(context).translate(mNotEnoughBalance)} $minimum ${account.currency}')));
          }
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
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

                  Column(children: [
                    // Поле для условий испытания
                    ConditionsSection(controllers: _controllers, max: 5),
                    // Кнопка "Создать"
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        final bool? res = await Mixins.showConfDialog(context);
                        if (res == true) {
                          await _createChallenge();
                        }
                      },
                      child: Text(
                        AppLocale.of(context).translate(mCreate),
                      ),
                    ),
                    const SizedBox(height: _margin),
                  ])
                ],
              ),
            ),
          );
        });
  }
}
