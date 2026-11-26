import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/comments/screens/comments_list_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/posts/screens/post_create_screen.dart';
import '../../features/posts/screens/post_detail_screen.dart';
import '../../features/posts/screens/post_edit_screen.dart';
import '../../features/posts/screens/posts_list_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import 'app_routes.dart';


GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final path = state.uri.path;

      // Routes that never require authentication
      final publicRoutes = {
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
      };

      final isPublic = publicRoutes.contains(path);

      if (!authProvider.isAuthenticated && !isPublic) {
        return AppRoutes.login;
      }
      if (authProvider.isAuthenticated &&
          (path == AppRoutes.login || path == AppRoutes.register)) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.posts,
        name: 'posts',
        builder: (context, state) => const PostsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.comments,
        name: 'comments',
        builder: (context, state) => const CommentsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.postCreate,
        name: 'postCreate',
        builder: (context, state) => const PostCreateScreen(),
      ),
      GoRoute(
        path: AppRoutes.postDetail,
        name: 'postDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PostDetailScreen(postId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.postEdit,
        name: 'postEdit',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PostEditScreen(postId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
