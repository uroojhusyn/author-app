import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/comment_tile.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../providers/comment_provider.dart';

class CommentsListScreen extends StatelessWidget {
  const CommentsListScreen({super.key});

  void _confirmDelete(BuildContext context, dynamic commentId) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text(
          'Delete Comment',
          style: AppTextStyles.titleMedium.copyWith(color: cs.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete this comment? This cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            onPressed: () async {
              ctx.pop();
              final provider = context.read<CommentProvider>();
              final messenger = ScaffoldMessenger.of(context);
              final success = await provider.deleteComment(commentId);
              if (context.mounted && success) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Comment deleted successfully')),
                );
              }
            },
            child: Text('Delete', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<CommentProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Reader Comments', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Comments',
            onPressed: () => commentProvider.fetchComments(),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: commentProvider.isLoading && commentProvider.comments.isEmpty
          ? const LoadingIndicator(message: 'Loading reader comments…')
          : commentProvider.comments.isEmpty
              ? EmptyState(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'No comments yet',
                  subtitle:
                      'When readers discuss and react to your articles, their feedback appears here.',
                  actionLabel: 'Refresh',
                  onAction: () => commentProvider.fetchComments(),
                )
              : RefreshIndicator(
                  onRefresh: () => commentProvider.fetchComments(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                      vertical: AppSpacing.md,
                    ),
                    itemCount: commentProvider.comments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final comment = commentProvider.comments[index];
                      return Card(
                        child: CommentTile(
                          comment: comment,
                          showPostTitle: true,
                          onDeleteTap: () => _confirmDelete(context, comment.id),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
