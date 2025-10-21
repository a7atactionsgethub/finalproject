// themes/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static bool _isDarkMode = true; // 🎯 Dark theme default

  static bool get isDarkMode => _isDarkMode;
  
  static set isDarkMode(bool value) {
    _isDarkMode = value;
  }

  // ========== COLOR SYSTEM ==========
  
  // 🎯 Core Colors
  static Color get primaryColor => _isDarkMode ? const Color(0xFFDC2626) : const Color(0xFF0AD5FF);
  static Color get secondaryColor => _isDarkMode ? const Color(0xFF991B1B) : const Color(0xFF0099CC);
  static Color get glassColor => _isDarkMode ? const Color(0x1AFFFFFF) : const Color(0x0A000000);
  static Color get glassBorder => _isDarkMode ? const Color(0x33FFFFFF) : const Color(0x1A000000);
  static Color get textPrimary => _isDarkMode ? Colors.white : const Color(0xFF1A1A1A);
  static Color get textSecondary => _isDarkMode ? const Color(0xB3FFFFFF) : const Color(0x99000000);
  static Color get textTertiary => _isDarkMode ? const Color(0x8AFFFFFF) : const Color(0x66000000);
  static Color get dividerColor => _isDarkMode ? const Color(0x1AFFFFFF) : const Color(0x1A000000);
  
  // 🎯 Background Gradients
  static List<Color> get backgroundGradient => _isDarkMode 
      ? const [Color(0xFF1A1A1A), Color(0xFF2D1B1B), Color(0xFF1A1A1A)]
      : const [Color(0xFFF8F9FA), Color(0xFFE3F2FD), Color(0xFFF8F9FA)];

  // 🎯 Status Colors
  static Color get statusApproved => _isDarkMode ? Colors.green : Colors.green.shade600;
  static Color get statusOut => _isDarkMode ? Colors.orange : Colors.orange.shade600;
  static Color get statusExpired => _isDarkMode ? Colors.grey : Colors.grey.shade600;
  static Color get statusRejected => _isDarkMode ? Colors.red : Colors.red.shade600;
  static Color get statusPending => _isDarkMode ? Colors.blue : Colors.blue.shade600;
}

// ========== TEXT STYLES ==========
class AppTextStyles {
  // Header Styles
  static const TextStyle headerLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
  );

  // Label Styles
  static const TextStyle labelMedium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 14,
  );

  static const TextStyle labelTertiary = TextStyle(
    fontSize: 12,
  );

  // Status Badge Style
  static const TextStyle statusBadge = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    letterSpacing: 1,
  );
}

