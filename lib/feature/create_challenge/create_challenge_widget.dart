import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_challenge/common/mixins.dart';
import 'package:stream_challenge/common/strings/export.dart';

import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/core/platform/dio.dart';
import 'package:stream_challenge/main_widgets/body_widgets/blur_widget.dart';
import 'package:stream_challenge/models/account.dart';
import 'package:stream_challenge/models/challenge.dart';
import 'package:stream_challenge/models/steamer_info.dart';
import 'package:stream_challenge/use_cases/challenges_actions.dart';
import 'package:stream_challenge/providers/account_provider.dart';
import 'package:stream_challenge/providers/preferences_provider.dart';
import 'package:stream_challenge/providers/providers.dart';
import 'widgets/is_online_status_widget.dart';
import 'widgets/view.dart';

class CreateChallengeWidget extends ConsumerStatefulWidget {
  final String performerLogin;

  const CreateChallengeWidget({
    super.key,
    required this.performerLogin,
  });

  @override
  ConsumerState<CreateChallengeWidget> createState() => _CreateChallengeWidgetState();
}

class _CreateChallengeWidgetState extends ConsumerState<CreateChallengeWidget> {
  bool isLoading = false;
  Account? account;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _betController;
  final List<TextEditingController> _controllers = [];
  static const double _margin = 10.0;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _betController = TextEditingController();
  }

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
          double minimum = streamerInfo.minimumRewardInDollars * streamerInfo.currencyRates[account!.currency]!;
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
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          // Информация о стримере
                          Center(child: streamerInfoWidget(streamerInfo)),
                          // Поле для описания
                          DescriptionField(controller: _descriptionController),
                          const SizedBox(height: _margin),

                          // Поле для ставки и валюты
                          SliderWidget(
                            controller: _betController,
                            minimum: minimum,
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
                    if (isLoading) BlurAndBlock(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Widget streamerInfoWidget(StreamerInfo streamerInfo) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(streamerInfo.urlImage),
          ),
          const SizedBox(width: 5),
          Text(streamerInfo.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          IsOnlineStatusWidget(login: streamerInfo.login),
        ],
      );

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
    _betController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
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
    setState(() => isLoading = true);
    bool res = await _createChallenge(
      challenge,
      await ref.watch(httpClientProvider.future),
    );
    setState(() => isLoading = false);
    if (res) await ref.read(accountProvider.notifier).refresh();
  }

  Future<bool> _createChallenge(CreateChallengeDTO challenge, Requester client) async {
    Either result = await ChallengesActions.challengeCreate(
      challenge: challenge,
      client: client,
    );
    return result.fold((left) {
      Fluttertoast.showToast(msg: result.toString());
      return false;
    }, (right) async {
      Fluttertoast.showToast(msg: AppLocale.of(context).translate(mChallengeCreated));
      return true;
    });
  }
}
