class AppConstants {
  AppConstants._();

  static const String appName = 'BlogHub Authors';
  static const String appVersion = '1.0.0 (Phase 1)';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';

  // Pagination defaults
  static const int defaultPageSize = 10;

  // Post Statuses
  static const String statusPublished = 'published';
  static const String statusDraft = 'draft';
  static const String statusArchived = 'archived';
}
