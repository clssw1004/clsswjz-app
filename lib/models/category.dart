class Category {
  final String id;
  final String name;
  final String accountBookId;
  final String categoryType;
  final String? createdAt;
  final String? updatedAt;

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
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountBookId': accountBookId,
      'categoryType': categoryType,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
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
    String? createdAt,
    String? updatedAt,
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
