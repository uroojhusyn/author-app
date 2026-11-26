import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'package:untitled/core/theme/app_theme.dart';
import 'core/services/api/http_api_client.dart';

// Repositories — abstract + both implementations
import 'features/auth/data/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/comments/data/comment_repository.dart';
import 'features/comments/providers/comment_provider.dart';
import 'features/dashboard/data/dashboard_repository.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/posts/data/post_repository.dart';
import 'features/posts/providers/post_provider.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/settings/data/settings_repository.dart';
import 'features/settings/providers/settings_provider.dart';

/// ─────────────────────────────────────────────────────────────
/// Set this to TRUE to connect to the real BlogHub Laravel API.
/// Set to FALSE to run with mock/offline data (no server needed).
/// ─────────────────────────────────────────────────────────────
const bool useRealApi = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlogHubApp());
}

class BlogHubApp extends StatelessWidget {
  const BlogHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Shared HTTP client instance (one connection pool for all repositories)
    final apiClient = HttpApiClient();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            repository: useRealApi
                ? HttpAuthRepository(api: apiClient)
                : MockAuthRepository(),
          ),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(
            repository: useRealApi
                ? HttpDashboardRepository(api: apiClient)
                : MockDashboardRepository(),
          ),
        ),
        ChangeNotifierProvider<PostProvider>(
          create: (_) => PostProvider(
            repository: useRealApi
                ? HttpPostRepository(api: apiClient)
                : MockPostRepository(),
          ),
        ),
        // Comments: BlogHub API does not expose a dedicated
        // "author's received comments" endpoint — the public
        // /api/v1/posts/{id}/comments lists them per-post.
        // Keep mock for now; the comment_repository can be wired
        // to the public API in a follow-up.
        ChangeNotifierProvider<CommentProvider>(
          create: (_) => CommentProvider(
            repository: MockCommentRepository(),
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(
            repository: useRealApi
                ? HttpProfileRepository(api: apiClient)
                : MockProfileRepository(),
          ),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(
            repository: MockSettingsRepository(),
          ),
        ),
      ],
      child: const _BlogHubView(),
    );
  }
}

class _BlogHubView extends StatefulWidget {
  const _BlogHubView();

  @override
  State<_BlogHubView> createState() => _BlogHubViewState();
}

class _BlogHubViewState extends State<_BlogHubView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _router = createRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.themeMode,
      routerConfig: _router,
    );
  }
}
