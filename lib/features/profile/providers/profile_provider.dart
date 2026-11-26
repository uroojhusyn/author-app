import 'package:flutter/foundation.dart';
import '../data/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileProvider({required this.repository}) {
    loadProfile();
  }

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await repository.getProfile();
    } catch (e) {
      _errorMessage = 'Failed to load profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(ProfileModel updated) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await repository.updateProfile(updated);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
