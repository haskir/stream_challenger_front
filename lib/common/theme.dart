import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.lightBlue,
  primaryColor: Colors.lightBlue,
  primaryColorLight: Colors.blue[200],
  primaryColorDark: Colors.lightBlue,
  dialogBackgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.black),
    ),
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
  cardTheme: CardTheme(color: Colors.black12), // Цвет карточек
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[400], // Цвет нижней навигационной панели
    selectedItemColor: Colors.white, // Цвет выбранного элемента навигации
    unselectedItemColor:
        Colors.grey[500], // Цвет невыбранного элемента навигации
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
