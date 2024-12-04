class Shop {
  final String id;
  final String name;
  final String? shopCode;
  final String accountBookId;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Shop({
    required this.id,
    required this.name,
    this.shopCode,
    required this.accountBookId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shopCode': shopCode,
        'accountBookId': accountBookId,
      };

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json['id'],
        name: json['name'],
        shopCode: json['shopCode'],
        accountBookId: json['accountBookId'],
        createdBy: json['createdBy'],
        updatedBy: json['updatedBy'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );

  Shop copyWith({
    String? id,
    String? name,
    String? shopCode,
    String? accountBookId,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      shopCode: shopCode ?? this.shopCode,
      accountBookId: accountBookId ?? this.accountBookId,
      createdBy: createdBy,
      updatedBy: updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
