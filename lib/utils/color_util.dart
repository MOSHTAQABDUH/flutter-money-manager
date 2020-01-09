import 'package:flutter/material.dart';
import 'package:flutter_money_manager/consts.dart';

Color valueToColor(int value) {
  for (Color color in colors) {
    if (value == color.value) {
      return color;
    }
  }

  return Color(value);
}
