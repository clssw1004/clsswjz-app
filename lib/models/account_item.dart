import 'package:intl/intl.dart';

import 'attachment.dart';

class AccountItemResponse {
  final List<AccountItem> items;
  final AccountSummary summary;
  final Pagination pagination;

  AccountItemResponse({
    required this.items,
    required this.summary,
    required this.pagination,
  });

  factory AccountItemResponse.fromJson(Map<String, dynamic> json) =>
      AccountItemResponse(
        items: (json['items'] as List)
            .map((item) => AccountItem.fromJson(item))
            .toList(),
        summary: AccountSummary.fromJson(json['summary']),
        pagination: Pagination.fromJson(json['pagination']),
      );
}

class Pagination {
  final bool isLastPage;
  final int current;
  final int pageSize;
  final int total;
  final int totalPage;
  Pagination({
    required this.isLastPage,
    required this.current,
    required this.pageSize,
    required this.total,
    required this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        isLastPage: json['isLastPage'],
        current: json['current'],
        pageSize: json['pageSize'],
        total: json['total'],
        totalPage: json['totalPage'],
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
  final double amount;
  final String description;
  final String type;
  final String category;
  final String accountDate;
  final String accountBookId;
  final String? fundId;
  final String? fund;
  final String? shop;
  final String? createdBy;
  final String? createdByName;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final List<Attachment> attachments;
  final List<String>? deleteAttachmentIds;

  const AccountItem({
    required this.id,
    required this.amount,
    required this.description,
    required this.type,
    required this.category,
    required this.accountDate,
    required this.accountBookId,
    this.fundId,
    this.fund,
    this.shop,
    this.createdBy,
    this.createdByName,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.attachments = const [],
    this.deleteAttachmentIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'description': description,
        'type': type,
        'category': category,
        'accountDate': accountDate,
        'accountBookId': accountBookId,
        'fundId': fundId,
        'fund': fund,
        'shop': shop,
        'createdBy': createdBy,
        'createdByName': createdByName,
        'updatedBy': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'attachments': attachments.map((e) => e.toJson()).toList(),
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
        'accountDate': accountDate,
      };

  Map<String, dynamic> toJsonCreate() => {
        'accountBookId': accountBookId,
        'type': type,
        'amount': amount,
        'category': category,
        'description': description,
        'shop': shop,
        'fundId': fundId,
        'accountDate': accountDate,
      };

  factory AccountItem.fromJson(Map<String, dynamic> json) {
    return AccountItem(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      type: json['type'] as String,
      category: json['category'] as String,
      accountDate: json['accountDate'] as String,
      accountBookId: json['accountBookId'] as String,
      fundId: json['fundId'] as String?,
      fund: json['fund'] as String?,
      shop: json['shop'] as String?,
      createdBy: json['createdBy'] as String?,
      createdByName: json['createdByName'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  AccountItem copyWith({
    String? id,
    String? accountBookId,
    String? type,
    double? amount,
    String? category,
    String? description,
    String? shop,
    String? fundId,
    String? fund,
    String? accountDate,
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
        fund: fund ?? this.fund,
        accountDate: accountDate ?? this.accountDate,
        createdBy: createdBy,
        createdByName: createdByName,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
        attachments: attachments,
      );
}
