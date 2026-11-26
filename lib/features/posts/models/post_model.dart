/// Matches BlogHub API responses from:
///   GET  /api/my-posts        (MyPostResource)
///   GET  /api/my-posts/{id}   (MyPostResource)
///   POST /api/my-posts        (create)
///   PUT  /api/my-posts/{id}   (update)
///
/// BlogHub uses:
///   title / heading   → post title
///   excerpt / head_discription → excerpt / subtitle
///   body / sub_discription     → body content
///   status codes: 2=draft, 3=pending, 4=in_review, 5=approved, 6=rejected
class PostModel {
  final int id;
  final String title;        // title / heading
  final String slug;
  final String excerpt;      // excerpt / subtitle
  final String content;      // body / sub_discription
  final String categoryName; // category name
  final int categoryId;
  final String imageUrl;     // image / image_url
  final int statusCode;      // numeric status (2–6)
  final String statusLabel;  // human-readable
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isTrending;
  final String readTime;
  final String? rejectionReason;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Convenience getters for backwards compatibility
  String get category => categoryName;
  int get views => viewsCount;

  PostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.excerpt,
    required this.content,
    required this.categoryName,
    required this.categoryId,
    required this.imageUrl,
    required this.statusCode,
    required this.statusLabel,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isTrending,
    required this.readTime,
    this.rejectionReason,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Convenience getters matching BlogHub status codes
  bool get isDraft      => statusCode == 2;
  bool get isPending    => statusCode == 3;
  bool get isInReview   => statusCode == 4;
  bool get isApproved   => statusCode == 5;
  bool get isRejected   => statusCode == 6;

  /// Status string for filtering UI (maps to old mock field names)
  String get status => switch (statusCode) {
    2 => 'draft',
    3 => 'pending',
    4 => 'in_review',
    5 => 'approved',
    6 => 'rejected',
    _ => 'draft',
  };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedTags = [];
    if (json['tags'] is List) {
      parsedTags = (json['tags'] as List).map((e) => e.toString()).toList();
    } else if (json['tags'] is String && (json['tags'] as String).isNotEmpty) {
      parsedTags = (json['tags'] as String).split(',').map((e) => e.trim()).toList();
    }

    // Category can be a Map like {"id": 1, "name": "Technology"} or string or numeric
    String categoryName = 'General';
    int categoryId = 0;
    if (json['category'] is Map) {
      final cat = json['category'] as Map;
      categoryName = cat['name'] as String? ?? 'General';
      categoryId = (cat['id'] as num?)?.toInt() ?? 0;
    } else {
      categoryName = json['category_name'] as String?
                     ?? json['category'] as String? ?? 'General';
      categoryId = (json['categories'] as num?)?.toInt()
                   ?? (json['category_id'] as num?)?.toInt() ?? 0;
    }

    // Status code can be numeric 2..6 or mapped from string 'status_name' / 'status'
    int resolvedStatus = (json['status_code'] as num?)?.toInt() ?? 0;
    if (resolvedStatus == 0) {
      if (json['status'] is num) {
        resolvedStatus = (json['status'] as num).toInt();
      } else if (json['status_name'] is String) {
        resolvedStatus = switch ((json['status_name'] as String).toLowerCase()) {
          'draft' => 2,
          'pending' => 3,
          'in_review' => 4,
          'approved' => 5,
          'rejected' => 6,
          _ => 2,
        };
      } else if (json['status'] is String) {
        resolvedStatus = switch ((json['status'] as String).toLowerCase()) {
          'draft' => 2,
          'pending' => 3,
          'in_review' => 4,
          'approved' => 5,
          'rejected' => 6,
          _ => 2,
        };
      } else {
        resolvedStatus = 2;
      }
    }

