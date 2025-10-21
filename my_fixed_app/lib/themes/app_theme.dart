// themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static bool _isDarkMode = true; // 🎯 CHANGED TO TRUE for dark theme default

  static bool get isDarkMode => _isDarkMode;
  
  static set isDarkMode(bool value) {
    _isDarkMode = value;
  }

  // Colors
  static Color get primaryColor => _isDarkMode ? const Color(0xFFDC2626) : const Color(0xFF0AD5FF);
  static Color get secondaryColor => _isDarkMode ? const Color(0xFF991B1B) : const Color(0xFF0099CC);
  static Color get glassColor => _isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);
  static Color get glassBorder => _isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1);
  static Color get textPrimary => _isDarkMode ? Colors.white : const Color(0xFF1A1A1A);
  static Color get textSecondary => _isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.6);
  static Color get textTertiary => _isDarkMode ? Colors.white.withOpacity(0.54) : Colors.black.withOpacity(0.4);
  static Color get dividerColor => _isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1);
  
  // Background Gradients
  static List<Color> get backgroundGradient => _isDarkMode 
      ? const [Color(0xFF1A1A1A), Color(0xFF2D1B1B), Color(0xFF1A1A1A)]
      : const [Color(0xFFF8F9FA), Color(0xFFE3F2FD), Color(0xFFF8F9FA)];
}