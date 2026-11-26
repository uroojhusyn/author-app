import '../../../mock_data/mock_comments.dart';
import '../models/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>> getComments({String? postId});
  Future<bool> deleteComment(dynamic id);
}

class MockCommentRepository implements CommentRepository {
  late List<CommentModel> _comments;

  MockCommentRepository() {
    _comments = MockCommentsData.comments.map((json) => CommentModel.fromJson(json)).toList();
  }

  @override
  Future<List<CommentModel>> getComments({String? postId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (postId != null && postId.isNotEmpty) {
      return _comments.where((c) => c.postId == postId).toList();
    }
    return List<CommentModel>.from(_comments);
  }

  @override
  Future<bool> deleteComment(dynamic id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final targetId = id is int ? id : (int.tryParse(id.toString()) ?? 0);
    final before = _comments.length;
    _comments.removeWhere((c) => c.id == targetId);
    return _comments.length < before;
  }
}
