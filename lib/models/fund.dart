class Fund {
  final String id;
  final String name;
  final String fundType;
  final String fundRemark;
  final double fundBalance;
  final bool isDefault;
  final bool fundIn;
  final bool fundOut;
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
    this.isDefault = false,
    this.fundIn = true,
    this.fundOut = true,
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
        'isDefault': isDefault ? 1 : 0,
        'fundIn': fundIn,
        'fundOut': fundOut,
      };

  factory Fund.fromJson(Map<String, dynamic> json) => Fund(
        id: json['id'],
        name: json['name'],
        fundType: json['fundType'],
        fundRemark: json['fundRemark'],
        fundBalance: (json['fundBalance'] as num).toDouble(),
        isDefault: json['isDefault'] == 1,
        fundIn: json['fundIn'] ?? true,
        fundOut: json['fundOut'] ?? true,
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
    bool? isDefault,
    bool? fundIn,
    bool? fundOut,
  }) =>
      Fund(
        id: id ?? this.id,
        name: name ?? this.name,
        fundType: fundType ?? this.fundType,
        fundRemark: fundRemark ?? this.fundRemark,
        fundBalance: fundBalance ?? this.fundBalance,
        isDefault: isDefault ?? this.isDefault,
        fundIn: fundIn ?? this.fundIn,
        fundOut: fundOut ?? this.fundOut,
        createdBy: createdBy,
        updatedBy: updatedBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
