import 'package:intl/intl.dart';

class AccountItemResponse {
  final List<AccountItem> items;
  final AccountSummary summary;

  AccountItemResponse({
    required this.items,
    required this.summary,
  });

  factory AccountItemResponse.fromJson(Map<String, dynamic> json) =>
      AccountItemResponse(
        items: (json['items'] as List)
            .map((item) => AccountItem.fromJson(item))
            .toList(),
        summary: AccountSummary.fromJson(json['summary']),
      );
}

class AccountSummary {
  final double allIn;
  final double allOut;
  final double allBalance;

  AccountSummary({
    required this.allIn,
    required this.allOut,
    required this.allBalance,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) => AccountSummary(
        allIn: (json['allIn'] as num).toDouble(),
        allOut: (json['allOut'] as num).toDouble(),
        allBalance: (json['allBalance'] as num).toDouble(),
      );
}

class AccountItem {
  final String id;
  final String accountBookId;
  final String type;
  final double amount;
  final String category;
  final String? description;
  final String? shop;
  final String? fundId;
  final String? fundName;
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
    this.fundName,
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
        'fundName': fundName,
        'accountDate': accountDate.toIso8601String(),
      };

  Map<String, dynamic> toJsonUpdate() => {
        'id': id,
        'accountBookId': accountBookId,
        'type': type,
        'amount': amount,
        'category': category,
        'description': description,
        'shop': shop,
        'fundId': fundId,
        'accountDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(accountDate),
      };

  Map<String, dynamic> toJsonCreate() => {
        'accountBookId': accountBookId,
        'type': type,
        'amount': amount,
        'category': category,
        'description': description,
        'shop': shop,
        'fundId': fundId,
        'accountDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(accountDate),
      };

  factory AccountItem.fromJson(Map<String, dynamic> json) => AccountItem(
        id: json['id'],
        accountBookId: json['accountBookId'],
        type: json['type'],
        amount: (json['amount'] as num).toDouble(),
        category: json['category'],
        description: json['description'],
        shop: json['shop'],
        fundId: json['fundId'],
        fundName: json['fundName'],
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
    String? fundName,
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
        fundName: fundName ?? this.fundName,
        accountDate: accountDate ?? this.accountDate,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
