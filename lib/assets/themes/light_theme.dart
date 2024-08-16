import 'package:bgs_control/assets/colors/colors.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: accentColor,
    secondaryContainer: backgroundColor,
  ),
  useMaterial3: true,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: backgroundColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: black),
    backgroundColor: backgroundColor,
    titleTextStyle: TextStyle(
      color: black,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
  ),
  iconTheme: const IconThemeData(
    color: iconColor,
  ),
  textTheme: const TextTheme(
    /// Длинные тексты
    bodySmall: TextStyle(
      color: black,
      fontSize: 14,
    ),

    /// Под-заголовок элементе списка
    labelSmall: TextStyle(
      color: black,
    ),

    /// Заголовок элементе списка и мелком заголовке
    labelMedium: TextStyle(
      color: black,
      fontSize: 16,
    ),

    /// Заголовки экранов
    titleMedium: TextStyle(
      color: black,
      fontWeight: FontWeight.bold,
    ),

    /// Большие замещающие надписи
    headlineMedium: TextStyle(
      color: black,
    ),

    /// Очень большие надписи
    displayMedium: TextStyle(
      color: black,
    ),
  ),
);
