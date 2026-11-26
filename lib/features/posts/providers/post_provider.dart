import 'package:flutter/foundation.dart';
import '../data/post_repository.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository repository;

  List<PostModel> _posts = [];
  PostModel? _selectedPost;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = 'all'; // all, published, draft, archived
  String _searchQuery = '';

  PostProvider({required this.repository}) {
    fetchPosts();
  }

  List<PostModel> get posts => _posts;
  PostModel? get selectedPost => _selectedPost;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  void setFilter(String filter) {
    _selectedFilter = filter;
    fetchPosts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posts = await repository.getPosts(
        status: _selectedFilter == 'all' ? null : _selectedFilter,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      );
    } catch (e) {
      _errorMessage = 'Failed to load posts: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPostById(dynamic id) async {
    final intId = id is int ? id : (int.tryParse(id.toString()) ?? 0);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedPost = await repository.getPostById(intId);
    } catch (e) {
      _errorMessage = 'Failed to load post details: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPost(PostModel post, {bool submitForReview = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.createPost(post, submitForReview: submitForReview);
      await fetchPosts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create post: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePost(PostModel post, {bool submitForReview = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await repository.updatePost(post, submitForReview: submitForReview);
      _selectedPost = updated;
      await fetchPosts();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update post: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePost(dynamic id) async {
    final intId = id is int ? id : (int.tryParse(id.toString()) ?? 0);
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await repository.deletePost(intId);
      if (success) {
        _posts.removeWhere((p) => p.id == intId);
        if (_selectedPost?.id == intId) {
          _selectedPost = null;
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to delete post: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
