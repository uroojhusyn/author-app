import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/profile_model.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _githubController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _websiteController = TextEditingController();
    _githubController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = context.read<ProfileProvider>().profile;
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile.name;
          _titleController.text = profile.title;
          _bioController.text = profile.bio;
          _locationController.text = profile.location;
          _websiteController.text = profile.website;
          _githubController.text = profile.github;
          _initialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _submit(ProfileModel current) async {
    if (!_formKey.currentState!.validate()) return;

    final updated = current.copyWith(
      name: _nameController.text.trim(),
      title: _titleController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
      website: _websiteController.text.trim(),
      github: _githubController.text.trim(),
    );

    final messenger = ScaffoldMessenger.of(context);
    final success = await context.read<ProfileProvider>().updateProfile(updated);
    if (mounted && success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profile;
    final cs = Theme.of(context).colorScheme;

    if (!_initialized || profile == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(title: Text('Edit Profile', style: AppTextStyles.appBarTitle)),
        body: const LoadingIndicator(message: 'Loading profile…'),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save Profile',
            onPressed: profileProvider.isLoading ? null : () => _submit(profile),
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
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Basic Info Section ────────────────────────────────────
                    Text(
                      'PERSONAL DETAILS',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _nameController,
                      label: 'Author Name',
                      hint: 'Your full name…',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      controller: _titleController,
                      label: 'Professional Headline',
                      hint: 'e.g. Senior Mobile Architect & Tech Writer',
                      prefixIcon: Icons.badge_outlined,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Headline is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      controller: _bioController,
                      label: 'Author Bio',
                      hint: 'Tell your readers about your background, expertise and passion…',
                      prefixIcon: Icons.notes_rounded,
                      maxLines: 4,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Bio is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                    const Divider(),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Online Presence Section ───────────────────────────────
                    Text(
                      'LOCATION & LINKS',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _locationController,
                      label: 'Location',
                      hint: 'e.g. San Francisco, CA',
                      prefixIcon: Icons.location_on_outlined,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      controller: _websiteController,
                      label: 'Personal Website / Portfolio',
                      hint: 'https://yourwebsite.com',
                      prefixIcon: Icons.language_rounded,
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    CustomTextField(
                      controller: _githubController,
                      label: 'GitHub Profile',
                      hint: 'github.com/username',
                      prefixIcon: Icons.code_rounded,
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── Save Button ──────────────────────────────────────────
                    CustomButton(
                      label: 'Save Profile Changes',
                      icon: Icons.check_circle_outline_rounded,
                      isLoading: profileProvider.isLoading,
                      onPressed: profileProvider.isLoading ? null : () => _submit(profile),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
