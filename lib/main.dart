import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stream_challenge/common/app_theme.dart';
import 'package:stream_challenge/feature/presentation/widgets/locale_widget.dart';
import 'package:stream_challenge/feature/presentation/widgets/top_bar.dart';

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
          theme: mainTheme(),
          locale: snapshot.data,
          onGenerateTitle: (context) => DemoLocalizations.of(context).title,
          localizationsDelegates: const [
            DemoLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          home: TopBarWidget(onLocaleChange: _changeLocale),
        );
      },
    );
  }
}

void main() {
  runApp(const StreamChallengeApp());
}