    return PostModel(
      id:              (json['id'] as num).toInt(),
      title:           json['title'] as String?
                       ?? json['heading'] as String? ?? '',
      slug:            json['slug'] as String? ?? '',
      excerpt:         json['excerpt'] as String?
                       ?? json['head_discription'] as String?
                       ?? json['subtitle'] as String? ?? '',
      content:         json['body'] as String?
                       ?? json['sub_discription'] as String?
                       ?? json['content'] as String? ?? '',
      categoryName:    categoryName,
      categoryId:      categoryId,
      imageUrl:        json['image'] as String?
                       ?? json['image_url'] as String?
                       ?? json['img'] as String? ?? '',
      statusCode:      resolvedStatus,
      statusLabel:     json['status_label'] as String?
                       ?? _labelFor(resolvedStatus),
      viewsCount:      (json['views'] as num?)?.toInt()
                       ?? (json['views_count'] as num?)?.toInt() ?? 0,
      likesCount:      (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount:   (json['comments_count'] as num?)?.toInt() ?? 0,
      sharesCount:     (json['shares_count'] as num?)?.toInt() ?? 0,
      isTrending:      json['is_trending'] as bool? ?? false,
      readTime:        json['read_time'] as String? ?? '1 min read',
      rejectionReason: json['rejection_reason'] as String?,
      tags:            parsedTags,
      createdAt:       DateTime.tryParse(json['created_at'] as String? ?? '')
                       ?? DateTime.now(),
      updatedAt:       DateTime.tryParse(json['updated_at'] as String? ?? '')
                       ?? DateTime.now(),
    );
  }

  static String _labelFor(int code) => switch (code) {
    2 => 'Draft',
    3 => 'Pending Review',
    4 => 'In Review',
    5 => 'Approved',
    6 => 'Rejected',
    _ => 'Draft',
  };

  /// Builds the body map for POST /api/my-posts or PUT /api/my-posts/{id}.
  /// Status 3 = "published" (submitted for review), 2 = draft.
  Map<String, dynamic> toCreateJson({bool submitForReview = false}) => {
    'heading':          title,
    'head_discription': excerpt,
    'sub_discription':  content,
    'categories':       categoryId,
    'status':           submitForReview ? 3 : 2,
  };

  PostModel copyWith({
    int? id,
    String? title,
    String? slug,
    String? excerpt,
    String? content,
    String? categoryName,
    String? category,
    int? categoryId,
    String? imageUrl,
    int? statusCode,
    String? status,
    String? statusLabel,
    int? viewsCount,
    int? views,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isTrending,
    String? readTime,
    String? rejectionReason,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    int? resolvedStatusCode = statusCode;
    if (resolvedStatusCode == null && status != null) {
      resolvedStatusCode = switch (status.toLowerCase()) {
        'draft'     => 2,
        'pending'   => 3,
        'in_review' => 4,
        'approved'  => 5,
        'published' => 5,
        'rejected'  => 6,
        _           => 2,
      };
    }

    return PostModel(
      id:              id ?? this.id,
      title:           title ?? this.title,
      slug:            slug ?? this.slug,
      excerpt:         excerpt ?? this.excerpt,
      content:         content ?? this.content,
      categoryName:    categoryName ?? category ?? this.categoryName,
      categoryId:      categoryId ?? this.categoryId,
      imageUrl:        imageUrl ?? this.imageUrl,
      statusCode:      resolvedStatusCode ?? this.statusCode,
      statusLabel:     statusLabel ?? this.statusLabel,
      viewsCount:      viewsCount ?? views ?? this.viewsCount,
      likesCount:      likesCount ?? this.likesCount,
      commentsCount:   commentsCount ?? this.commentsCount,
      sharesCount:     sharesCount ?? this.sharesCount,
      isTrending:      isTrending ?? this.isTrending,
      readTime:        readTime ?? this.readTime,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      tags:            tags ?? this.tags,
      createdAt:       createdAt ?? this.createdAt,
      updatedAt:       updatedAt ?? this.updatedAt,
    );
  }
}
