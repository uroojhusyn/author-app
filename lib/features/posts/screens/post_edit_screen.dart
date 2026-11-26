import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';

class PostEditScreen extends StatefulWidget {
  final String postId;

  const PostEditScreen({super.key, required this.postId});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _excerptController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;

  String _selectedCategory = 'Backend';
  String _selectedStatus = 'draft';
  bool _initialized = false;

  final List<String> _categories = [
    'Backend',
    'Mobile',
    'UI/UX',
    'Database',
    'Security',
    'DevOps',
  ];
  final List<String> _statuses = ['draft', 'published', 'archived'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _excerptController = TextEditingController();
    _contentController = TextEditingController();
    _tagsController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final postProvider = context.read<PostProvider>();
      await postProvider.fetchPostById(widget.postId);
      final post = postProvider.selectedPost;
      if (post != null && mounted) {
        setState(() {
          _titleController.text = post.title;
          _excerptController.text = post.excerpt;
          _contentController.text = post.content;
          _tagsController.text = post.tags.join(', ');
          _selectedCategory =
              _categories.contains(post.category) ? post.category : _categories.first;
          _selectedStatus = post.status;
          _initialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit(PostModel originalPost, [String? overrideStatus]) async {
    if (overrideStatus != null) {
      _selectedStatus = overrideStatus;
    }
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final updatedPost = originalPost.copyWith(
      title: _titleController.text.trim(),
      excerpt: _excerptController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
      tags: tags,
      status: _selectedStatus,
    );

    final messenger = ScaffoldMessenger.of(context);
    final success = await context.read<PostProvider>().updatePost(updatedPost);
    if (mounted && success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Post updated successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final post = postProvider.selectedPost;
    final cs = Theme.of(context).colorScheme;

    if (!_initialized || post == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(title: Text('Edit Post', style: AppTextStyles.appBarTitle)),
        body: const LoadingIndicator(message: 'Loading post details…'),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Edit Post', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save Changes',
            onPressed: postProvider.isLoading ? null : () => _submit(post),
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
                    // ── Title Field ──────────────────────────────────────────
                    CustomTextField(
                      controller: _titleController,
                      label: 'Post Title',
                      hint: 'Article title…',
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
                              DropdownButtonFormField<String>(
                                initialValue: _selectedCategory,
                                items: _categories
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat, style: AppTextStyles.bodyMedium),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCategory = val);
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
                                'Post Status',
                                style: AppTextStyles.fieldLabel.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs + 2),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedStatus,
                                items: _statuses
                                    .map(
                                      (st) => DropdownMenuItem(
                                        value: st,
                                        child: Text(
                                          st.toUpperCase(),
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedStatus = val);
                                },
                              ),
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
                      hint: 'A concise 1-2 sentence overview…',
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
                      hint: 'Full article text…',
                      maxLines: 8,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Content is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── Save Button ──────────────────────────────────────────
                    CustomButton(
                      label: 'Save Changes',
                      icon: Icons.check_circle_outline_rounded,
                      variant: ButtonVariant.filled,
                      isLoading: postProvider.isLoading,
                      onPressed: postProvider.isLoading ? null : () => _submit(post),
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
