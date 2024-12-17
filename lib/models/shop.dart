class Shop {
  final String id;
  final String name;
  final String? code;
  final String accountBookId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;

  Shop({
    required this.id,
    required this.name,
    this.code,
    required this.accountBookId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'accountBookId': accountBookId,
      };

  Map<String, dynamic> toJsonCreate() => {
        'name': name,
        'accountBookId': accountBookId,
      };

  Map<String, dynamic> toJsonUpdate() => {
        'name': name,
      };

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        accountBookId: json['accountBookId'],
        createdBy: json['createdBy'],
        updatedBy: json['updatedBy'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Shop copyWith({
    String? id,
    String? name,
    String? code,
    String? accountBookId,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      accountBookId: accountBookId ?? this.accountBookId,
      createdBy: createdBy,
      updatedBy: updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ShopOption {
  final String code;
  final String name;

  const ShopOption({
    required this.code,
    required this.name,
  });
}
