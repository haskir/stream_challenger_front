import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stream_challenge/core/platform/app_localization.dart';
import 'package:stream_challenge/feature/presentation/widgets/scaffold.dart';

class StreamChallengeApp extends StatefulWidget {
  const StreamChallengeApp({super.key});
  @override
  State<StreamChallengeApp> createState() => _StreamChallengeAppState();
}

class _StreamChallengeAppState extends State<StreamChallengeApp> {
  final StreamController<Locale> _localeStreamController =
      StreamController<Locale>();

  @override
  void dispose() {
    _localeStreamController.close();
    super.dispose();
  }

  void _changeLocale(String languageCode) {
    _localeStreamController.add(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: _localeStreamController.stream,
      initialData: const Locale('en'),
      builder: (context, snapshot) {
        return MaterialApp(
          locale: snapshot.data,
          onGenerateTitle: (context) =>
              AppLocalizations.of(context).translate('title'),
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
          ],
          home: MainWidget(
            onLocaleChange: _changeLocale,
          ),
        );
      },
    );
  }
}

void main() => runApp(const StreamChallengeApp());
