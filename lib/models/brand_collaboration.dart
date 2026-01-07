class BrandCollaboration {
  final int? id;
  final int userId;
  final String brandName;
  final String? description;
  final String startDate;
  final String endDate;
  final double payment;
  final String status;
  final String createdAt;

  const BrandCollaboration({
    this.id,
    required this.userId,
    required this.brandName,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.payment,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'brand_name': brandName,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'payment': payment,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory BrandCollaboration.fromMap(Map<String, dynamic> map) {
    return BrandCollaboration(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      brandName: map['brand_name'] as String,
      description: map['description'] as String?,
      startDate: map['start_date'] as String,
      endDate: map['end_date'] as String,
      payment: map['payment'] as double,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  BrandCollaboration copyWith({
    int? id,
    int? userId,
    String? brandName,
    String? description,
    String? startDate,
    String? endDate,
    double? payment,
    String? status,
    String? createdAt,
  }) {
    return BrandCollaboration(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brandName: brandName ?? this.brandName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      payment: payment ?? this.payment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
