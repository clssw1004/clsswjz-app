class AccountSymbol {
  final String id;
  final String name;
  final String code;
  final String symbolType;
  final String accountBookId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;

  AccountSymbol({
    required this.id,
    required this.name,
    required this.code,
    required this.symbolType,
    required this.accountBookId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountSymbol.fromJson(Map<String, dynamic> json) => AccountSymbol(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        symbolType: json['symbolType'],
        accountBookId: json['accountBookId'],
        createdBy: json['createdBy'],
        updatedBy: json['updatedBy'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'symbolType': symbolType,
        'accountBookId': accountBookId,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  AccountSymbol copyWith({
    String? id,
    String? name,
    String? code,
    String? symbolType,
  }) =>
      AccountSymbol(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        symbolType: symbolType ?? this.symbolType,
        accountBookId: accountBookId,
      );
}
