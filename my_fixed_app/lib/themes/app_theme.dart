// themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // ========== THEME NOTIFICATION SYSTEM ==========
  static bool _isDarkMode = true;
  static final List<VoidCallback> _listeners = [];

  static bool get isDarkMode => _isDarkMode;

  static set isDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      for (final listener in _listeners) {
        listener();
      }
    }
  }

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // ========== COLOR SYSTEM ==========
  static Color get primaryColor => _isDarkMode
      ? const Color(0xFFDC5126) // Vibrant warm orange
      : const Color(0xFF2563EB); // Royal blue
      
  static Color get secondaryColor => _isDarkMode
      ? const Color(0xFF992E1B) // Deep burnt orange
      : const Color(0xFF1E40AF); // Deep blue
      
  static Color get accentColor => _isDarkMode
      ? const Color(0xFFFF6B35) // Bright coral
      : const Color(0xFF3B82F6); // Bright blue
      
  static Color get glassColor =>
      _isDarkMode ? const Color(0x1AFFFFFF) : const Color(0x14000000);
      
  static Color get glassBorder =>
      _isDarkMode ? const Color(0x33FFFFFF) : const Color(0x28000000);
      
  static Color get textPrimary =>
      _isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF111827);
      
  static Color get textSecondary =>
      _isDarkMode ? const Color(0xB3FFFFFF) : const Color(0xFF6B7280);
      
  static Color get textTertiary =>
      _isDarkMode ? const Color(0x8AFFFFFF) : const Color(0xFF9CA3AF);
      
  static Color get dividerColor =>
      _isDarkMode ? const Color(0x1AFFFFFF) : const Color(0x1F000000);
      
  static Color get hintColor =>
      _isDarkMode ? const Color(0x66FFFFFF) : const Color(0xFF9CA3AF);

  // Background Gradients
  static List<Color> get backgroundGradient => _isDarkMode
      ? const [
          Color(0xFF1A1A1A), // Deep black
          Color(0xFF2D1B1B), // Warm dark brown
          Color(0xFF1A1A1A), // Deep black
        ]
      : const [
          Color(0xFFFFFFFF), // Pure white
          Color(0xFFF0F9FF), // Light sky blue
          Color(0xFFFFFFFF), // Pure white
        ];

  // Button Gradients
  static List<Color> get buttonGradient => _isDarkMode
      ? [primaryColor, secondaryColor]
      : [primaryColor, secondaryColor];

  // Status Colors
  static Color get statusApproved => const Color(0xFF10B981); // Emerald green
  static Color get statusOut => const Color(0xFFF59E0B); // Amber
  static Color get statusExpired => const Color(0xFF6B7280); // Cool gray
  static Color get statusRejected => const Color(0xFFEF4444); // Red
  static Color get statusPending => const Color(0xFF3B82F6); // Blue
}

class AppTextStyles {
  // Header Styles
  static TextStyle get headerLarge => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headerMedium => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle get headerSmall => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
        letterSpacing: -0.2,
        height: 1.3,
      );

  // Body Text Styles
  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12,
        color: AppTheme.textSecondary,
        height: 1.4,
      );

  // Label Styles
  static TextStyle get labelMedium => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppTheme.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => TextStyle(
        fontSize: 14,
        color: AppTheme.textSecondary,
        height: 1.4,
      );

  static TextStyle get labelTertiary => TextStyle(
        fontSize: 12,
        color: AppTheme.textTertiary,
        letterSpacing: 0.2,
      );

  // Button Text Styles
  static TextStyle get buttonLarge => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.3,
      );

  static TextStyle get buttonMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      );

  static TextStyle get buttonSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.1,
      );

  // Legacy compatibility
  static TextStyle get buttonText => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      );

  // Hint Text Style
  static TextStyle get hintText => TextStyle(
        fontSize: 14,
        color: AppTheme.hintColor,
        fontStyle: FontStyle.italic,
      );

  // Status Badge Style
  static const TextStyle statusBadge = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.2,
        color: Colors.white,
      );
}

