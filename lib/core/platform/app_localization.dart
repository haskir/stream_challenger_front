import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocale {
  AppLocale(this.locale);

  final Locale locale;
  late Map<String, String> _localizedStrings;

  // Метод для доступа к локализации
  static AppLocale of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale)!;
  }

  // Загрузка JSON-файла с переводами
  Future<void> load() async {
    String jsonString = await rootBundle
        .loadString('assets/locales/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  // Получение перевода по ключу
  String translate(String key) => _localizedStrings[key] ?? key;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocale> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocale> load(Locale locale) async {
    AppLocale localizations = AppLocale(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
