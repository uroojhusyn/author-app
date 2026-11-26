import '../../../mock_data/mock_posts.dart';
import '../../../core/services/api/api_endpoints.dart';
import '../../../core/services/api/http_api_client.dart';
import '../models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts({String? status, String? searchQuery});
  Future<PostModel?> getPostById(int id);
  Future<PostModel> createPost(PostModel post, {bool submitForReview = false});
  Future<PostModel> updatePost(PostModel post, {bool submitForReview = false});
  Future<bool> deletePost(int id);
}

// ─────────────────────────────────────────────────────────────
// REAL implementation — calls BlogHub /api/my-posts
// ─────────────────────────────────────────────────────────────
class HttpPostRepository implements PostRepository {
  final HttpApiClient _api;

  HttpPostRepository({HttpApiClient? api}) : _api = api ?? HttpApiClient();

  List<PostModel> _parseList(dynamic data) {
    final list = (data is Map ? data['data'] : data) as List<dynamic>? ?? [];
    return list.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<PostModel>> getPosts({String? status, String? searchQuery}) async {
    final params = <String, dynamic>{};
    // BlogHub filters: status=2/3/4/5/6 or search=query
    if (status != null && status != 'all') {
      final code = switch (status) {
        'draft'     => '2',
        'pending'   => '3',
        'in_review' => '4',
        'approved'  => '5',
        'rejected'  => '6',
        _           => null,
      };
      if (code != null) params['status'] = code;
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      params['search'] = searchQuery.trim();
    }
    final response = await _api.get(ApiEndpoints.myPosts, queryParams: params);
    if (!response.success) throw Exception(response.message);
    return _parseList(response.data);
  }

  @override
  Future<PostModel?> getPostById(int id) async {
    final response = await _api.get(ApiEndpoints.myPostDetail(id));
    if (!response.success || response.data == null) return null;
    final data = response.data as Map<String, dynamic>;
    final postData = (data['data'] as Map<String, dynamic>?) ?? data;
    return PostModel.fromJson(postData);
  }

  @override
  Future<PostModel> createPost(PostModel post, {bool submitForReview = false}) async {
    final response = await _api.post(
      ApiEndpoints.myPosts,
      body: post.toCreateJson(submitForReview: submitForReview),
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Failed to create post');
    }
    final data = response.data as Map<String, dynamic>;
    return PostModel.fromJson((data['data'] as Map<String, dynamic>?) ?? data);
  }

  @override
  Future<PostModel> updatePost(PostModel post, {bool submitForReview = false}) async {
    final response = await _api.put(
      ApiEndpoints.myPostDetail(post.id),
      body: post.toCreateJson(submitForReview: submitForReview),
    );
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? 'Failed to update post');
    }
    final data = response.data as Map<String, dynamic>;
    return PostModel.fromJson((data['data'] as Map<String, dynamic>?) ?? data);
  }

  @override
  Future<bool> deletePost(int id) async {
    final response = await _api.delete(ApiEndpoints.myPostDetail(id));
    return response.success;
  }
}

// ─────────────────────────────────────────────────────────────
// MOCK implementation (kept for offline / UI testing)
// ─────────────────────────────────────────────────────────────
class MockPostRepository implements PostRepository {
  late List<PostModel> _posts;

  MockPostRepository() {
    _posts = MockPostsData.posts.map((data) => PostModel.fromJson(data)).toList();
  }

  @override
  Future<List<PostModel>> getPosts({String? status, String? searchQuery}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    var result = List<PostModel>.from(_posts);
    if (status != null && status.isNotEmpty && status != 'all') {
      result = result.where((p) => p.status.toLowerCase() == status.toLowerCase()).toList();
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((p) =>
        p.title.toLowerCase().contains(query) ||
        p.excerpt.toLowerCase().contains(query) ||
        p.categoryName.toLowerCase().contains(query)
      ).toList();
    }
    return result;
  }

  @override
  Future<PostModel?> getPostById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try { return _posts.firstWhere((p) => p.id == id); } catch (_) { return null; }
  }

  @override
  Future<PostModel> createPost(PostModel post, {bool submitForReview = false}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPost = post.copyWith(
      id: DateTime.now().millisecondsSinceEpoch,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _posts.insert(0, newPost);
    return newPost;
  }

  @override
  Future<PostModel> updatePost(PostModel post, {bool submitForReview = false}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      final updated = post.copyWith(updatedAt: DateTime.now());
      _posts[index] = updated;
      return updated;
    }
    throw Exception('Post not found');
  }

  @override
  Future<bool> deletePost(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final before = _posts.length;
    _posts.removeWhere((p) => p.id == id);
    return _posts.length < before;
  }
}

