import 'package:flutter/material.dart';
import '../models/settings_model.dart';

abstract class SettingsRepository {
  Future<SettingsModel> getSettings();
  Future<void> saveSettings(SettingsModel settings);
}

class MockSettingsRepository implements SettingsRepository {
  SettingsModel _settings = SettingsModel(
    themeMode: ThemeMode.system,
    emailNotifications: true,
    commentAlerts: true,
    autoSaveDrafts: true,
  );

  @override
  Future<SettingsModel> getSettings() async {
    return _settings;
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    _settings = settings;
  }
}
