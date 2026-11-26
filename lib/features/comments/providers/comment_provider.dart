import 'package:flutter/foundation.dart';
import '../data/comment_repository.dart';
import '../models/comment_model.dart';

class CommentProvider extends ChangeNotifier {
  final CommentRepository repository;

  List<CommentModel> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedPostFilter;

  CommentProvider({required this.repository}) {
    fetchComments();
  }

  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedPostFilter => _selectedPostFilter;

  Future<void> fetchComments({String? postId}) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedPostFilter = postId;
    notifyListeners();

    try {
      _comments = await repository.getComments(postId: postId);
    } catch (e) {
      _errorMessage = 'Failed to load comments: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteComment(dynamic id) async {
    final targetId = id is int ? id : (int.tryParse(id.toString()) ?? 0);
    _isLoading = true;
    notifyListeners();

    try {
      final success = await repository.deleteComment(targetId);
      if (success) {
        _comments.removeWhere((c) => c.id == targetId);
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to delete comment: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
