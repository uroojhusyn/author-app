import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum ButtonVariant { filled, outlined, text, destructive }
enum ButtonSize { small, medium, large }

/// Primary reusable button for the BlogHub Authors design system (THEME.md Section 6).
/// Uses 8px radius, Author Studio Indigo (#4F46E5), and clean outlines.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.icon,
    this.fullWidth = true,
  });

  const CustomButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.medium,
  }) : variant = ButtonVariant.outlined;

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xxl,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xl,
        );
    }
  }

  double get _minHeight {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.large:
        return 52;
      case ButtonSize.medium:
        return 46;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.small:
        return 13;
      case ButtonSize.large:
        return 15;
      case ButtonSize.medium:
        return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 8px border radius per THEME.md Section 5 & 6
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    );

    final Size minSize = Size(fullWidth ? double.infinity : 0, _minHeight);

    final TextStyle labelStyle = AppTextStyles.button.copyWith(
      fontSize: _fontSize,
      fontWeight: FontWeight.w600,
    );

    switch (variant) {
      case ButtonVariant.outlined:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            backgroundColor: isDark ? AppColors.cardDark : Colors.white,
            side: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
            padding: _padding,
            minimumSize: minSize,
            shape: shape,
            textStyle: labelStyle,
            elevation: 0,
          ),
          child: _buildChild(
            context,
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        );

      case ButtonVariant.text:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.authorPrimary,
            padding: _padding,
            minimumSize: minSize,
            shape: shape,
            textStyle: labelStyle,
          ),
          child: _buildChild(context, AppColors.authorPrimary),
        );

      case ButtonVariant.destructive:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.statusDanger,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: _padding,
            minimumSize: minSize,
            shape: shape,
            textStyle: labelStyle,
          ),
          child: _buildChild(context, Colors.white),
        );

      case ButtonVariant.filled:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.authorPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: _padding,
            minimumSize: minSize,
            shape: shape,
            textStyle: labelStyle,
          ),
          child: _buildChild(context, Colors.white),
        );
    }
  }

  Widget _buildChild(BuildContext context, Color iconColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSpacing.iconSm + 2),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
