class ShootingSchedule {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final String shootingDate;
  final String? location;
  final String status;
  final String createdAt;

  const ShootingSchedule({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.shootingDate,
    this.location,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'shooting_date': shootingDate,
      'location': location,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory ShootingSchedule.fromMap(Map<String, dynamic> map) {
    return ShootingSchedule(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      shootingDate: map['shooting_date'] as String,
      location: map['location'] as String?,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  ShootingSchedule copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? shootingDate,
    String? location,
    String? status,
    String? createdAt,
  }) {
    return ShootingSchedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      shootingDate: shootingDate ?? this.shootingDate,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
