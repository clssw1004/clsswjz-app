class Shop {
  final String id;
  final String name;
  final String accountBookId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop({
    required this.id,
    required this.name,
    required this.accountBookId,
    required this.createdAt,
    required this.updatedAt,
  });

  Shop copyWith({
    String? id,
    String? name,
    String? accountBookId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      accountBookId: accountBookId ?? this.accountBookId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'accountBookId': accountBookId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json['id'],
        name: json['name'],
        accountBookId: json['accountBookId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
