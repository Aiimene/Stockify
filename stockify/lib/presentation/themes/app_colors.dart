import 'package:flutter/material.dart';

/// StockiFy App Color Palette
/// Centralized color definitions for consistent theming across the app
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo - Main brand color
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Accent Colors
  static const Color accent = Color(0xFF10B981); // Green - Success/Actions
  static const Color accentLight = Color(0xFF34D399);
  static const Color accentDark = Color(0xFF059669);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5); // Light gray background
  static const Color surface = Color(0xFFFFFFFF); // White surface
  static const Color surfaceVariant = Color(0xFFFAFAFA);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Dark text
  static const Color textSecondary = Color(0xFF6B7280); // Gray text
  static const Color textTertiary = Color(0xFF9CA3AF); // Light gray text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on primary
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B); // Orange/Amber
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // Notification Colors
  static const Color notificationLowStock = Color(0xFFFFA726); // Orange
  static const Color notificationLowStockBg = Color(0xFFFFE0B2);
  static const Color notificationExpiring = Color(0xFF66BB6A); // Green
  static const Color notificationExpiringBg = Color(0xFFC8E6C9);
  static const Color notificationOutOfStock = Color(0xFFEF5350); // Red
  static const Color notificationOutOfStockBg = Color(0xFFFFCDD2);
  static const Color notificationNewOrder = Color(0xFF42A5F5); // Blue
  static const Color notificationNewOrderBg = Color(0xFFBBDEFB);
  static const Color notificationPriceChange = Color(0xFFAB47BC); // Purple
  static const Color notificationPriceChangeBg = Color(0xFFE1BEE7);
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);
  
  // Divider
  static const Color divider = Color(0xFFE5E7EB);
  
  // Shadow
  static Color shadow = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.15);
  
  // Input Field Colors
  static const Color inputFill = Color(0xFFFAFAFA);
  static const Color inputBorder = Color(0xFFE5E7EB);
  static const Color inputFocusBorder = accent;
  
  // Chart Colors
  static const Color chartPrimary = primary;
  static const Color chartSecondary = accent;
  static const Color chartTertiary = Color(0xFF8B5CF6); // Purple
  static const Color chartBackground = Color(0xFFF9FAFB);
  
  // Product Card Colors
  static const Color productCardBackground = surface;
  static const Color productImagePlaceholder = Color(0xFFF3F4F6);
  
  // Bottom Navigation
  static const Color bottomNavActive = accent;
  static const Color bottomNavInactive = textSecondary;
  static const Color bottomNavBackground = surface;
  
  // Icon Colors
  static const Color iconPrimary = textSecondary;
  static const Color iconSecondary = textTertiary;
  static const Color iconActive = accent;
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

