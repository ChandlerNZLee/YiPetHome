// lib/view-models/search.dart
import 'package:flutter/material.dart';

class SearchSuggestionData {
  final String title;
  final Color iconColor;
  final Color backgroundColor;

  const SearchSuggestionData({
    required this.title,
    required this.iconColor,
    required this.backgroundColor,
  });
}

class TrendingData {
  final String title;
  final String posts;

  const TrendingData({required this.title, required this.posts});
}

class SearchColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF747982);
  static const divider = Color(0xFFECEEEB);
}
