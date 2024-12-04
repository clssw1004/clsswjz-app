enum FundType {
  CASH('现金'),
  DEBIT('储蓄卡'),
  CREDIT('信用卡'),
  PREPAID_CARD('充值卡'),
  ALIPAY('支付宝'),
  WECHAT('微信'),
  DEBT('欠款'),
  INVESTMENT('理财账户'),
  E_WALLET('网络钱包'),
  OTHER("其它");

  final String label;
  const FundType(this.label);

  static FundType fromString(String value) {
    return FundType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => FundType.OTHER,
    );
  }
}
