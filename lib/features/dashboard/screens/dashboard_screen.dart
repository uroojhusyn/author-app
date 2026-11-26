import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/providers/auth_provider.dart';
import '../../posts/providers/post_provider.dart';
import '../models/dashboard_stats.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Providers (logic unchanged) ──────────────────────────────────────────
    final auth = context.watch<AuthProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      appBar: _buildAppBar(context, auth, dashboard),
      body: dashboard.isLoading && dashboard.stats == null
          ? const LoadingIndicator(message: 'Loading your dashboard…')
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  dashboard.loadStats(),
                  postProvider.fetchPosts(),
                ]);
              },
              child: _buildBody(context, auth, dashboard, postProvider),
            ),
      floatingActionButton: _buildFab(context),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AuthProvider auth,
    DashboardProvider dashboard,
  ) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'BlogHub',
            style: AppTextStyles.appBarTitle,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () => dashboard.loadStats(),
          tooltip: 'Refresh Stats',
        ),
        IconButton(
          icon: const Icon(Icons.person_outline_rounded),
          onPressed: () => context.push(AppRoutes.profile),
          tooltip: 'Profile',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push(AppRoutes.settings),
          tooltip: 'Settings',
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push(AppRoutes.postCreate),
      icon: const Icon(Icons.add_rounded),
      label: Text(
        'New Post',
        style: AppTextStyles.button,
      ),
      tooltip: 'Create New Post',
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────
  Widget _buildBody(
    BuildContext context,
    AuthProvider auth,
    DashboardProvider dashboard,
    PostProvider postProvider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        // ── Welcome header ─────────────────────────────────────────────────
        _WelcomeHeader(name: auth.user?.name ?? 'Author'),

        const SizedBox(height: AppSpacing.xxl),

        // ── Quick actions ──────────────────────────────────────────────────
        _QuickActions(context: context),

        if (dashboard.stats != null) ...[
          const SizedBox(height: AppSpacing.sectionGap),

          // ── Stats section ──────────────────────────────────────────────
          SectionHeader(
            title: 'Overview',
            actionLabel: 'See all posts',
            onAction: () => context.push(AppRoutes.posts),
          ),

          const SizedBox(height: AppSpacing.lg),

          _StatsGrid(stats: dashboard.stats!),

          const SizedBox(height: AppSpacing.sectionGap),

          // ── Post status breakdown ──────────────────────────────────────
          SectionHeader(title: 'Post Status'),

          const SizedBox(height: AppSpacing.lg),

          _StatusRow(stats: dashboard.stats!),

          // ── Recent posts ───────────────────────────────────────────────
          const SizedBox(height: AppSpacing.sectionGap),

          SectionHeader(
            title: 'Recent Posts',
            actionLabel: 'View all',
            onAction: () => context.push(AppRoutes.posts),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (postProvider.isLoading && postProvider.posts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (postProvider.posts.isEmpty)
            EmptyState(
              icon: Icons.article_outlined,
              title: 'No recent posts',
              subtitle: 'Write and publish your first post to see it here.',
              actionLabel: 'Create Post',
              onAction: () => context.push(AppRoutes.postCreate),
            )
          else
            ...postProvider.posts.take(3).map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: PostCard(
                  post: post,
                  onTap: () => context.push(AppRoutes.postDetailPath(post.id)),
                  onEditTap: () => context.push(AppRoutes.postEditPath(post.id)),
                ),
              ),
            ),

          // ── Top performing posts ───────────────────────────────────────
          if (dashboard.stats!.topPerformingPosts.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),

            SectionHeader(
              title: 'Top Performing Posts',
              actionLabel: 'All posts',
              onAction: () => context.push(AppRoutes.posts),
            ),

            const SizedBox(height: AppSpacing.lg),

            ...dashboard.stats!.topPerformingPosts
                .map((post) => _TopPostTile(post: post, context: context)),
          ],
        ],

        if (dashboard.stats == null && !dashboard.isLoading)
          EmptyState(
            icon: Icons.bar_chart_rounded,
            title: 'No stats yet',
            subtitle: 'Write and publish your first post to see your dashboard come alive.',
            actionLabel: 'Create Post',
            onAction: () => context.push(AppRoutes.postCreate),
          ),

        // Bottom padding for FAB
        const SizedBox(height: AppSpacing.massive),
      ],
    );
  }
}

