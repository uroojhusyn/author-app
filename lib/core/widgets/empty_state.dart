import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

/// Full-page or inline empty-state illustration with optional CTA.
/// Colours come entirely from the ambient theme.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconXl + 8,
                color: cs.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              CustomButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
                size: ButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
