import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/comment_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/section_header.dart';
import '../../comments/providers/comment_provider.dart';
import '../providers/post_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPostById(widget.postId);
      context.read<CommentProvider>().fetchComments(postId: widget.postId);
    });
  }

  ({Color bg, Color fg, IconData icon}) _statusStyle(String status) {
    switch (status) {
      case 'published':
        return (
          bg: AppColors.successContainer,
          fg: AppColors.success,
          icon: Icons.check_circle_rounded,
        );
      case 'draft':
        return (
          bg: AppColors.warningContainer,
          fg: AppColors.warning,
          icon: Icons.edit_note_rounded,
        );
      case 'archived':
      default:
        return (
          bg: const Color(0xFFE2E8F0),
          fg: AppColors.archived,
          icon: Icons.archive_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final commentProvider = context.watch<CommentProvider>();
    final post = postProvider.selectedPost;
    final cs = Theme.of(context).colorScheme;

    if (postProvider.isLoading || post == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(title: Text('Post Detail', style: AppTextStyles.appBarTitle)),
        body: const LoadingIndicator(message: 'Loading article…'),
      );
    }

    final statusStyle = _statusStyle(post.status);
    final postComments = commentProvider.comments
        .where((c) => c.postId == post.id.toString())
        .toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Post Detail', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Post',
            onPressed: () => context.push(AppRoutes.postEditPath(post.id)),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Meta badges row ─────────────────────────────────────────
                  Row(
                    children: [
                      // Category Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          post.category,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusStyle.bg,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusStyle.icon,
                              size: 13,
                              color: statusStyle.fg,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.status.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: statusStyle.fg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Title ───────────────────────────────────────────────────
                  Text(
                    post.title,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: cs.onSurface,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Meta stats (date, views, comments) ──────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: AppSpacing.iconSm,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat('MMM d, yyyy').format(post.createdAt),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Icon(
                          Icons.visibility_outlined,
                          size: AppSpacing.iconSm,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${post.views} views',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: AppSpacing.iconSm,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${post.commentsCount} comments',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Excerpt Lead Box ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: const Border(
                        left: BorderSide(color: AppColors.primary, width: 4),
                      ),
                    ),
                    child: Text(
                      post.excerpt,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: cs.onSurface,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Content ─────────────────────────────────────────────────
                  Text(
                    post.content,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: cs.onSurface,
                      height: 1.7,
                    ),
                  ),

                  // ── Tags ────────────────────────────────────────────────────
                  if (post.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'TAGS',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: post.tags.map((tag) {
                        return Chip(
                          label: Text('#$tag'),
                          labelStyle: AppTextStyles.labelMedium.copyWith(
                            color: cs.onSurface,
                          ),
                          backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            side: BorderSide(
                              color: cs.outline.withValues(alpha: 0.2),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxxl),
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Comments Preview ────────────────────────────────────────
                  SectionHeader(
                    title: 'Comments (${postComments.length})',
                    actionLabel: 'All Comments',
                    onAction: () => context.push(AppRoutes.comments),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (commentProvider.isLoading && postComments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (postComments.isEmpty)
                    EmptyState(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'No comments yet',
                      subtitle: 'Be the first to hear reader thoughts when they comment.',
                    )
                  else
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: postComments.take(3).length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final comment = postComments[index];
                          return CommentTile(
                            comment: comment,
                            showPostTitle: false,
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: AppSpacing.massive),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