// ── Welcome Header ────────────────────────────────────────────────────────────

class _WelcomeHeader extends StatelessWidget {
  final String name;
  const _WelcomeHeader({required this.name});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.authorGradientStart,
            AppColors.authorGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
        boxShadow: [
          BoxShadow(
            color: AppColors.authorPrimary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit_note_rounded,
                  size: 14,
                  color: AppColors.authorPrimary,
                ),
                const SizedBox(width: 4),
                Text(
                  'AUTHOR STUDIO',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.authorPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$_greeting, $name!',
            style: AppTextStyles.bannerHeading.copyWith(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Share your insights with the BlogHub community. When you submit an article, an administrator will review and approve it.',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Quick Actions
// -----------------------------------------------------------------------------
class _QuickActions extends StatelessWidget {
  final BuildContext context;
  const _QuickActions({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _ActionChip(
            icon: Icons.article_outlined,
            label: 'My Posts',
            onTap: () => context.push(AppRoutes.posts),
            primary: false,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 3,
          child: _ActionChip(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Comments',
            onTap: () => context.push(AppRoutes.comments),
            primary: false,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 3,
          child: _ActionChip(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            onTap: () => context.push(AppRoutes.profile),
            primary: false,
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: primary ? Colors.transparent : cs.outline,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconLg,
              color: primary ? Colors.white : cs.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: primary ? Colors.white : cs.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats Grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final DashboardStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.55,
      children: [
        _StatCard(
          icon: Icons.remove_red_eye_outlined,
          value: _formatCount(stats.totalViews),
          label: 'Total Views',
          badge: stats.monthlyViewsGrowth,
          iconColor: AppColors.info,
          iconBg: AppColors.infoContainer,
        ),
        _StatCard(
          icon: Icons.chat_bubble_outline_rounded,
          value: _formatCount(stats.totalComments),
          label: 'Comments',
          iconColor: AppColors.accent,
          iconBg: AppColors.accentContainer,
        ),
        _StatCard(
          icon: Icons.article_outlined,
          value: stats.totalPosts.toString(),
          label: 'Total Posts',
          iconColor: AppColors.primary,
          iconBg: AppColors.primaryContainer,
        ),
        _StatCard(
          icon: Icons.check_circle_outline_rounded,
          value: stats.publishedPosts.toString(),
          label: 'Published',
          iconColor: AppColors.success,
          iconBg: AppColors.successContainer,
        ),
      ],
    );
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? badge;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.badge,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: cs.outline, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: iconColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: iconBg,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Icon(icon, size: AppSpacing.iconSm + 2, color: iconColor),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs + 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.statusSuccessBg,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              badge!,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.statusSuccessText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      value,
                      style: AppTextStyles.statNumber.copyWith(
                        color: cs.onSurface,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      label.toUpperCase(),
                      style: AppTextStyles.statLabel.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Status Row
// -----------------------------------------------------------------------------
// ── Status Row ────────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  final DashboardStats stats;
  const _StatusRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatusPill(
            label: 'Published',
            count: stats.publishedPosts,
            color: AppColors.success,
            bg: AppColors.successContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatusPill(
            label: 'Draft',
            count: stats.draftPosts,
            color: AppColors.warning,
            bg: AppColors.warningContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatusPill(
            label: 'Archived',
            count: stats.archivedPosts,
            color: AppColors.archived,
            bg: const Color(0xFFE2E8F0),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bg;
  const _StatusPill({
    required this.label,
    required this.count,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: AppTextStyles.headlineSmall.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ── Top Post Tile ─────────────────────────────────────────────────────────────

class _TopPostTile extends StatelessWidget {
  final TopPostMetric post;
  final BuildContext context;
  const _TopPostTile({required this.post, required this.context});

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext ctx) {
    final cs = Theme.of(ctx).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: cs.outline, width: 1),
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.postDetailPath(post.id)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              // Rank icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: AppSpacing.iconSm,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _formatCount(post.views),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: AppSpacing.iconSm,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          post.commentsCount.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: AppSpacing.iconSm,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
