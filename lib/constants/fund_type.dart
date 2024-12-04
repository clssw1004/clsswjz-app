enum FundType {
  CASH('现金'),
  BANK('银行卡'),
  ALIPAY('支付宝'),
  WECHAT('微信'),
  CREDIT('信用卡'),
  OTHER('其他');

  final String label;
  const FundType(this.label);

  static FundType fromString(String value) {
    return FundType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => FundType.OTHER,
    );
  }
}