class AppDecorations {
  // Glass Morphism Container
  static BoxDecoration glassContainer({
    Color? color,
    Color? borderColor,
    double borderRadius = 20,
  }) {
    return BoxDecoration(
      color: color ?? AppTheme.glassColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppTheme.glassBorder,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 24,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Button Decoration
  static BoxDecoration buttonDecoration({
    bool isEnabled = true,
    double borderRadius = 30,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        colors: isEnabled
            ? AppTheme.buttonGradient
            : [
                Colors.grey.withOpacity(0.5),
                Colors.grey.withOpacity(0.3),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: isEnabled
          ? [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  // Input Field Decoration
  static InputDecoration inputDecoration({
    required String label,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.bodySmall.copyWith(
        color: AppTheme.textSecondary,
      ),
      hintText: hintText,
      hintStyle: AppTextStyles.hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppTheme.glassBorder,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppTheme.primaryColor.withOpacity(0.8),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppTheme.statusRejected.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppTheme.statusRejected,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: AppTheme.glassColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    );
  }

  // Icon Container
  static BoxDecoration iconContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(0.2),
        width: 1,
      ),
    );
  }

  // Status Icon Container
  static BoxDecoration statusIconContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      shape: BoxShape.circle,
      border: Border.all(
        color: color.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  // Info Box Container
  static BoxDecoration infoBoxContainer() {
    return BoxDecoration(
      color: AppTheme.primaryColor.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppTheme.primaryColor.withOpacity(0.2),
        width: 1.5,
      ),
    );
  }

  // Status Badge Container
  static BoxDecoration statusBadgeContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
        color: color.withOpacity(0.4),
        width: 1.5,
      ),
    );
  }

  // QR Code Container
  static BoxDecoration qrContainer() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Loading Container
  static BoxDecoration loadingContainer() {
    return BoxDecoration(
      color: AppTheme.glassColor,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
        color: AppTheme.glassBorder,
        width: 1.5,
      ),
    );
  }

  // Empty State Container
  static BoxDecoration emptyStateContainer() {
    return BoxDecoration(
      color: AppTheme.glassColor,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: AppTheme.glassBorder,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Background Gradient
  static BoxDecoration backgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: AppTheme.backgroundGradient,
      ),
    );
  }
}

class AppSpacing {
  static const double screenPadding = 24.0;
  static const double cardPadding = 20.0;
  static const double sectionSpacing = 24.0;
  static const double elementSpacing = 16.0;
  static const double smallSpacing = 12.0;
  static const double tinySpacing = 8.0;
  static const double microSpacing = 4.0;

  // Icon Sizes
  static const double iconSizeLarge = 32.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeSmall = 16.0;

  // Container Sizes
  static const double loadingSize = 60.0;
  static const double qrSize = 200.0;

  // Button Sizes
  static const double buttonHeightLarge = 56.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightSmall = 40.0;
}

class AppWidgetStyles {
  // Back Button Style
  static Widget backButton(BuildContext context,
      {VoidCallback? onPressed, IconData? icon}) {
    return Container(
      decoration: AppDecorations.glassContainer(borderRadius: 100),
      child: IconButton(
        icon: Icon(icon ?? Icons.arrow_back_rounded, color: AppTheme.textSecondary),
        onPressed: onPressed ??
            () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
        splashRadius: 24,
      ),
    );
  }

  // Info Row Widget
  static Widget infoRow(String label, String value, {bool expandLabel = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: expandLabel ? 100 : null,
            child: Text(
              '$label:',
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.tinySpacing),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Loading Widget
  static Widget loadingWidget({double size = AppSpacing.loadingSize}) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: AppDecorations.loadingContainer(),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          strokeWidth: 3.5,
        ),
      ),
    );
  }

  // Empty State Widget
  static Widget emptyStateWidget({
    String title = "No Data Found",
    String message = "There's nothing to display here.",
    IconData icon = Icons.inbox_outlined,
  }) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.5),
        decoration: AppDecorations.emptyStateContainer(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppTheme.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            Text(
              title,
              style: AppTextStyles.headerMedium,
            ),
            const SizedBox(height: AppSpacing.tinySpacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  // Section Header Widget
  static Widget sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.tinySpacing),
          decoration: AppDecorations.iconContainer(AppTheme.primaryColor),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: AppSpacing.iconSizeMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.smallSpacing),
        Text(
          title,
          style: AppTextStyles.headerSmall,
        ),
      ],
    );
  }
}