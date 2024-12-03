import 'member.dart';

class AccountBook {
  final String id;
  final String name;
  final String? description;
  final String currencySymbol;
  final String? icon;
  final String createdBy;
  final String? fromName;
  final List<Member> members;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountBook({
    required this.id,
    required this.name,
    this.description,
    required this.currencySymbol,
    this.icon,
    required this.createdBy,
    this.fromName,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
  });

  AccountBook copyWith({
    String? id,
    String? name,
    String? description,
    String? currencySymbol,
    String? icon,
    String? createdBy,
    String? fromName,
    List<Member>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountBook(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      icon: icon ?? this.icon,
      createdBy: createdBy ?? this.createdBy,
      fromName: fromName ?? this.fromName,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'currencySymbol': currencySymbol,
        'icon': icon,
        'createdBy': createdBy,
        'fromName': fromName,
        'members': members.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory AccountBook.fromJson(Map<String, dynamic> json) => AccountBook(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        currencySymbol: json['currencySymbol'],
        icon: json['icon'],
        createdBy: json['createdBy'],
        fromName: json['fromName'],
        members: (json['members'] as List?)
                ?.map((m) => Member.fromJson(m))
                .toList() ??
            [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
