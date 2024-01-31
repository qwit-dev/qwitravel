import 'package:flutter/material.dart';

import 'dark.dart';
import 'light.dart';

class AppColors {
  static ThemeAppColors of(BuildContext context) =>
      fromBrightness(Theme.of(context).brightness);

  static ThemeAppColors fromBrightness(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        return LightMobileAppColors();
      case Brightness.dark:
        return DarkMobileAppColors();
    }
  }
}

abstract class ThemeAppColors {
  final Color shadow = const Color(0x00000000);
  final Color text = const Color(0x00000000);
  final Color background = const Color(0x00000000);
  final Color highlight = const Color(0x00000000);
  final Color qwit = const Color(0x00000000);
  final Color red = const Color(0x00000000);
  final Color orange = const Color(0x00000000);
  final Color yellow = const Color(0x00000000);
  final Color green = const Color(0x00000000);
  final Color teal = const Color(0x00000000);
  final Color blue = const Color(0x00000000);
  final Color indigo = const Color(0x00000000);
  final Color purple = const Color(0x00000000);
  final Color pink = const Color(0x00000000);
}
