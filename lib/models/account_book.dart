import 'member.dart';

class AccountBook {
  final String id;
  final String name;
  final String? description;
  final String currencySymbol;
  final String? icon;
  final String? fromId;
  final String? fromName;
  final Permissions permissions;
  final List<Member> members;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountBook({
    required this.id,
    required this.name,
    this.description,
    required this.currencySymbol,
    this.icon,
    this.fromId,
    this.fromName,
    Permissions? permissions,
    List<Member>? members,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  })  : permissions = permissions ?? Permissions.empty(),
        members = members ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'currencySymbol': currencySymbol,
        'icon': icon,
        'fromId': fromId,
        'fromName': fromName,
        'members': members.map((m) => m.toJson()).toList(),
        'permissions': permissions.toJson(),
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  Map<String, dynamic> toJsonCreate() => {
        'name': name,
        'description': description,
        'currencySymbol': currencySymbol,
        'icon': icon,
      };
  Map<String, dynamic> toJsonRequest() => {
        'id': id,
        'name': name,
        'description': description,
        'currencySymbol': currencySymbol,
        'icon': icon,
        'members': members.map((m) => m.toJsonRequest()).toList(),
      };

  factory AccountBook.fromJson(Map<String, dynamic> json) => AccountBook(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        currencySymbol: json['currencySymbol'],
        icon: json['icon'],
        fromId: json['fromId'],
        fromName: json['fromName'],
        permissions: json['permissions'] is Map
            ? Permissions.fromJson(json['permissions'])
            : Permissions.empty(),
        members: (json['members'] as List?)
                ?.map((m) => Member.fromJson(m))
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

  AccountBook copyWith({
    String? id,
    String? name,
    String? description,
    String? currencySymbol,
    String? icon,
    String? fromId,
    String? fromName,
    Permissions? permissions,
    List<Member>? members,
  }) {
    return AccountBook(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      icon: icon ?? this.icon,
      fromId: fromId ?? this.fromId,
      fromName: fromName ?? this.fromName,
      permissions: permissions ?? this.permissions,
      members: members ?? this.members,
      createdBy: createdBy,
      updatedBy: updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  bool get canEditBook => permissions.canEditBook;
  bool get canViewBook => permissions.canViewBook;
  bool get canDeleteBook => permissions.canDeleteBook;
  bool get canViewItem => permissions.canViewItem;
  bool get canEditItem => permissions.canEditItem;
  bool get canDeleteItem => permissions.canDeleteItem;
}

class Permissions {
  final bool canViewBook;
  final bool canEditBook;
  final bool canDeleteBook;
  final bool canViewItem;
  final bool canEditItem;
  final bool canDeleteItem;

  const Permissions({
    required this.canViewBook,
    required this.canEditBook,
    required this.canDeleteBook,
    required this.canViewItem,
    required this.canEditItem,
    required this.canDeleteItem,
  });

  factory Permissions.empty() => const Permissions(
        canViewBook: false,
        canEditBook: false,
        canDeleteBook: false,
        canViewItem: false,
        canEditItem: false,
        canDeleteItem: false,
      );

  Map<String, dynamic> toJson() => {
        'canViewBook': canViewBook,
        'canEditBook': canEditBook,
        'canDeleteBook': canDeleteBook,
        'canViewItem': canViewItem,
        'canEditItem': canEditItem,
        'canDeleteItem': canDeleteItem,
      };

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        canViewBook: json['canViewBook'] ?? false,
        canEditBook: json['canEditBook'] ?? false,
        canDeleteBook: json['canDeleteBook'] ?? false,
        canViewItem: json['canViewItem'] ?? false,
        canEditItem: json['canEditItem'] ?? false,
        canDeleteItem: json['canDeleteItem'] ?? false,
      );
}