// ========== DECORATIONS ==========
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
      border: Border.all(color: borderColor ?? AppTheme.glassBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
        ),
      ],
    );
  }

  // Icon Container
  static BoxDecoration iconContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    );
  }

  // Status Icon Container
  static BoxDecoration statusIconContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      shape: BoxShape.circle,
      border: Border.all(color: color.withOpacity(0.3)),
    );
  }

  // Info Box Container
  static BoxDecoration infoBoxContainer() {
    return BoxDecoration(
      color: AppTheme.primaryColor.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppTheme.primaryColor.withOpacity(0.1),
      ),
    );
  }

  // Status Badge Container
  static BoxDecoration statusBadgeContainer(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    );
  }

  // QR Code Container
  static BoxDecoration qrContainer() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 15,
        ),
      ],
    );
  }

  // Loading Container
  static BoxDecoration loadingContainer() {
    return BoxDecoration(
      color: AppTheme.glassColor,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: AppTheme.glassBorder),
    );
  }

  // Empty State Container
  static BoxDecoration emptyStateContainer() {
    return BoxDecoration(
      color: AppTheme.glassColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.glassBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
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

// ========== SPACING SYSTEM ==========
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
  static const double buttonHeight = 48.0;
  static const double buttonBorderRadius = 16.0;
}

// ========== WIDGET BUILDER METHODS ==========
class AppWidgetStyles {
  // Back Button Style
  static Widget backButton(BuildContext context, {VoidCallback? onPressed}) {
    return Container(
      decoration: AppDecorations.glassContainer(borderRadius: 16),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.textSecondary),
        onPressed: onPressed ?? () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
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
          Container(
            width: expandLabel ? 100 : null,
            child: Text(
              '$label:',
              style: AppTextStyles.labelMedium.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.tinySpacing),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: AppTextStyles.bodyMedium.copyWith(color: AppTheme.textPrimary),
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
          strokeWidth: 3,
        ),
      ),
    );
  }

  // Empty State Widget
  static Widget emptyStateWidget({
    String title = "No Data Found",
    String message = "There's nothing to display here.",
    IconData icon = Icons.receipt_long_outlined,
  }) {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppDecorations.emptyStateContainer(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppSpacing.elementSpacing),
            Text(
              title,
              style: AppTextStyles.headerMedium.copyWith(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: AppSpacing.tinySpacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(color: AppTheme.textSecondary),
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
          style: AppTextStyles.headerSmall.copyWith(color: AppTheme.textPrimary),
        ),
      ],
    );
  }

  // Status Widget Builder
  static Widget statusIndicator({
    required String status,
    required String message,
    required IconData icon,
    Color? color,
    String subMessage = '',
    bool showQr = false,
    String qrData = '',
  }) {
    final statusColor = color ?? _getStatusColor(status);
    
    return Container(
      width: double.infinity,
      decoration: AppDecorations.glassContainer(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: AppDecorations.statusBadgeContainer(statusColor),
              child: Text(
                status.toUpperCase(),
                style: AppTextStyles.statusBadge.copyWith(color: statusColor),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Icon
            Container(
              padding: const EdgeInsets.all(AppSpacing.elementSpacing),
              decoration: AppDecorations.statusIconContainer(statusColor),
              child: Icon(icon, color: statusColor, size: AppSpacing.iconSizeLarge),
            ),
            
            const SizedBox(height: AppSpacing.elementSpacing),
            
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.headerMedium.copyWith(color: AppTheme.textPrimary),
            ),
            
            if (subMessage.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.tinySpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  subMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelSmall.copyWith(color: AppTheme.textSecondary),
                ),
              ),
            ],
            
            if (showQr && qrData.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sectionSpacing),
              _buildQrSection(qrData),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method for status colors
  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.statusApproved;
      case 'out':
        return AppTheme.statusOut;
      case 'expired':
      case 'used':
        return AppTheme.statusExpired;
      case 'rejected':
        return AppTheme.statusRejected;
      case 'pending':
        return AppTheme.statusPending;
      default:
        return AppTheme.primaryColor;
    }
  }

  // QR Section Builder
  static Widget _buildQrSection(String qrData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: AppDecorations.qrContainer(),
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: AppSpacing.qrSize,
            gapless: true,
          ),
        ),
        
        const SizedBox(height: AppSpacing.elementSpacing),
        
        Container(
          padding: const EdgeInsets.all(AppSpacing.smallSpacing),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Scan this QR at the gate to go out or return",
            textAlign: TextAlign.center,
            style: AppTextStyles.labelTertiary.copyWith(color: AppTheme.textSecondary),
          ),
        ),
      ],
    );
  }
}

// ========== THEME DATA FOR MATERIAL APP ==========
class AppThemeData {
  static ThemeData get themeData {
    return ThemeData(
      brightness: AppTheme.isDarkMode ? Brightness.dark : Brightness.light,
      primaryColor: AppTheme.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTheme.primaryColor,
        brightness: AppTheme.isDarkMode ? Brightness.dark : Brightness.light,
        primary: AppTheme.primaryColor,
        secondary: AppTheme.secondaryColor,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        titleTextStyle: AppTextStyles.headerLarge.copyWith(color: AppTheme.textPrimary),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headerLarge.copyWith(color: AppTheme.textPrimary),
        displayMedium: AppTextStyles.headerMedium.copyWith(color: AppTheme.textPrimary),
        displaySmall: AppTextStyles.headerSmall.copyWith(color: AppTheme.textPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppTheme.textPrimary),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppTheme.textPrimary),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppTheme.textPrimary),
        labelLarge: AppTextStyles.labelMedium.copyWith(color: AppTheme.textPrimary),
        labelMedium: AppTextStyles.labelSmall.copyWith(color: AppTheme.textPrimary),
        labelSmall: AppTextStyles.labelTertiary.copyWith(color: AppTheme.textPrimary),
      ),
      iconTheme: IconThemeData(color: AppTheme.textPrimary),
      dividerColor: AppTheme.dividerColor,
      cardTheme: CardTheme(
        color: AppTheme.glassColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppTheme.glassBorder),
        ),
      ),
    );
  }
}