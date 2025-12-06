import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleConfig {
  static const String _localeKey = 'app_locale';
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('fr', ''), // French
    Locale('ar', ''), // Arabic
  ];
  
  // Default locale
  static const Locale defaultLocale = Locale('en', '');
  
  // Get saved locale
  static Future<Locale> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      
      if (localeCode != null) {
        final parts = localeCode.split('_');
        if (parts.length == 2) {
          return Locale(parts[0], parts[1]);
        } else if (parts.length == 1) {
          return Locale(parts[0]);
        }
      }
    } catch (e) {
      // If error, return default locale
    }
    
    return defaultLocale;
  }
  
  // Save locale
  static Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = locale.countryCode != null && locale.countryCode!.isNotEmpty
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await prefs.setString(_localeKey, localeCode);
    } catch (e) {
      // Handle error silently
    }
  }
  
  // Get locale from language name
  static Locale getLocaleFromLanguageName(String languageName) {
    switch (languageName.toLowerCase()) {
      case 'english':
      case 'en':
        return const Locale('en');
      case 'french':
      case 'français':
      case 'fr':
        return const Locale('fr');
      case 'arabic':
      case 'العربية':
      case 'ar':
        return const Locale('ar');
      default:
        return defaultLocale;
    }
  }
  
  // Get language name from locale
  static String getLanguageNameFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'ar':
        return 'Arabic';
      default:
        return 'English';
    }
  }
}

