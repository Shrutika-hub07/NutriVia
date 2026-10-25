import 'package:flutter/material.dart';

class NutriviaColors {
  // Brand Palette (from design tokens)
  static const Color plum = Color(0xFF5B2A86);         // Primary brand, key buttons, headings on light
  static const Color nightPlum = Color(0xFF2D1B42);    // Dark surfaces, Calm Space night mode, text on light
  static const Color deepPlum = Color(0xFF3B1A5A);     // Dark gradients and pressed states
  static const Color marigold = Color(0xFFE07B39);     // Accent, highlights, voice button, active petals
  static const Color terracotta = Color(0xFFB34A12);   // Orange used for text (passes contrast on light)
  static const Color peach = Color(0xFFFDC88C);        // Warm surfaces, hero backgrounds, cover-style panels
  static const Color lavenderMist = Color(0xFFDCCBEB); // Borders, chips, inactive states
  static const Color paper = Color(0xFFF6F1FB);        // Main app background
  static const Color snow = Color(0xFFFBF8FE);         // Cards
  static const Color cream = Color(0xFFFFF8EE);        // Warm card variant
  static const Color stone = Color(0xFF8A7F96);        // Secondary text

  // Semantic Status Colors (Muted, harmonized with palette)
  static const Color statusOk = Color(0xFF5E8C61);      // Sage green (~#5E8C61)
  static const Color statusWatch = Color(0xFFD9A21B);   // Saffron (~#D9A21B)
  static const Color statusAlert = Color(0xFFB8325A);   // Deep rose-red (~#B8325A)
}

class NutriviaShapes {
  // Organic Card Radii: 28/28/28/6 creates a signature botanical leaf feel
  static const BorderRadius organicCard = BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(28),
    bottomRight: Radius.circular(28),
    bottomLeft: Radius.circular(6),
  );

  static const BorderRadius organicCardReversed = BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(6),
    bottomRight: Radius.circular(28),
    bottomLeft: Radius.circular(28),
  );

  static const BorderRadius heroCard = BorderRadius.only(
    topLeft: Radius.circular(32),
    topRight: Radius.circular(32),
    bottomRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
  );

  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
