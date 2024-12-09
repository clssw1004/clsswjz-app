class Category {
  final String id;
  final String name;
  final String accountBookId;
  final String categoryType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.accountBookId,
    this.categoryType = 'EXPENSE',
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      accountBookId: json['accountBookId'],
      categoryType: json['categoryType'] ?? 'EXPENSE',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountBookId': accountBookId,
      'categoryType': categoryType,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'name': name,
      'accountBookId': accountBookId,
      'categoryType': categoryType,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? accountBookId,
    String? categoryType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      accountBookId: accountBookId ?? this.accountBookId,
      categoryType: categoryType ?? this.categoryType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
