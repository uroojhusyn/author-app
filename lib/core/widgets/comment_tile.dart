import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../features/comments/models/comment_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable tile that renders a [CommentModel].
/// Shows avatar initials (or image), author, timestamp, post title, content,
/// and a like count. All colours come from the ambient theme or [AppColors].
class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;
  final bool showPostTitle;

  const CommentTile({
    super.key,
    required this.comment,
    this.onTap,
    this.onDeleteTap,
    this.showPostTitle = true,
  });

  String get _initials {
    final parts = comment.authorName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return comment.authorName.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ─────────────────────────────────────────────────────
            _Avatar(
              initials: _initials,
              imageUrl: comment.authorAvatar,
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author + timestamp + delete button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.authorName,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: cs.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        DateFormat('MMM d').format(comment.createdAt),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      if (onDeleteTap != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        InkWell(
                          onTap: onDeleteTap,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              size: AppSpacing.iconSm,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Post title (secondary context)
                  if (showPostTitle && comment.postTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'on "${comment.postTitle}"',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xs),

                  // Comment body
                  Text(
                    comment.content,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Likes
                  if (comment.likes > 0) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: AppSpacing.iconSm,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          comment.likes.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private avatar widget ──────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initials;
  final String? imageUrl;

  const _Avatar({required this.initials, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: AppSpacing.avatarSm / 2,  // 16 → 32 diameter
      backgroundColor: AppColors.primaryContainer,
      backgroundImage:
          imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Text(
              initials,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            )
          : null,
    );
  }
}
