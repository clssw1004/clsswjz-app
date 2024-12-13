class AccountItemRequest {
  final String accountBookId;
  final List<String>? categories;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? shopCodes;
  final int page;
  final int pageSize;

  AccountItemRequest({
    required this.accountBookId,
    this.categories,
    this.type,
    this.startDate,
    this.endDate,
    this.shopCodes,
    this.page = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toJson() => {
        'accountBookId': accountBookId,
        'categories': categories,
        'type': type,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'shopCodes': shopCodes,
        'page': page,
        'pageSize': pageSize,
      };
}