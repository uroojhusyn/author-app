/// Matches BlogHub GET /api/v1/posts/{id}/comments (CommentResource):
///   id, body, is_hidden, user: { id, name, avatar_url }, post_id, created_at
class CommentModel {
  final int id;
  final String postId;
  final String postTitle;
  final String authorName;
  final String? authorAvatar;
  final String content;     // body
  final bool isHidden;
  final int likes;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.postTitle,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.isHidden = false,
    this.likes = 0,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // BlogHub wraps user info under 'user' key
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return CommentModel(
      id:           (json['id'] as num?)?.toInt()
                    ?? int.tryParse(json['id'].toString()) ?? 0,
      postId:       (json['post_id'] ?? json['postId'] ?? '').toString(),
      postTitle:    json['post_title'] as String?
                    ?? json['postTitle'] as String? ?? 'Untitled Post',
      authorName:   user['name'] as String?
                    ?? json['authorName'] as String? ?? 'Anonymous',
      authorAvatar: user['avatar_url'] as String?
                    ?? json['authorAvatar'] as String?,
      content:      json['body'] as String?
                    ?? json['content'] as String? ?? '',
      isHidden:     json['is_hidden'] as bool? ?? false,
      likes:        (json['likes'] as num?)?.toInt() ?? 0,
      createdAt:    DateTime.tryParse(
                      json['created_at'] as String?
                      ?? json['createdAt'] as String? ?? '',
                    ) ?? DateTime.now(),
    );
  }
}
