import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A labelled section divider with an optional "see all" action link.
/// Used above list/grid sections on Dashboard, Posts, Comments, etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Accent line
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Title
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: AppTextStyles.sectionHeader.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),

            // Optional action
            if (actionLabel != null && onAction != null)
              GestureDetector(
                onTap: onAction,
                child: Text(
                  actionLabel!,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: cs.primary,
                  ),
                ),
              ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: AppSpacing.sm),
          Divider(
            height: 1,
            thickness: 1,
            color: cs.outlineVariant,
          ),
        ],
      ],
    );
  }
}
