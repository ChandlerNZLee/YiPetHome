// lib/view-models/community.dart
import 'package:flutter/material.dart';

class CommunityPostData {
  final int id;
  final String userName;
  final String time;
  final String avatarPath;
  final String content;
  final List<String> imagePaths;

  int likes;
  final int comments;
  bool liked;

  CommunityPostData({
    required this.id,
    required this.userName,
    required this.time,
    required this.avatarPath,
    required this.content,
    required this.imagePaths,
    required this.likes,
    required this.comments,
    required this.liked,
  });
}

class CommunityColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF747982);
}
