import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class NutriviaTheme {
  static ThemeData lightTheme(double textScale) {
    final muktaFont = GoogleFonts.mukta().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: muktaFont,
      scaffoldBackgroundColor: NutriviaColors.paper,
      colorScheme: const ColorScheme.light(
        primary: NutriviaColors.plum,
        onPrimary: Colors.white,
        secondary: NutriviaColors.marigold,
        onSecondary: Colors.white,
        surface: NutriviaColors.snow,
        onSurface: NutriviaColors.nightPlum,
        surfaceContainerHighest: NutriviaColors.cream,
        error: NutriviaColors.statusAlert,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.bricolageGrotesque(
          fontSize: 32 * textScale,
          fontWeight: FontWeight.w700,
          color: NutriviaColors.plum,
          height: 1.25,
        ),
        displayMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 26 * textScale,
          fontWeight: FontWeight.w600,
          color: NutriviaColors.plum,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.bricolageGrotesque(
          fontSize: 20 * textScale,
          fontWeight: FontWeight.w600,
          color: NutriviaColors.nightPlum,
          height: 1.35,
        ),
        titleMedium: GoogleFonts.bricolageGrotesque(
          fontSize: 18 * textScale,
          fontWeight: FontWeight.w600,
          color: NutriviaColors.nightPlum,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontFamily: muktaFont,
          fontSize: 17 * textScale,
          fontWeight: FontWeight.w400,
          color: NutriviaColors.nightPlum,
          height: 1.55,
        ),
        bodyMedium: TextStyle(
          fontFamily: muktaFont,
          fontSize: 15 * textScale,
          fontWeight: FontWeight.w400,
          color: NutriviaColors.nightPlum,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontFamily: muktaFont,
          fontSize: 16 * textScale,
          fontWeight: FontWeight.w600,
          color: NutriviaColors.nightPlum,
          height: 1.4,
        ),
        labelMedium: TextStyle(
          fontFamily: muktaFont,
          fontSize: 13 * textScale,
          fontWeight: FontWeight.w500,
          color: NutriviaColors.stone,
          height: 1.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: NutriviaColors.snow,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: NutriviaShapes.organicCard,
          side: BorderSide(color: NutriviaColors.lavenderMist, width: 1.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NutriviaColors.plum,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: TextStyle(fontFamily: muktaFont, fontSize: 18 * textScale, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NutriviaColors.plum,
          side: const BorderSide(color: NutriviaColors.plum, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: TextStyle(fontFamily: muktaFont, fontSize: 17 * textScale, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NutriviaColors.paper,
        foregroundColor: NutriviaColors.plum,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 22 * textScale,
          fontWeight: FontWeight.w700,
          color: NutriviaColors.plum,
        ),
      ),
    );
  }

  static ThemeData calmNightTheme(double textScale) {
    final muktaFont = GoogleFonts.mukta().fontFamily;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: muktaFont,
      scaffoldBackgroundColor: NutriviaColors.nightPlum,
      colorScheme: const ColorScheme.dark(
        primary: NutriviaColors.marigold,
        onPrimary: NutriviaColors.nightPlum,
        surface: NutriviaColors.deepPlum,
        onSurface: NutriviaColors.paper,
      ),
    );
  }
}
