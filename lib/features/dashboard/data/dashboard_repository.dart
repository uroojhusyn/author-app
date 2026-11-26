import '../../../mock_data/mock_dashboard.dart';
import '../../../core/services/api/api_endpoints.dart';
import '../../../core/services/api/http_api_client.dart';
import '../models/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getStats();
}

// ─────────────────────────────────────────────────────────────
// REAL implementation — calls BlogHub /api/dashboard
// ─────────────────────────────────────────────────────────────
class HttpDashboardRepository implements DashboardRepository {
  final HttpApiClient _api;

  HttpDashboardRepository({HttpApiClient? api}) : _api = api ?? HttpApiClient();

  @override
  Future<DashboardStats> getStats() async {
    final response = await _api.get(ApiEndpoints.dashboard);
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Failed to load dashboard');
    }
    // BlogHub /api/dashboard returns:
    // { total_posts, approved_posts, pending_posts, draft_posts, rejected_posts,
    //   total_views, total_comments, recent_posts: [...] }
    final data = response.data as Map<String, dynamic>;
    return DashboardStats.fromBlogHubJson(data);
  }
}

// ─────────────────────────────────────────────────────────────
// MOCK implementation
// ─────────────────────────────────────────────────────────────
class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return DashboardStats.fromJson(MockDashboardData.stats);
  }
}

