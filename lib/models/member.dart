class Member {
  final String userId;
  final String nickname;
  final bool canViewBook;
  final bool canEditBook;
  final bool canDeleteBook;
  final bool canViewItem;
  final bool canEditItem;
  final bool canDeleteItem;

  Member({
    required this.userId,
    required this.nickname,
    required this.canViewBook,
    required this.canEditBook,
    required this.canDeleteBook,
    required this.canViewItem,
    required this.canEditItem,
    required this.canDeleteItem,
  });

  Member copyWith({
    String? userId,
    String? nickname,
    bool? canViewBook,
    bool? canEditBook,
    bool? canDeleteBook,
    bool? canViewItem,
    bool? canEditItem,
    bool? canDeleteItem,
  }) {
    return Member(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      canViewBook: canViewBook ?? this.canViewBook,
      canEditBook: canEditBook ?? this.canEditBook,
      canDeleteBook: canDeleteBook ?? this.canDeleteBook,
      canViewItem: canViewItem ?? this.canViewItem,
      canEditItem: canEditItem ?? this.canEditItem,
      canDeleteItem: canDeleteItem ?? this.canDeleteItem,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'nickname': nickname,
        'canViewBook': canViewBook,
        'canEditBook': canEditBook,
        'canDeleteBook': canDeleteBook,
        'canViewItem': canViewItem,
        'canEditItem': canEditItem,
        'canDeleteItem': canDeleteItem,
      };
  Map<String, dynamic> toJsonRequest() => {
        'userId': userId,
        'canViewBook': canViewBook,
        'canEditBook': canEditBook,
        'canDeleteBook': canDeleteBook,
        'canViewItem': canViewItem,
        'canEditItem': canEditItem,
        'canDeleteItem': canDeleteItem,
      };

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userId: json['userId'],
      nickname: json['nickname'],
      canViewBook: json['canViewBook'] ?? false,
      canEditBook: json['canEditBook'] ?? false,
      canDeleteBook: json['canDeleteBook'] ?? false,
      canViewItem: json['canViewItem'] ?? false,
      canEditItem: json['canEditItem'] ?? false,
      canDeleteItem: json['canDeleteItem'] ?? false,
    );
  }
}
