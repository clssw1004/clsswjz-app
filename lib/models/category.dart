class Category {
  final String id;
  final String name;
  final String accountBookId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.accountBookId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'accountBookId': accountBookId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        accountBookId: json['accountBookId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Category copyWith({
    String? id,
    String? name,
    String? accountBookId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        accountBookId: accountBookId ?? this.accountBookId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
