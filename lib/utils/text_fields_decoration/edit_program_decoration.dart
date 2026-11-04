

import 'package:flutter/material.dart';

import '../../assets/colors/colors.dart';

InputDecoration editProgramDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    // СТИЛЬ ПОДСКАЗКИ: Светло-серый текст
    hintStyle: const TextStyle(color: filledAccentButtonColor),

    // ФОН ПОЛЯ: Обязательно true + темно-синий цвет
    filled: true,
    fillColor: white,

    // ВНУТРЕННИЕ ОТСТУПЫ: Центрируем текст внутри поля
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),

    // ИКОНКА В НАЧАЛЕ: Замóк золотого цвета
    // prefixIcon: const Icon(Icons.lock_outline, color: filledAccentButtonColor),

    // 1. ГРАНИЦА ПО УМОЛЧАНИЮ (когда поле не в фокусе)
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16), // Скругление
      borderSide: const BorderSide(
        color: secondaryTextColor, // Тонкая неяркая линия
        width: 1,
      ),
    ),

    // 2. ГРАНИЦА ПРИ НАЖАТИИ (когда поле в фокусе)
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: filledAccentButtonColor, // Золотая линия при вводе
        width: 2,           // Делаем линию чуть толще
      ),
    ),
  );

}

TextStyle nameParamStyle() {
  return const TextStyle(
    color: black,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}
