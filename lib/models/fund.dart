class UserFund {
  final String id;
  final String name;
  final String fundType;
  final String fundRemark;
  final double fundBalance;
  final List<FundBook> fundBooks;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserFund({
    required this.id,
    required this.name,
    required this.fundType,
    required this.fundRemark,
    required this.fundBalance,
    this.fundBooks = const [],
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fundType': fundType,
        'fundRemark': fundRemark,
        'fundBalance': fundBalance,
        'fundBooks': fundBooks.map((book) => book.toJson()).toList(),
      };

  Map<String, dynamic> toRequestCreateJson() => {
        'name': name,
        'fundType': fundType,
        'fundRemark': fundRemark,
        'fundBalance': fundBalance,
      };

  Map<String, dynamic> toRequestUpdateJson() => {
        'name': name,
        'fundType': fundType,
        'fundRemark': fundRemark,
        'fundBalance': fundBalance,
        'fundBooks': fundBooks.map((book) => book.toRequestJson()).toList(),
      };

  factory UserFund.fromJson(Map<String, dynamic> json) => UserFund(
        id: json['id'],
        name: json['name'],
        fundType: json['fundType'],
        fundRemark: json['fundRemark'],
        fundBalance: (json['fundBalance'] as num).toDouble(),
        fundBooks: (json['fundBooks'] as List?)
                ?.map((book) => FundBook.fromJson(book))
                .toList() ??
            [],
        createdBy: json['createdBy'],
        updatedBy: json['updatedBy'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );

  UserFund copyWith({
    String? id,
    String? name,
    String? fundType,
    String? fundRemark,
    double? fundBalance,
    List<FundBook>? fundBooks,
  }) =>
      UserFund(
        id: id ?? this.id,
        name: name ?? this.name,
        fundType: fundType ?? this.fundType,
        fundRemark: fundRemark ?? this.fundRemark,
        fundBalance: fundBalance ?? this.fundBalance,
        fundBooks: fundBooks ?? this.fundBooks,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

class FundBook {
  final String accountBookId;
  final String accountBookName;
  final bool fundIn;
  final bool fundOut;
  final bool isDefault;

  FundBook({
    required this.accountBookId,
    required this.accountBookName,
    this.fundIn = true,
    this.fundOut = true,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'accountBookId': accountBookId,
        'accountBookName': accountBookName,
        'fundIn': fundIn,
        'fundOut': fundOut,
        'isDefault': isDefault,
      };

  Map<String, dynamic> toRequestJson() => {
        'accountBookId': accountBookId,
        'fundIn': fundIn,
        'fundOut': fundOut,
        'isDefault': isDefault,
      };

  factory FundBook.fromJson(Map<String, dynamic> json) => FundBook(
        accountBookId: json['accountBookId'],
        accountBookName: json['accountBookName'],
        fundIn: json['fundIn'] ?? true,
        fundOut: json['fundOut'] ?? true,
        isDefault: json['isDefault'] ?? false,
      );

  FundBook copyWith({
    String? accountBookId,
    String? accountBookName,
    bool? fundIn,
    bool? fundOut,
    bool? isDefault,
  }) {
    return FundBook(
      accountBookId: accountBookId ?? this.accountBookId,
      accountBookName: accountBookName ?? this.accountBookName,
      fundIn: fundIn ?? this.fundIn,
      fundOut: fundOut ?? this.fundOut,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AccountBookFund {
  final String id;
  final String name;
  final String fundType;
  final String fundRemark;
  final double fundBalance;
  final bool fundIn;
  final bool fundOut;
  final bool isDefault;
  final String accountBookName;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountBookFund({
    required this.id,
    required this.name,
    required this.fundType,
    required this.fundRemark,
    required this.fundBalance,
    this.fundIn = true,
    this.fundOut = true,
    this.isDefault = false,
    required this.accountBookName,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fundType': fundType,
        'fundRemark': fundRemark,
        'fundBalance': fundBalance,
        'fundIn': fundIn,
        'fundOut': fundOut,
        'isDefault': isDefault,
        'accountBookName': accountBookName,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  factory AccountBookFund.fromJson(Map<String, dynamic> json) =>
      AccountBookFund(
        id: json['id'],
        name: json['name'],
        fundType: json['fundType'],
        fundRemark: json['fundRemark'],
        fundBalance: (json['fundBalance'] as num).toDouble(),
        fundIn: json['fundIn'] ?? true,
        fundOut: json['fundOut'] ?? true,
        isDefault: json['isDefault'] ?? false,
        accountBookName: json['accountBookName'],
        createdBy: json['createdBy'],
        updatedBy: json['updatedBy'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );

  AccountBookFund copyWith({
    String? id,
    String? name,
    String? fundType,
    String? fundRemark,
    double? fundBalance,
    bool? fundIn,
    bool? fundOut,
    bool? isDefault,
    String? accountBookName,
  }) =>
      AccountBookFund(
        id: id ?? this.id,
        name: name ?? this.name,
        fundType: fundType ?? this.fundType,
        fundRemark: fundRemark ?? this.fundRemark,
        fundBalance: fundBalance ?? this.fundBalance,
        fundIn: fundIn ?? this.fundIn,
        fundOut: fundOut ?? this.fundOut,
        isDefault: isDefault ?? this.isDefault,
        accountBookName: accountBookName ?? this.accountBookName,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
