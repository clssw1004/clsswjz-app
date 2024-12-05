import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '记账本';

  @override
  String get settings => '设置';

  @override
  String get accountManagement => '账本管理';

  @override
  String get themeSettings => '主题设置';

  @override
  String get systemSettings => '系统设置';

  @override
  String get categoryManagement => '分类管理';

  @override
  String get shopManagement => '商家管理';

  @override
  String get fundManagement => '账户管理';

  @override
  String get createAccountBook => '创建账本';

  @override
  String get serverSettings => '后台服务设置';

  @override
  String get logout => '退出登录';

  @override
  String get confirmLogout => '确认退出';

  @override
  String get confirmLogoutMessage => '确定要退出登录吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get userInfo => '用户信息';

  @override
  String get nickname => '昵称';

  @override
  String get email => '邮箱';

  @override
  String get phone => '手机号';

  @override
  String get languageSettings => '语言设置';

  @override
  String get timezoneSettings => '时区设置';

  @override
  String get inviteCode => '邀请码';

  @override
  String get reset => '重置';

  @override
  String get resetSuccess => '重置成功';

  @override
  String get copied => '已复制到剪贴板';

  @override
  String get updateSuccess => '更新成功';

  @override
  String registerTime(Object time) {
    return '注册时间：$time';
  }

  @override
  String get developerMode => '开发者模式';

  @override
  String get themeMode => '主题模式';

  @override
  String get themeColor => '主题颜色';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟随系统';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get save => '保存';

  @override
  String get nicknameRequired => '昵称不能为空';

  @override
  String get invalidEmail => '邮箱格式不正确';

  @override
  String get invalidPhone => '手机号格式不正确';

  @override
  String get merchantManagement => '商家管理';

  @override
  String get themeColorTitle => '主题颜色';

  @override
  String get themeColorSubtitle => '选择您喜欢的主题色';

  @override
  String get loadServerUrlFailed => '加载服务地址失败';

  @override
  String get serverUrlHint => 'http://example.com:3000';

  @override
  String get login => '登录';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get usernameRequired => '请输入用户名';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get noAccount => '还没有账号？立即注册';

  @override
  String get bookName => '账本名称';

  @override
  String get bookNameHint => '请输入账本名称';

  @override
  String get bookNameRequired => '请输入账本名称';

  @override
  String get bookDescription => '账本描述';

  @override
  String get bookDescriptionHint => '请输入账本描述（选填）';

  @override
  String get currency => '币种';

  @override
  String get createBook => '创建账本';

  @override
  String get createSuccess => '创建成功';

  @override
  String createFailed(Object error) {
    return '创建失败：$error';
  }

  @override
  String get newShop => '新建商家';

  @override
  String get editShop => '编辑商家';

  @override
  String get shopName => '商家名称';

  @override
  String get noDefaultBook => '未选择默认账本';

  @override
  String get updateShopSuccess => '更新成功';

  @override
  String get createShopSuccess => '创建成功';

  @override
  String get shopNameRequired => '商家名称不能为空';

  @override
  String get newCategory => '新建分类';

  @override
  String get editCategory => '编辑分类';

  @override
  String get categoryName => '分类名称';

  @override
  String get categoryNameRequired => '分类名称不能为空';

  @override
  String get updateCategorySuccess => '更新成功';

  @override
  String get createCategorySuccess => '创建成功';

  @override
  String get newFund => '新建账户';

  @override
  String get editFund => '编辑账户';

  @override
  String get fundName => '账户名称';

  @override
  String get fundNameRequired => '账户名称不能为空';

  @override
  String get fundType => '账户类型';

  @override
  String get updateFundSuccess => '更新成功';

  @override
  String get createFundSuccess => '创建成功';

  @override
  String get cash => '现金';

  @override
  String get bankCard => '储蓄卡';

  @override
  String get creditCard => '信用卡';

  @override
  String get alipay => '支付宝';

  @override
  String get wechat => '微信支付';

  @override
  String get other => '其他';

  @override
  String get filter => '筛选';

  @override
  String get noAccountItems => '暂无账目记录';

  @override
  String get newRecord => '新增记录';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String monthDayFormat(Object day, Object month) {
    return '$month月$day日';
  }

  @override
  String get filterConditions => '筛选条件';

  @override
  String get clearFilter => '清空筛选';

  @override
  String get type => '类型';

  @override
  String get expense => '支出';

  @override
  String get income => '收入';

  @override
  String get category => '分类';

  @override
  String selectedCount(Object count) {
    return '已选$count项';
  }

  @override
  String get amount => '金额';

  @override
  String get date => '日期';

  @override
  String get filtered => '已筛选';

  @override
  String get totalIncome => '收入';

  @override
  String get totalExpense => '支出';

  @override
  String get balance => '结余';

  @override
  String get accountBookList => '账本列表';

  @override
  String get newAccountBook => '新建账本';

  @override
  String get retryLoading => '重试';

  @override
  String get noAccountBooks => '暂无账本';

  @override
  String get unnamedBook => '未命名账本';

  @override
  String sharedFrom(String name) {
    return '共享自$name';
  }

  @override
  String get unknownUser => '未知用户';

  @override
  String get serverAddress => '服务地址';

  @override
  String serverStatusNormal(String dbStatus, String memUsed, String memTotal) {
    return '服务正常\n数据库状态: $dbStatus\n内存使用: $memUsed/$memTotal';
  }

  @override
  String serverStatusError(String error) {
    return '服务异常: $error';
  }

  @override
  String get pleaseInputServerUrl => '请输入服务地址';

  @override
  String get saveSuccess => '保存成功';

  @override
  String saveFailed(String error) {
    return '保存失败: $error';
  }

  @override
  String get restartAppAfterChange => '修改后需要重启应用才能生效';

  @override
  String get checkServer => '检测服务';

  @override
  String linkedBooksCount(int count) {
    return '$count个关联账本';
  }

  @override
  String get editFundTitle => '编辑账户';

  @override
  String get newFundTitle => '新建账户';

  @override
  String get linkedBooks => '关联账本';

  @override
  String lastUpdated(String time) {
    return '最近更新：$time';
  }

  @override
  String get unknown => '未知';

  @override
  String get basicInfo => '基本信息';

  @override
  String get accountName => '账户名称';

  @override
  String get accountRemark => '账户备注';

  @override
  String get currentBalance => '当前余额';

  @override
  String get pleaseInputAccountName => '请输入账户名称';

  @override
  String get fundIncome => '收入';

  @override
  String get fundExpense => '支出';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant(): super('zh_Hant');

  @override
  String get appName => '記賬本';

  @override
  String get settings => '設置';

  @override
  String get accountManagement => '賬本管理';

  @override
  String get themeSettings => '主題設置';

  @override
  String get systemSettings => '系統設置';

  @override
  String get categoryManagement => '分類管理';

  @override
  String get shopManagement => '商家管理';

  @override
  String get fundManagement => '賬戶管理';

  @override
  String get createAccountBook => '創建賬本';

  @override
  String get serverSettings => '後台服務設置';

  @override
  String get logout => '退出登錄';

  @override
  String get confirmLogout => '確認退出';

  @override
  String get confirmLogoutMessage => '確定要退出登錄嗎？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get userInfo => '用戶信息';

  @override
  String get nickname => '暱稱';

  @override
  String get email => '郵箱';

  @override
  String get phone => '手機號';

  @override
  String get languageSettings => '語言設置';

  @override
  String get timezoneSettings => '時區設置';

  @override
  String get inviteCode => '邀請碼';

  @override
  String get reset => '重置';

  @override
  String get resetSuccess => '重置成功';

  @override
  String get copied => '已複製到剪貼板';

  @override
  String get updateSuccess => '更新成功';

  @override
  String registerTime(Object time) {
    return '註冊時間：$time';
  }

  @override
  String get developerMode => '開發者模式';

  @override
  String get themeMode => '主題模式';

  @override
  String get themeColor => '主題顏色';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟隨系統';

  @override
  String get serverUrl => '伺服器地址';

  @override
  String get save => '保存';

  @override
  String get nicknameRequired => '暱稱不能為空';

  @override
  String get invalidEmail => '郵箱格式不正確';

  @override
  String get invalidPhone => '手機號格式不正確';

  @override
  String get merchantManagement => '商家管理';

  @override
  String get themeColorTitle => '主題顏色';

  @override
  String get themeColorSubtitle => '選擇您喜歡的主題色';

  @override
  String get loadServerUrlFailed => '加載服務地址失敗';

  @override
  String get serverUrlHint => 'http://example.com:3000';

  @override
  String get login => '登錄';

  @override
  String get username => '用戶名';

  @override
  String get password => '密碼';

  @override
  String get usernameRequired => '請輸入用戶名';

  @override
  String get passwordRequired => '請輸入密碼';

  @override
  String get noAccount => '還沒有賬號？立即註冊';

  @override
  String get bookName => '賬本名稱';

  @override
  String get bookNameHint => '請輸入賬本名稱';

  @override
  String get bookNameRequired => '請輸入賬本名稱';

  @override
  String get bookDescription => '賬本描述';

  @override
  String get bookDescriptionHint => '請輸入賬本描述（選填）';

  @override
  String get currency => '幣種';

  @override
  String get createBook => '創建賬本';

  @override
  String get createSuccess => '創建成功';

  @override
  String createFailed(Object error) {
    return '創建失敗：$error';
  }

  @override
  String get newShop => '新建商家';

  @override
  String get editShop => '編輯商家';

  @override
  String get shopName => '商家名稱';

  @override
  String get noDefaultBook => '未選擇默認賬本';

  @override
  String get updateShopSuccess => '更新成';

  @override
  String get createShopSuccess => '創建成功';

  @override
  String get shopNameRequired => '商家名稱不能為空';

  @override
  String get newCategory => '新建分類';

  @override
  String get editCategory => '編輯分類';

  @override
  String get categoryName => '分類名稱';

  @override
  String get categoryNameRequired => '分類名稱不能為空';

  @override
  String get updateCategorySuccess => '更新成功';

  @override
  String get createCategorySuccess => '創建成功';

  @override
  String get newFund => '新建賬戶';

  @override
  String get editFund => '編輯賬戶';

  @override
  String get fundName => '賬戶名稱';

  @override
  String get fundNameRequired => '賬戶名稱不能為空';

  @override
  String get fundType => '賬戶類型';

  @override
  String get updateFundSuccess => '更新成功';

  @override
  String get createFundSuccess => '創建成功';

  @override
  String get cash => '現金';

  @override
  String get bankCard => '儲蓄卡';

  @override
  String get creditCard => '信用卡';

  @override
  String get alipay => '支付寶';

  @override
  String get wechat => '微信支付';

  @override
  String get other => '其他';

  @override
  String get filter => '篩選';

  @override
  String get noAccountItems => '暫無賬目記錄';

  @override
  String get newRecord => '新增記錄';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String monthDayFormat(Object day, Object month) {
    return '$month月$day日';
  }

  @override
  String get filterConditions => '篩選條件';

  @override
  String get clearFilter => '清空篩選';

  @override
  String get type => '類型';

  @override
  String get expense => '支出';

  @override
  String get income => '收入';

  @override
  String get category => '分類';

  @override
  String selectedCount(Object count) {
    return '已選$count項';
  }

  @override
  String get amount => '金額';

  @override
  String get date => '日期';

  @override
  String get filtered => '已篩選';

  @override
  String get totalIncome => '收入';

  @override
  String get totalExpense => '支出';

  @override
  String get balance => '結餘';

  @override
  String get accountBookList => '賬本列表';

  @override
  String get newAccountBook => '新建賬本';

  @override
  String get retryLoading => '重試';

  @override
  String get noAccountBooks => '暫無賬本';

  @override
  String get unnamedBook => '未命名賬本';

  @override
  String sharedFrom(String name) {
    return '共享自$name';
  }

  @override
  String get unknownUser => '未知用戶';

  @override
  String get serverAddress => '服務地址';

  @override
  String serverStatusNormal(String dbStatus, String memUsed, String memTotal) {
    return '服務正常\n數據庫狀態: $dbStatus\n內存使用: $memUsed/$memTotal';
  }

  @override
  String serverStatusError(String error) {
    return '服務異常: $error';
  }

  @override
  String get pleaseInputServerUrl => '請輸入服務地址';

  @override
  String get saveSuccess => '保存成功';

  @override
  String saveFailed(String error) {
    return '保存失敗: $error';
  }

  @override
  String get restartAppAfterChange => '修改後需要重啟應用才能生效';

  @override
  String get checkServer => '檢測服務';

  @override
  String linkedBooksCount(int count) {
    return '$count個關聯賬本';
  }

  @override
  String get editFundTitle => '編輯賬戶';

  @override
  String get newFundTitle => '新建賬戶';

  @override
  String get linkedBooks => '關聯賬本';

  @override
  String lastUpdated(String time) {
    return '最近更新：$time';
  }

  @override
  String get unknown => '未知';

  @override
  String get basicInfo => '基本信息';

  @override
  String get accountName => '賬戶名稱';

  @override
  String get accountRemark => '賬戶備註';

  @override
  String get currentBalance => '當前餘額';

  @override
  String get pleaseInputAccountName => '請輸入賬戶名稱';

  @override
  String get fundIncome => '收入';

  @override
  String get fundExpense => '支出';
}
