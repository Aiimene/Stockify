import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Colors.dart';

// ===========================================================
// TYPOGRAPHY SYSTEM
// ===========================================================

// Main typography configuration for SmartStock app
// Fonts chosen according to the brand identity guide:
// - Inter (Primary font — professional, readable)
// - Plus Jakarta Sans (Secondary font — friendly and modern)
// - Poppins (Display font — bold and geometric)

// ===========================================================
// FONT FAMILIES (with Google Fonts)
// ===========================================================

final TextStyle interRegular = GoogleFonts.inter(
  fontWeight: FontWeight.w400,
  color: textColor,
);

final TextStyle interMedium = GoogleFonts.inter(
  fontWeight: FontWeight.w500,
  color: textColor,
);

final TextStyle interBold = GoogleFonts.inter(
  fontWeight: FontWeight.w700,
  color: textColor,
);

final TextStyle plusJakartaMedium = GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w500,
  color: textColor,
);

final TextStyle plusJakartaSemiBold = GoogleFonts.plusJakartaSans(
  fontWeight: FontWeight.w600,
  color: textColor,
);

final TextStyle poppinsBold = GoogleFonts.poppins(
  fontWeight: FontWeight.w700,
  color: textColor,
);

// ===========================================================
// TEXT THEMES
// ===========================================================

final TextTheme smartStockTextTheme = TextTheme(
  // Large titles (App name, big headers)
  displayLarge: GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textColor,
  ),

  // Section headers (Dashboard, Inventory, etc.)
  headlineMedium: GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  ),

  // Subtitles or card titles
  titleMedium: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: text1Color,
  ),

  // Regular text or body paragraphs
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: text1Color,
  ),

  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: text2Color,
  ),

  // Button text
  labelLarge: GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: white1Color,
  ),

  // Captions or small labels
  labelSmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: text2Color,
  ),
);
