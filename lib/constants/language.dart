enum Language {
  ZH_CN('zh-CN', '简体中文'),
  ZH_TW('zh-TW', '繁體中文'),
  EN('en', 'English');

  final String code;
  final String label;
  const Language(this.code, this.label);

  static Language fromCode(String code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.ZH_CN,
    );
  }

  static List<Language> get supportedLanguages => Language.values;
}
