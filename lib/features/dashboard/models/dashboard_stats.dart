class TopPostMetric {
  final int id;
  final String title;
  final int views;
  final int commentsCount;
  final DateTime publishedAt;

  TopPostMetric({
    required this.id,
    required this.title,
    required this.views,
    required this.commentsCount,
    required this.publishedAt,
  });

  factory TopPostMetric.fromJson(Map<String, dynamic> json) {
    return TopPostMetric(
      id:            (json['id'] as num?)?.toInt() ?? 0,
      title:         json['title'] as String? ?? json['heading'] as String? ?? '',
      views:         (json['views'] as num?)?.toInt()
                     ?? (json['views_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt()
                     ?? (json['commentsCount'] as num?)?.toInt() ?? 0,
      publishedAt:   DateTime.tryParse(
                       json['created_at'] as String?
                       ?? json['publishedAt'] as String? ?? '',
                     ) ?? DateTime.now(),
    );
  }
}

class DashboardStats {
  final int totalPosts;
  final int publishedPosts;   // approved (status=5)
  final int draftPosts;       // status=2
  final int pendingPosts;     // status=3+4
  final int rejectedPosts;    // status=6
  final int totalViews;
  final int totalComments;
  final String monthlyViewsGrowth;
  final List<TopPostMetric> topPerformingPosts;

  // Backwards compatibility getter
  int get archivedPosts => rejectedPosts;

  DashboardStats({
    required this.totalPosts,
    required this.publishedPosts,
    required this.draftPosts,
    required this.pendingPosts,
    required this.rejectedPosts,
    required this.totalViews,
    required this.totalComments,
    required this.monthlyViewsGrowth,
    required this.topPerformingPosts,
  });

  /// Parses the BlogHub /api/dashboard response.
  factory DashboardStats.fromBlogHubJson(Map<String, dynamic> json) {
    final stats = (json['stats'] as Map<String, dynamic>?) ?? json;
    final recentPosts = (json['recent_posts'] as List<dynamic>? ?? [])
        .map((e) => TopPostMetric.fromJson(e as Map<String, dynamic>))
        .toList();

    return DashboardStats(
      totalPosts:         (stats['total_posts'] as num?)?.toInt() ?? 0,
      publishedPosts:     (stats['approved_posts'] as num?)?.toInt() ?? 0,
      draftPosts:         (stats['draft_posts'] as num?)?.toInt() ?? 0,
      pendingPosts:       (stats['pending_posts'] as num?)?.toInt() ?? 0,
      rejectedPosts:      (stats['rejected_posts'] as num?)?.toInt() ?? 0,
      totalViews:         (stats['total_views'] as num?)?.toInt() ?? 0,
      totalComments:      (stats['total_comments'] as num?)?.toInt() ?? 0,
      monthlyViewsGrowth: (stats['views_growth'] ?? stats['monthlyViewsGrowth'] ?? '+0%').toString(),
      topPerformingPosts: recentPosts,
    );
  }

  /// Legacy mock-compatible parser (keys from MockDashboardData)
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalPosts:         json['totalPosts'] as int? ?? 0,
      publishedPosts:     json['publishedPosts'] as int? ?? 0,
      draftPosts:         json['draftPosts'] as int? ?? 0,
      pendingPosts:       json['pendingPosts'] as int? ?? 0,
      rejectedPosts:      json['rejectedPosts'] as int? ?? 0,
      totalViews:         json['totalViews'] as int? ?? 0,
      totalComments:      json['totalComments'] as int? ?? 0,
      monthlyViewsGrowth: json['monthlyViewsGrowth'] as String? ?? '+0%',
      topPerformingPosts: (json['topPerformingPosts'] as List<dynamic>? ?? [])
          .map((item) => TopPostMetric.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
