import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/post_card.dart';
import '../providers/post_provider.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, dynamic postId) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text(
          'Delete Post',
          style: AppTextStyles.titleMedium.copyWith(color: cs.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
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
              final provider = context.read<PostProvider>();
              final messenger = ScaffoldMessenger.of(context);
              final success = await provider.deletePost(postId);
              if (mounted && success) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Post deleted successfully')),
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
    final postProvider = context.watch<PostProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('My Posts', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create Post',
            onPressed: () => context.push(AppRoutes.postCreate),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sm,
              AppSpacing.screenPadding,
              AppSpacing.xs,
            ),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Search by title, excerpt, category…',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: AppSpacing.iconMd,
                  color: cs.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: AppSpacing.iconSm),
                        onPressed: () {
                          _searchController.clear();
                          postProvider.setSearchQuery('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                postProvider.setSearchQuery(val);
                setState(() {});
              },
            ),
          ),

          // ── Filter Chips Row ────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _buildFilterChip('All Posts', 'all', postProvider, cs),
                _buildFilterChip('Published', 'published', postProvider, cs),
                _buildFilterChip('Drafts', 'draft', postProvider, cs),
                _buildFilterChip('Archived', 'archived', postProvider, cs),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Posts List ──────────────────────────────────────────────────────
          Expanded(
            child: postProvider.isLoading && postProvider.posts.isEmpty
                ? const LoadingIndicator(message: 'Loading posts…')
                : postProvider.posts.isEmpty
                    ? EmptyState(
                        icon: Icons.article_outlined,
                        title: _searchController.text.isNotEmpty
                            ? 'No matching posts'
                            : 'No posts yet',
                        subtitle: _searchController.text.isNotEmpty
                            ? 'Try searching with different keywords or clearing the filter.'
                            : 'Get started by creating your very first article.',
                        actionLabel: 'Create New Post',
                        onAction: () => context.push(AppRoutes.postCreate),
                      )
                    : RefreshIndicator(
                        onRefresh: () => postProvider.fetchPosts(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.screenPadding),
                          itemCount: postProvider.posts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final post = postProvider.posts[index];
                            return PostCard(
                              post: post,
                              onTap: () => context.push(AppRoutes.postDetailPath(post.id)),
                              onEditTap: () => context.push(AppRoutes.postEditPath(post.id)),
                              onDeleteTap: () => _confirmDelete(context, post.id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.postCreate),
        icon: const Icon(Icons.add_rounded),
        label: Text('New Post', style: AppTextStyles.button),
        tooltip: 'Create New Post',
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    PostProvider provider,
    ColorScheme cs,
  ) {
    final isSelected = provider.selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: isSelected ? Colors.white : cs.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          side: BorderSide(
            color: isSelected ? AppColors.primary : cs.outline.withValues(alpha: 0.3),
          ),
        ),
        onSelected: (_) => provider.setFilter(value),
      ),
    );
  }
}
