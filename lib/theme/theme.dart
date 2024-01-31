import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';
import 'package:qwitravel/models/settings.dart';

import 'colors/accent.dart';
import 'colors/colors.dart';
import 'observer.dart';

class AppTheme {
  // Dev note: All of these could be constant variables, but this is better for
  //           development (you don't have to hot-restart)

  static const String _fontFamily = "Montserrat";

  static Color? _paletteAccentLight(CorePalette? palette) =>
      palette != null ? Color(palette.primary.get(70)) : null;
  static Color? _paletteHighlightLight(CorePalette? palette) =>
      palette != null ? Color(palette.neutral.get(100)) : null;
  static Color? _paletteBackgroundLight(CorePalette? palette) =>
      palette != null ? Color(palette.neutral.get(95)) : null;

  static Color? _paletteAccentDark(CorePalette? palette) =>
      palette != null ? Color(palette.primary.get(80)) : null;
  static Color? _paletteBackgroundDark(CorePalette? palette) =>
      palette != null ? Color(palette.neutralVariant.get(10)) : null;
  static Color? _paletteHighlightDark(CorePalette? palette) =>
      palette != null ? Color(palette.neutralVariant.get(20)) : null;

  // Light Theme
  static ThemeData lightTheme(BuildContext context, {CorePalette? palette}) {
    var lightColors = AppColors.fromBrightness(Brightness.light);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    AccentColor accentColor = settings.accentColor;
    final customAccentColor =
        accentColor == AccentColor.custom ? settings.customAccentColor : null;
    Color accent = customAccentColor ??
        accentColorMap[accentColor] ??
        const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentLight(palette)!;
    } else {
      palette = null;
    }

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: lightColors.background,
      primaryColor: lightColors.qwit,
      dividerColor: const Color(0x00000000),
      colorScheme: ColorScheme(
        primary: accent,
        onPrimary:
            (accent.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        secondary: accent,
        onSecondary:
            (accent.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        background: lightColors.highlight,
        onBackground: Colors.black.withOpacity(.9),
        brightness: Brightness.light,
        error: lightColors.red,
        onError: Colors.white.withOpacity(.9),
        surface: lightColors.highlight,
        onSurface: Colors.black.withOpacity(.9),
      ),
      shadowColor: lightColors.shadow.withOpacity(.5),
      appBarTheme: AppBarTheme(backgroundColor: lightColors.background),
      indicatorColor: accent,
      iconTheme: IconThemeData(color: lightColors.text.withOpacity(.75)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor:
            accent.withOpacity(accentColor == AccentColor.adaptive ? 0.4 : 0.8),
        iconTheme:
            MaterialStateProperty.all(IconThemeData(color: lightColors.text)),
        backgroundColor: lightColors.highlight,
        labelTextStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: lightColors.text.withOpacity(0.8),
        )),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 76.0,
      ),
      sliderTheme: SliderThemeData(
        inactiveTrackColor: accent.withOpacity(.3),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
      expansionTileTheme: ExpansionTileThemeData(iconColor: accent),
      cardColor: lightColors.highlight,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Provider.of<ThemeModeObserver>(context, listen: false)
                .updateNavbarColor
            ? lightColors.background
            : null,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context, {CorePalette? palette}) {
    var darkColors = AppColors.fromBrightness(Brightness.dark);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    AccentColor accentColor = settings.accentColor;
    final customAccentColor =
        accentColor == AccentColor.custom ? settings.customAccentColor : null;
    Color accent = customAccentColor ??
        accentColorMap[accentColor] ??
        const Color(0x00000000);

    if (accentColor == AccentColor.adaptive) {
      if (palette != null) accent = _paletteAccentDark(palette)!;
    } else {
      palette = null;
    }

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: darkColors.background,
      primaryColor: darkColors.qwit,
      dividerColor: const Color(0x00000000),
      colorScheme: ColorScheme(
        primary: accent,
        onPrimary:
            (accent.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        secondary: accent,
        onSecondary:
            (accent.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                .withOpacity(.9),
        background: darkColors.highlight,
        onBackground: Colors.white.withOpacity(.9),
        brightness: Brightness.dark,
        error: darkColors.red,
        onError: Colors.black.withOpacity(.9),
        surface: darkColors.highlight,
        onSurface: Colors.white.withOpacity(.9),
      ),
      shadowColor: darkColors.highlight.withOpacity(.5), //darkColors.shadow,
      appBarTheme: AppBarTheme(backgroundColor: darkColors.background),
      indicatorColor: accent,
      iconTheme: IconThemeData(color: darkColors.text.withOpacity(.75)),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor:
            accent.withOpacity(accentColor == AccentColor.adaptive ? 0.4 : 0.8),
        iconTheme:
            MaterialStateProperty.all(IconThemeData(color: darkColors.text)),
        backgroundColor: darkColors.highlight,
        labelTextStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: darkColors.text.withOpacity(0.8),
        )),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 76.0,
      ),
      sliderTheme: SliderThemeData(
        inactiveTrackColor: accent.withOpacity(.3),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
      expansionTileTheme: ExpansionTileThemeData(iconColor: accent),
      cardColor: darkColors.highlight,
      chipTheme: ChipThemeData(
        backgroundColor: accent.withOpacity(.2),
        elevation: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Provider.of<ThemeModeObserver>(context, listen: false)
                .updateNavbarColor
            ? darkColors.background
            : null,
      ),
    );
  }
}
