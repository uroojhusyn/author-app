/// Matches the shape of BlogHub /api/profile GET response and
/// the PUT body it expects.
///
/// BlogHub User fields used here:
///   name, email, bio, image (avatar), contact (phone/location), website, designation
///   Approved posts count comes from author.approved_posts_count
class ProfileModel {
  final int id;
  final String name;
  final String title;    // designation / job title
  final String email;
  final String? avatar;
  final String bio;
  final String contact;  // phone number
  final String location; // location / city
  final String website;
  final String twitter;
  final String github;
  final int articles;
  final int followers;
  final int totalViews;

  int get totalReads => totalViews;

  ProfileModel({
    required this.id,
    required this.name,
    required this.title,
    required this.email,
    this.avatar,
    required this.bio,
    required this.contact,
    this.location = '',
    required this.website,
    required this.twitter,
    required this.github,
    required this.articles,
    this.followers = 0,
    required this.totalViews,
  });

  /// Parses BlogHub /api/profile response
  factory ProfileModel.fromBlogHubJson(Map<String, dynamic> json) {
    final contactStr = json['contact'] as String? ?? '';
    final locStr = json['location'] as String? ?? contactStr;
    return ProfileModel(
      id:          (json['id'] as num?)?.toInt() ?? 0,
      name:        json['name'] as String? ?? '',
      title:       json['designation'] as String? ?? 'Author',
      email:       json['email'] as String? ?? '',
      avatar:      json['avatar_url'] as String?,
      bio:         json['bio'] as String? ?? '',
      contact:     contactStr,
      location:    locStr,
      website:     json['website'] as String? ?? '',
      twitter:     json['twitter'] as String? ?? '',
      github:      json['github'] as String? ?? '',
      articles:    (json['approved_posts_count'] as num?)?.toInt() ?? 0,
      followers:   (json['followers_count'] as num?)?.toInt() ?? 0,
      totalViews:  (json['total_views'] as num?)?.toInt() ?? 0,
    );
  }

  /// Legacy mock-compatible parser
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final loc = json['location'] as String? ?? json['contact'] as String? ?? '';
    return ProfileModel(
      id:         int.tryParse(json['id'].toString()) ?? 0,
      name:       json['name'] as String? ?? '',
      title:      json['title'] as String? ?? json['designation'] as String? ?? 'Author',
      email:      json['email'] as String? ?? '',
      avatar:     json['avatar'] as String? ?? json['avatar_url'] as String?,
      bio:        json['bio'] as String? ?? '',
      contact:    json['contact'] as String? ?? loc,
      location:   loc,
      website:    json['website'] as String? ?? '',
      twitter:    json['twitter'] as String? ?? '',
      github:     json['github'] as String? ?? '',
      articles:   stats['articles'] as int? ?? (json['approved_posts_count'] as num?)?.toInt() ?? 0,
      followers:  stats['followers'] as int? ?? 0,
      totalViews: stats['totalReads'] as int? ?? stats['totalViews'] as int? ?? (json['total_views'] as num?)?.toInt() ?? 0,
    );
  }

  /// Body for PUT /api/profile
  Map<String, dynamic> toBlogHubJson() => {
    'name':        name,
    'bio':         bio,
    'contact':     location.isNotEmpty ? location : contact,
    'website':     website,
    'twitter':     twitter,
    'github':      github,
    'designation': title,
  };

  ProfileModel copyWith({
    int? id,
    String? name,
    String? title,
    String? email,
    String? avatar,
    String? bio,
    String? contact,
    String? location,
    String? website,
    String? twitter,
    String? github,
    int? articles,
    int? followers,
    int? totalViews,
  }) {
    return ProfileModel(
      id:         id ?? this.id,
      name:       name ?? this.name,
      title:      title ?? this.title,
      email:      email ?? this.email,
      avatar:     avatar ?? this.avatar,
      bio:        bio ?? this.bio,
      contact:    contact ?? this.contact,
      location:   location ?? this.location,
      website:    website ?? this.website,
      twitter:    twitter ?? this.twitter,
      github:     github ?? this.github,
      articles:   articles ?? this.articles,
      followers:  followers ?? this.followers,
      totalViews: totalViews ?? this.totalViews,
    );
  }
}
