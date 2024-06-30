import 'package:flutter/material.dart';

enum AccentColor {
  qwit,
  blue,
  green,
  lime,
  yellow,
  orange,
  red,
  pink,
  purple,
  none,
  adaptive,
  custom
}

final Map<AccentColor, Color> accentColorMap = {
  AccentColor.qwit: const Color(0xFF9E00FF),
  AccentColor.blue: Colors.blue.shade300,
  AccentColor.green: Colors.green.shade400,
  AccentColor.lime: Colors.lightGreen.shade400,
  AccentColor.yellow: Colors.orange.shade300,
  AccentColor.orange: Colors.deepOrange.shade300,
  AccentColor.red: Colors.red.shade300,
  AccentColor.pink: Colors.pink.shade300,
  AccentColor.purple: Colors.purple.shade300,
  //AccentColor.none: Colors.black,
  AccentColor.adaptive: const Color(0xFF9E00FF),
  AccentColor.custom: const Color(0xFF9E00FF),
};
