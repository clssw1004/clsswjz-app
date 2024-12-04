class Fund {
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

  Fund({
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

  factory Fund.fromJson(Map<String, dynamic> json) => Fund(
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

  Fund copyWith({
    String? id,
    String? name,
    String? fundType,
    String? fundRemark,
    double? fundBalance,
    List<FundBook>? fundBooks,
  }) =>
      Fund(
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
  final String bookName;
  final bool fundIn;
  final bool fundOut;
  final bool isDefault;

  FundBook({
    required this.accountBookId,
    required this.bookName,
    this.fundIn = true,
    this.fundOut = true,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'accountBookId': accountBookId,
        'bookName': bookName,
        'fundIn': fundIn,
        'fundOut': fundOut,
        'isDefault': isDefault,
      };

  factory FundBook.fromJson(Map<String, dynamic> json) => FundBook(
        accountBookId: json['accountBookId'],
        bookName: json['bookName'],
        fundIn: json['fundIn'] ?? true,
        fundOut: json['fundOut'] ?? true,
        isDefault: json['isDefault'] ?? false,
      );
}
