class PostingSchedule {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final String postDate;
  final String platform;
  final String status;
  final String createdAt;

  const PostingSchedule({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.postDate,
    required this.platform,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'post_date': postDate,
      'platform': platform,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory PostingSchedule.fromMap(Map<String, dynamic> map) {
    return PostingSchedule(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      postDate: map['post_date'] as String,
      platform: map['platform'] as String,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  PostingSchedule copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? postDate,
    String? platform,
    String? status,
    String? createdAt,
  }) {
    return PostingSchedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      postDate: postDate ?? this.postDate,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
