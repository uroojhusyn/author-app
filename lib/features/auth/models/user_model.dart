/// Matches the JSON returned by:
///   POST /api/login  → { user: {...}, token: "..." }
///   GET  /api/me     → { id, name, email, image, bio, user_type, ... }
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;   // avatar_url accessor from User model
  final String? bio;
  final String? token;       // Sanctum personal access token
  final int userType;        // 1 = admin, 2 = author
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.token,
    required this.userType,
    this.createdAt,
  });

  bool get isAdmin  => userType == 1;
  bool get isAuthor => userType == 2;

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    // /api/login: { "user": { ... }, "token": "..." }
    // /api/me:    { "data": { ... } }
    dynamic target = json['user'] ?? json['data'] ?? json;
    if (target is Map<String, dynamic> &&
        target.containsKey('data') &&
        target['data'] is Map<String, dynamic>) {
      target = target['data'];
    }
    final Map<String, dynamic> u =
        (target is Map<String, dynamic>) ? target : json;

    return UserModel(
      id: int.tryParse(u['id']?.toString() ?? '') ?? 0,
      name: (u['name'] as String?) ?? '',
      email: (u['email'] as String?) ?? '',
      avatarUrl: (u['avatar'] ?? u['avatar_url']) as String?,
      bio: (u['about'] ?? u['bio']) as String?,
      token: token ?? (json['token'] as String?) ?? (u['token'] as String?),
      userType: int.tryParse((u['role'] ?? u['user_type'])?.toString() ?? '') ?? 2,
      createdAt: DateTime.tryParse(u['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id':        id,
    'name':      name,
    'email':     email,
    'avatar_url': avatarUrl,
    'bio':       bio,
    'user_type': userType,
  };
}

