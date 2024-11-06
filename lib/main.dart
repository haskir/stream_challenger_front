import 'dart:async';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Hello World',
    },
    'ru': {
      'title': 'Привет мир',
    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      DemoLocalizations.languages().contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}

class LocalisationTestWidget extends StatelessWidget {
  const LocalisationTestWidget({super.key, required this.onLocaleChange});

  final ValueChanged<String> onLocaleChange;

  List<DropdownMenuItem<String>> languages() => [
        const DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        const DropdownMenuItem(
          value: 'ru',
          child: Text('Русский'),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DemoLocalizations.of(context).title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              items: languages(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onLocaleChange(newValue);
                }
              },
              value: Localizations.localeOf(context).languageCode,
            ),
            Text(DemoLocalizations.of(context).title),
          ],
        ),
      ),
    );
  }
}

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
          home: LocalisationTestWidget(
            onLocaleChange: _changeLocale,
          ),
        );
      },
    );
  }
}

void main() {
  runApp(const StreamChallengeApp());
}
