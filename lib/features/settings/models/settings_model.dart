import 'package:flutter/material.dart';

class SettingsModel {
  final ThemeMode themeMode;
  final bool emailNotifications;
  final bool commentAlerts;
  final bool autoSaveDrafts;

  SettingsModel({
    required this.themeMode,
    required this.emailNotifications,
    required this.commentAlerts,
    required this.autoSaveDrafts,
  });

  SettingsModel copyWith({
    ThemeMode? themeMode,
    bool? emailNotifications,
    bool? commentAlerts,
    bool? autoSaveDrafts,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      commentAlerts: commentAlerts ?? this.commentAlerts,
      autoSaveDrafts: autoSaveDrafts ?? this.autoSaveDrafts,
    );
  }
}
