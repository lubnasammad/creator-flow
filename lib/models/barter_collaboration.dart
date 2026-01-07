class BarterCollaboration {
  final int? id;
  final int userId;
  final String brandName;
  final String? description;
  final double productValue;
  final String startDate;
  final String endDate;
  final String status;
  final String createdAt;

  const BarterCollaboration({
    this.id,
    required this.userId,
    required this.brandName,
    this.description,
    required this.productValue,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'brand_name': brandName,
      'description': description,
      'product_value': productValue,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory BarterCollaboration.fromMap(Map<String, dynamic> map) {
    return BarterCollaboration(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      brandName: map['brand_name'] as String,
      description: map['description'] as String?,
      productValue: map['product_value'] as double,
      startDate: map['start_date'] as String,
      endDate: map['end_date'] as String,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  BarterCollaboration copyWith({
    int? id,
    int? userId,
    String? brandName,
    String? description,
    double? productValue,
    String? startDate,
    String? endDate,
    String? status,
    String? createdAt,
  }) {
    return BarterCollaboration(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brandName: brandName ?? this.brandName,
      description: description ?? this.description,
      productValue: productValue ?? this.productValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
