import 'package:flutter/material.dart';

class AppColors {
  // Брендовые
  static const primary = Color(0xFF2196F3);
  static const primaryLight = Color(0xFF64B5F6);
  static const primaryDark = Color(0xFF1976D2);

  // Нейтральные
  static const backgroundLight = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFF121212);

  // Текст
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF757575);

  // Ошибки / успех
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
}

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.success,
    error: AppColors.error,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark, // Указывает на темную тему
  primaryColor: Colors.grey[800], // Основной цвет, немного темнее серого
  scaffoldBackgroundColor: Colors.grey[900], // Цвет фона экрана
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900], // Цвет фона AppBar
    titleTextStyle: TextStyle(color: Colors.white), // Цвет текста в AppBar
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey[300]), // Цвет заголовков
    bodyMedium: TextStyle(color: Colors.grey[300]), // Цвет второго текста
    bodySmall: TextStyle(color: Colors.grey[300]), // Цвет основного текста
  ),
  cardColor: Colors.black12,
  cardTheme: CardThemeData(color: Colors.black12), // Цвет карточек
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[400], // Цвет нижней навигационной панели
    selectedItemColor: Colors.white, // Цвет выбранного элемента навигации
    unselectedItemColor: Colors.grey[500], // Цвет невыбранного элемента навигации
  ),
  iconTheme: IconThemeData(color: Colors.white), // Цвет иконок
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.black12),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey, // Цвет кнопок
      textTheme: ButtonTextTheme.primary), // Текст на кнопках
);
