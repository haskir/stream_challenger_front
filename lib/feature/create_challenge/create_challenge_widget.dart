import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
  Account? account;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _minimumRewardController;
  late TextEditingController _betController;
  final List<TextEditingController> _controllers = [];
  static const double _margin = 10.0;

  @override
  Widget build(BuildContext context) {
    account = ref.watch(accountProvider);
    if (account == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final streamerInfoFuture = ref.watch(streamerInfoProvider(
      widget.performerLogin,
    ));

    return streamerInfoFuture.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          if (kDebugMode) return Center(child: Text(error.toString()));
          return const Center(child: Text(mNoSuchUser));
        },
        data: (streamerInfo) {
          if (streamerInfo == null) {
            return const Center(child: Text(mCantCreateChallengeForThisUser));
          }
          double minimum = streamerInfo.minimumRewardInDollars *
              streamerInfo.currencyRates[account!.currency]!;
          _descriptionController = TextEditingController();
          _minimumRewardController = TextEditingController();
          _betController = TextEditingController();
          if (account!.balance < minimum) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocale.of(context).translate(mNotEnoughBalance)),
                Text(': $minimum ${account!.currency} '),
                Text(AppLocale.of(context).translate(mIsMunimum)),
              ],
            );
          }
          return Container(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Информация о стримере
                      Center(child: Mixins.streamerInfo(streamerInfo, context)),
                      // Поле для описания
                      DescriptionField(controller: _descriptionController),
                      const SizedBox(height: _margin),

                      // Поле для ставки и валюты
                      BetSlider(
                        controller: _betController,
                        minBet: minimum,
                        maximum: account!.balance,
                        currency: account!.currency,
                      ),
                      const SizedBox(height: _margin),

                      Column(children: [
                        // Поле для условий испытания
                        ConditionsSection(controllers: _controllers, max: 5),
                        // Кнопка "Создать"
                        ElevatedButton(
                          onPressed: () async => await _submit(),
                          child: Text(
                            AppLocale.of(context).translate(mCreate),
                          ),
                        ),
                        const SizedBox(height: _margin),
                        infoAcception(context),
                      ])
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Widget infoAcception(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of(context).translate(mInfoAcception),
          style: TextStyle(fontSize: 10.0, color: Colors.grey),
        ),
        TextButton(
          child: Text(
            AppLocale.of(context).translate(mTerms),
            style: TextStyle(fontSize: 10.0),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (await Mixins.showConfDialog(context) != true) return;

    CreateChallengeDTO challenge = CreateChallengeDTO(
      description: _descriptionController.text,
      bet: double.parse(_betController.text),
      currency: account!.currency.toUpperCase(),
      conditions: _controllers.map((e) => e.text).toList(),
      performerLogin: widget.performerLogin,
    );
    bool res = await _createChallenge(
      challenge,
      await ref.watch(httpClientProvider.future),
    );
    if (res) await ref.read(accountProvider.notifier).refresh();
  }

  Future<bool> _createChallenge(
      CreateChallengeDTO challenge, Requester client) async {
    Either result = await ChallengesActions.challengeCreate(
      challenge: challenge,
      client: client,
    );
    return result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
      return false;
    }, (right) async {
      Fluttertoast.showToast(
          msg: AppLocale.of(context).translate(mChallengeCreated));
      return true;
    });
  }
}
