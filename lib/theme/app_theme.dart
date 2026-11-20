import 'package:flutter/material.dart';

abstract class AppTheme {
  static const Color cream = Color(0xFFFFF9EF);
  static const Color yellow = Color(0xFFFFD96A);
  static const Color skyBlue = Color(0xFF8DD6F5);
  static const Color mintGreen = Color(0xFFA9E9C5);
  static const Color lavender = Color(0xFFCDB8F5);
  static const Color coral = Color(0xFFFFAAA0);
  static const Color peach = Color(0xFFFFCC9D);
  static const Color navy = Color(0xFF454A78);
  static const Color softWhite = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFDF9);
  static const Color disabledBg = Color(0xFFECE8E1);
  static const Color disabledText = Color(0xFF9E9AA9);

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: lavender,
      primary: navy,
      secondary: skyBlue,
      surface: cream,
    ),
    fontFamily: 'Roboto',
    useMaterial3: true,
  );

  static List<BoxShadow> cardShadow({Color shadowColor = navy}) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.10),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> tactileShadow({required Color baseColor}) => [
        BoxShadow(
          color: baseColor.withValues(alpha: 0.45),
          offset: const Offset(0, 5),
        ),
      ];
}
