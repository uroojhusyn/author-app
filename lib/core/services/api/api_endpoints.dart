
class ApiEndpoints {
  ApiEndpoints._();

  // -------------------------------------------------------
  // Live website API Base URL:
  // http://uroojwrites.free.nf/api
  // Set [customBaseUrl] to override for local testing:
  //   ApiEndpoints.customBaseUrl = 'http://127.0.0.1:8000/api';
  // -------------------------------------------------------
  static String customBaseUrl = '';

  /// Base URL pointing to live BlogHub backend: http://uroojwrites.free.nf/api
  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) return customBaseUrl;
    return 'http://uroojwrites.free.nf/api';
  }

  // ── Auth (unversioned, as per BlogHub api.php) ─────────
  static const String login    = '/login';
  static const String register = '/register';
  static const String logout   = '/logout';
  static const String me       = '/me';

  // ── Author Dashboard ───────────────────────────────────
  static const String dashboard = '/dashboard';

  // ── Profile ────────────────────────────────────────────
  static const String profile         = '/profile';
  static const String profilePassword = '/profile/password';

  // ── My Posts (author's own articles) ──────────────────
  static const String myPosts = '/my-posts';
  static String myPostDetail(int id) => '/my-posts/$id';

  // ── Categories (for post-editor dropdown) ─────────────
  static const String categories = '/categories';

  // ── Notifications ──────────────────────────────────────
  static const String notifications        = '/notifications';
  static String notificationRead(int id)   => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/mark-all-read';

  // ── Public v1 API (read-only, no auth needed) ─────────
  static const String v1Posts      = '/v1/posts';
  static String v1PostDetail(int id) => '/v1/posts/$id';
  static String v1PostComments(int postId) => '/v1/posts/$postId/comments';
  static const String v1Authors    = '/v1/authors';
  static const String v1Categories = '/v1/categories';
  static const String v1Search     = '/v1/search';
  static const String v1Stats      = '/v1/stats';
}
