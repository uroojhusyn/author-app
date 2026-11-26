import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Full-screen or inline loading indicator.
/// Colour comes from the theme's [ProgressIndicatorThemeData].
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const LoadingIndicator({
    super.key,
    this.message,
    this.fullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            message!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    return fullScreen ? Center(child: content) : content;
  }
}
