class AccountItem {
  final String id;
  final String accountBookId;
  final String type;
  final double amount;
  final String category;
  final String? description;
  final String? shop;
  final String? fundId;
  final DateTime accountDate;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountItem({
    required this.id,
    required this.accountBookId,
    required this.type,
    required this.amount,
    required this.category,
    this.description,
    this.shop,
    this.fundId,
    required this.accountDate,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'accountBookId': accountBookId,
        'type': type,
        'amount': amount,
        'category': category,
        'description': description,
        'shop': shop,
        'fundId': fundId,
        'accountDate': accountDate.toIso8601String(),
      };

  factory AccountItem.fromJson(Map<String, dynamic> json) => AccountItem(
        id: json['id'],
        accountBookId: json['accountBookId'],
        type: json['type'],
        amount: json['amount'].toDouble(),
        category: json['category'],
        description: json['description'],
        shop: json['shop'],
        fundId: json['fundId'],
        accountDate: DateTime.parse(json['accountDate']),
        createdBy: json['createdBy'],
        updatedBy: json['updatedBy'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );

  AccountItem copyWith({
    String? id,
    String? accountBookId,
    String? type,
    double? amount,
    String? category,
    String? description,
    String? shop,
    String? fundId,
    DateTime? accountDate,
  }) =>
      AccountItem(
        id: id ?? this.id,
        accountBookId: accountBookId ?? this.accountBookId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        description: description ?? this.description,
        shop: shop ?? this.shop,
        fundId: fundId ?? this.fundId,
        accountDate: accountDate ?? this.accountDate,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
