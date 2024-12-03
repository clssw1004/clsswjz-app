class Fund {
  final String id;
  final String name;
  final String accountBookId;
  final String type; // cash, bank, alipay, wechat, etc.
  final double balance;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Fund({
    required this.id,
    required this.name,
    required this.accountBookId,
    required this.type,
    required this.balance,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'accountBookId': accountBookId,
        'type': type,
        'balance': balance,
        'isDefault': isDefault,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Fund.fromJson(Map<String, dynamic> json) => Fund(
        id: json['id'],
        name: json['name'],
        accountBookId: json['accountBookId'],
        type: json['type'],
        balance: json['balance'].toDouble(),
        isDefault: json['isDefault'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Fund copyWith({
    String? id,
    String? name,
    String? accountBookId,
    String? type,
    double? balance,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Fund(
        id: id ?? this.id,
        name: name ?? this.name,
        accountBookId: accountBookId ?? this.accountBookId,
        type: type ?? this.type,
        balance: balance ?? this.balance,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
