import 'package:flutter/material.dart';
import '../data/settings_repository.dart';
import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository repository;

  late SettingsModel _settings;
  bool _isLoading = false;

  SettingsProvider({required this.repository}) {
    _settings = SettingsModel(
      themeMode: ThemeMode.light,
      emailNotifications: true,
      commentAlerts: true,
      autoSaveDrafts: true,
    );
    _loadSettings();
  }

  SettingsModel get settings => _settings;
  ThemeMode get themeMode => _settings.themeMode;
  bool get isLoading => _isLoading;

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();
    _settings = await repository.getSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> toggleEmailNotifications(bool val) async {
    _settings = _settings.copyWith(emailNotifications: val);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> toggleCommentAlerts(bool val) async {
    _settings = _settings.copyWith(commentAlerts: val);
    notifyListeners();
    await repository.saveSettings(_settings);
  }

  Future<void> toggleAutoSaveDrafts(bool val) async {
    _settings = _settings.copyWith(autoSaveDrafts: val);
    notifyListeners();
    await repository.saveSettings(_settings);
  }
}
