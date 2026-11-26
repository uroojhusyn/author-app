import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedCategory = 'Backend';
  int _selectedCategoryId = 1;
  bool _submitForReview = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Backend',  'id': 1},
    {'name': 'Mobile',   'id': 2},
    {'name': 'UI/UX',    'id': 3},
    {'name': 'Security', 'id': 4},
    {'name': 'Database', 'id': 5},
    {'name': 'DevOps',   'id': 6},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit([bool submitForReview = false]) async {
    _submitForReview = submitForReview;
    if (!_formKey.currentState!.validate()) return;

    final newPost = PostModel(
      id: 0,
      title: _titleController.text.trim(),
      slug: '',
      excerpt: _excerptController.text.trim(),
      content: _contentController.text.trim(),
      categoryName: _selectedCategory,
      categoryId: _selectedCategoryId,
      imageUrl: '',
      statusCode: submitForReview ? 3 : 2,
      statusLabel: submitForReview ? 'Pending Review' : 'Draft',
      viewsCount: 0,
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      isTrending: false,
      readTime: '1 min read',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final messenger = ScaffoldMessenger.of(context);
    final success = await context.read<PostProvider>().createPost(
      newPost,
      submitForReview: submitForReview,
    );
    if (mounted && success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            submitForReview
                ? 'Post submitted for review!'
                : 'Draft saved successfully!',
          ),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Create Post', style: AppTextStyles.appBarTitle),
        actions: [
          TextButton(
            onPressed: postProvider.isLoading ? null : () => _submit(true),
            child: Text(
              'Publish',
              style: AppTextStyles.button.copyWith(
                color: postProvider.isLoading ? cs.onSurfaceVariant : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
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
                    // ── Title Field ──────────────────────────────────────────
                    CustomTextField(
                      controller: _titleController,
                      label: 'Post Title',
                      hint: 'Enter a compelling article headline…',
                      prefixIcon: Icons.title_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Category & Status Dropdowns ──────────────────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category',
                                style: AppTextStyles.fieldLabel.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs + 2),
                              DropdownButtonFormField<Map<String, dynamic>>(
                                initialValue: _categories.firstWhere((c) => c['name'] == _selectedCategory),
                                items: _categories
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat['name'] as String, style: AppTextStyles.bodyMedium),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCategory = val['name'] as String;
                                      _selectedCategoryId = val['id'] as int;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Initial Status',
                                style: AppTextStyles.fieldLabel.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs + 2),
                              // Status is managed by the action buttons
                              // Draft = Save button, Pending = Publish button
                              const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Excerpt / Summary ────────────────────────────────────
                    CustomTextField(
                      controller: _excerptController,
                      label: 'Summary / Excerpt',
                      hint: 'A concise 1-2 sentence overview for the card preview…',
                      prefixIcon: Icons.short_text_rounded,
                      maxLines: 2,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Excerpt is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Tags Field ───────────────────────────────────────────
                    CustomTextField(
                      controller: _tagsController,
                      label: 'Tags (comma-separated)',
                      hint: 'e.g. Flutter, Clean Architecture, Mobile',
                      prefixIcon: Icons.tag_rounded,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Content Area ─────────────────────────────────────────
                    CustomTextField(
                      controller: _contentController,
                      label: 'Article Content',
                      hint: 'Write your full post story and technical details here…',
                      maxLines: 8,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Content is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── Action Buttons ───────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: 'Save as Draft',
                            icon: Icons.edit_note_rounded,
                            variant: ButtonVariant.outlined,
                            isLoading: postProvider.isLoading && !_submitForReview,
                            onPressed: postProvider.isLoading ? null : () => _submit(false),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: CustomButton(
                            label: 'Publish Post',
                            icon: Icons.send_rounded,
                            variant: ButtonVariant.filled,
                            isLoading: postProvider.isLoading && _submitForReview,
                            onPressed: postProvider.isLoading ? null : () => _submit(true),
                          ),
                        ),
                      ],
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
