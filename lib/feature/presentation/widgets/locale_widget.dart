import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

class LocaleWidget extends StatelessWidget {
  const LocaleWidget({super.key, required this.onLocaleChange});

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
    return DropdownButton<String>(
      items: languages(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onLocaleChange(newValue);
        }
      },
      value: Localizations.localeOf(context).languageCode,
    );
  }
}
