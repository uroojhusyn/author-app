import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Forgot-password screen.
/// Sends a password-reset e-mail (mock). No auth provider changes needed —
/// the reset logic is a simple local simulation here.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulated network delay — replace with real reset call when backend ready
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding + AppSpacing.md,
              vertical: AppSpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _emailSent ? _buildSuccess(cs) : _buildForm(cs),
            ),
          ),
        ),
      ),
    );
  }

  // ── Success state ──────────────────────────────────────────────────────────
  Widget _buildSuccess(ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.successContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: AppColors.success,
            size: 40,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Check your inbox',
          style: AppTextStyles.headlineMedium.copyWith(color: cs.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We\'ve sent a password reset link to\n${_emailController.text.trim()}',
          style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        CustomButton(
          label: 'Back to Sign In',
          onPressed: () => context.pop(),
          variant: ButtonVariant.outlined,
          fullWidth: true,
        ),
      ],
    );
  }

  // ── Form state ─────────────────────────────────────────────────────────────
  Widget _buildForm(ColorScheme cs) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Logo ────────────────────────────────────────────────
          const Center(
            child: AppLogo(size: 68),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'Forgot password?',
            style: AppTextStyles.headlineMedium.copyWith(
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Enter your author email and we\'ll send you a link to reset your password.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          CustomTextField(
            controller: _emailController,
            label: 'Author Email',
            hint: 'sarah@bloghub.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xxl),

          CustomButton(
            label: 'Send Reset Link',
            onPressed: _handleSubmit,
            isLoading: _isLoading,
            icon: Icons.send_rounded,
            fullWidth: true,
          ),

          const SizedBox(height: AppSpacing.lg),

          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Back to Sign In',
                style: AppTextStyles.labelLarge.copyWith(
                  color: cs.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
