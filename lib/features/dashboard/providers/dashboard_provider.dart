import 'package:flutter/foundation.dart';
import '../data/dashboard_repository.dart';
import '../models/dashboard_stats.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardStats? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardProvider({required this.repository}) {
    loadStats();
  }

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await repository.getStats();
    } catch (e) {
      _errorMessage = 'Failed to load stats: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
