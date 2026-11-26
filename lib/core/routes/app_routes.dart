class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String posts = '/posts';
  static const String postCreate = '/posts/create';
  static const String postDetail = '/posts/:id';
  static const String postEdit = '/posts/:id/edit';
  static const String comments = '/comments';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';

  static String postDetailPath(dynamic id) => '/posts/$id';
  static String postEditPath(dynamic id) => '/posts/$id/edit';
}

