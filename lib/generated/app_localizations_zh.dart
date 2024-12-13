import 'package:intl/intl.dart' as intl;

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
  String get accountManagement => '账本';

  @override
  String get themeSettings => '主题设置';

  @override
  String get systemSettings => '系统设置';

  @override
  String get categoryManagement => '分类';

  @override
  String get shopManagement => '商家';

  @override
  String get fundManagement => '账户';

  @override
  String get createAccountBook => '创建账本';

  @override
  String get serverSettings => '后台服务设置';

  @override
  String get logout => '退出登录';

  @override
  String get confirmLogout => '确认退出';

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
  String get noAccountItems => '暂无交易记录';

  @override
  String get newRecord => '新增记录';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String monthDayFormat(String month, String day) {
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
    return '已选 $count 项';
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
  String get accountBookList => '账目';

  @override
  String get newAccountBook => '新建账本';

  @override
  String get retryLoading => '重试';

  @override
  String get noAccountBooks => '暂无账本';

  @override
  String get unnamedBook => '未命名账本';

  @override
  String sharedFrom(Object name) {
    return '共享自$name';
  }

  @override
  String get unknownUser => '未知用户';

  @override
  String get serverAddress => '服务地址';

  @override
  String serverStatusNormal(Object dbStatus, Object memTotal, Object memUsed) {
    return '服务正常\n数据库状态: $dbStatus\n内存使用: $memUsed/$memTotal';
  }

  @override
  String serverStatusError(Object error) {
    return '服务异常: $error';
  }

  @override
  String get pleaseInputServerUrl => '请输入服务地址';

  @override
  String get saveSuccess => '保存成功，请重启应用';

  @override
  String saveFailed(Object error) {
    return '保存失败: $error';
  }

  @override
  String get restartAppAfterChange => '修改后需要重启应用才能生效';

  @override
  String get checkServer => '检测服务';

  @override
  String linkedBooksCount(Object count) {
    return '$count个关联账本';
  }

  @override
  String get editFundTitle => '编辑账户';

  @override
  String get newFundTitle => '新建账户';

  @override
  String get linkedBooks => '关联账本';

  @override
  String lastUpdated(Object time) {
    return '最新更新：$time';
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

  @override
  String get checkButton => '检';

  @override
  String get saveButton => '保存';

  @override
  String get serverUrlLabel => '服务器地址';

  @override
  String get serverUrlHint => 'http://example.com:3000';

  @override
  String get normalStatus => '正常';

  @override
  String get categoryTitle => '分类管理';

  @override
  String get addCategory => '添加分类';

  @override
  String get noCategories => '暂无分类';

  @override
  String get create => '创建';

  @override
  String get bookDetails => '账本详情';

  @override
  String get save => '保存';

  @override
  String get bookNameLabel => '账本名称';

  @override
  String get bookDescriptionLabel => '账本描述';

  @override
  String get creatorLabel => '创建者';

  @override
  String get createTimeLabel => '创建时间';

  @override
  String get unknownTime => '未知';

  @override
  String get memberManagement => '成员管理';

  @override
  String get addMember => '添加成员';

  @override
  String get unknownMember => '未知用户';

  @override
  String get creator => '创建者';

  @override
  String get confirmRemoveMember => '确认删除';

  @override
  String get confirmRemoveMemberMessage => '确定要移除该成员吗？';

  @override
  String get delete => '删除';

  @override
  String get addMemberTitle => '添加成员';

  @override
  String get inviteCodeLabel => '邀请码';

  @override
  String get inviteCodeHint => '请输入邀请码';

  @override
  String get add => '添加';

  @override
  String get memberAlreadyExists => '该用户已经是成员';

  @override
  String get addMemberSuccess => '成员添加成功';

  @override
  String addMemberFailed(Object error) {
    return '添加成员失败：$error';
  }

  @override
  String get permViewBook => '查看���本';

  @override
  String get permEditBook => '编辑账本';

  @override
  String get permDeleteBook => '删除账本';

  @override
  String get permViewItem => '查看账目';

  @override
  String get permEditItem => '编辑账目';

  @override
  String get permDeleteItem => '删除账目';

  @override
  String get shopManagementTitle => '商家理';

  @override
  String get newShopButton => '新建商家';

  @override
  String get newShopTitle => '新建商家';

  @override
  String get editShopTitle => '编辑商家';

  @override
  String get shopNameLabel => '商家名称';

  @override
  String get userInfoTitle => '用户信息';

  @override
  String get editUserInfo => '编辑用户信息';

  @override
  String get nicknameLabel => '昵称';

  @override
  String get emailLabel => '邮箱';

  @override
  String get phoneLabel => '手机号';

  @override
  String get resetInviteCode => '重置邀请码';

  @override
  String get resetInviteCodeSuccess => '重置成功';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get updateUserInfoSuccess => '更新成功';

  @override
  String registerTimeLabel(Object time) {
    return '注册时间：$time';
  }

  @override
  String get nicknameRequired => '昵称不能为空';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get invalidPhoneFormat => 'Invalid phone number format';

  @override
  String get confirmLogoutTitle => '确认退出';

  @override
  String get confirmLogoutMessage => '确定要退出登录吗？';

  @override
  String get newRecordTitle => '记一笔';

  @override
  String get editRecordTitle => '编辑记录';

  @override
  String get expenseType => '支出';

  @override
  String get incomeType => '收入';

  @override
  String get pleaseInputAmount => '请输入金额';

  @override
  String get pleaseSelectCategory => '请选择分类';

  @override
  String get pleaseSelectAccount => '请选择账户';

  @override
  String get pleaseSelectBook => '请选择账本';

  @override
  String get saveRecord => '保存';

  @override
  String get saveRecordSuccess => '保存成功';

  @override
  String get amountLabel => '金额';

  @override
  String get amountHint => '请输入金额';

  @override
  String get categoryLabel => '分类';

  @override
  String get categoryHint => '请选择分类';

  @override
  String get dateLabel => '日期';

  @override
  String get timeLabel => '时间';

  @override
  String get accountLabel => '账户';

  @override
  String get accountHint => '请选择账户';

  @override
  String get descriptionLabel => '备注';

  @override
  String get descriptionHint => '请输入备注（选填）';

  @override
  String get shopLabel => '商家';

  @override
  String get shopHint => '请选择商家';

  @override
  String get selectFund => '选择账户';

  @override
  String get noAvailableFunds => '暂无可用账户';

  @override
  String get defaultFund => '默认账户';

  @override
  String get searchFund => '搜索账户';

  @override
  String get selectFundHint => '请选择账户';

  @override
  String get selectBookTitle => '选择账本';

  @override
  String get noAvailableBooks => '暂无可用账本';

  @override
  String get defaultBook => '默认账本';

  @override
  String get searchBook => '搜索账本';

  @override
  String get selectBookHint => '选择账本';

  @override
  String get sharedBook => '共享账本';

  @override
  String get selectBookHeader => '选择账本';

  @override
  String get sharedBookLabel => '共享';

  @override
  String get cancelButton => '取消';

  @override
  String get selectCategoryTitle => '选择分类';

  @override
  String get noAvailableCategories => '暂无可用分类';

  @override
  String get searchCategoryHint => '搜索或输入新分类';

  @override
  String addCategoryButton(Object name) {
    return '添加\"$name\"';
  }

  @override
  String get selectShopTitle => '选择商家';

  @override
  String get noAvailableShops => '暂无可用商家';

  @override
  String get searchShopHint => '搜索或输入新商家';

  @override
  String addShopButton(Object name) {
    return '添加\"$name\"';
  }

  @override
  String get summaryIncome => '收入';

  @override
  String get summaryExpense => '支出';

  @override
  String get summaryBalance => '结余';

  @override
  String get currencySymbol => '¥';

  @override
  String get noTransactions => '暂无交易';

  @override
  String get statistics => '统计';

  @override
  String get statisticsTimeRange => '时间范围';

  @override
  String get statisticsWeek => '本周';

  @override
  String get statisticsMonth => '本月';

  @override
  String get statisticsYear => '本年';

  @override
  String get statisticsCustom => '自定义';

  @override
  String get statisticsOverview => '收支总览';

  @override
  String get statisticsTrend => '收支趋势';

  @override
  String get statisticsExpenseByCategory => '支出分类';

  @override
  String get statisticsIncomeByCategory => '收入分类';

  @override
  String get statisticsNoData => '暂无数据';

  @override
  String get chartTypeLine => '折线图';

  @override
  String get chartTypeBar => '柱状图';

  @override
  String get chartTypeArea => '面积图';

  @override
  String get chartTypeStacked => '堆叠图';

  @override
  String get chartNoData => '暂无数据';

  @override
  String get metricAmount => '金额';

  @override
  String get metricCount => '笔数';

  @override
  String get metricAverage => '平均值';

  @override
  String metricUnit(Object unit) {
    return '$unit';
  }

  @override
  String get serverManagement => '服务器管理';

  @override
  String get addServer => '添加服务器';

  @override
  String get edit => '编辑';

  @override
  String get confirmDeleteServer => '删除服务器';

  @override
  String confirmDeleteServerMessage(String name) {
    return '确定要删除服务器\"$name\"吗？';
  }

  @override
  String get pleaseSelectServer => '请先选择服务器';

  @override
  String loginFailed(String error) {
    return '登录失败：$error';
  }

  @override
  String get wrongCredentials => '用户名或密码错误';

  @override
  String get rememberLogin => '记住登录信息';

  @override
  String get selectServer => '选择服务器';

  @override
  String get serverName => '服务器名称';

  @override
  String get serverNameHint => '例如：本地服务器';

  @override
  String get serverNameRequired => '请输入服务器名称';

  @override
  String get serverType => '服务器类型';

  @override
  String get serverUrlRequired => '请输入服务器地址';

  @override
  String serverTypeLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'selfHosted': '自托管服务器',
        'clsswjzCloud': 'Clssw云',
        'localStorage': '本地存储',
        'other': '未知',
      },
    );
    return '$_temp0';
  }

  @override
  String get pin => '固定';

  @override
  String get unpin => '取消固定';

  @override
  String get shop => '商家';

  @override
  String get noFund => '无账户';

  @override
  String get noShop => '无商家';

  @override
  String get more => '更多';

  @override
  String get confirmDeleteMessage => '确定要删除这条记录吗？';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get pleaseSelectItems => '请至少选择一条记录';

  @override
  String confirmBatchDeleteMessage(int count) {
    return '确定要删除选中的 $count 条记录吗？';
  }

  @override
  String batchDeleteSuccess(int count) {
    return '成功删除 $count 条记录';
  }

  @override
  String get checkingServerStatus => '正在检测服务器状态...';

  @override
  String get serverCheckFailed => '服务器检测失败';

  @override
  String get serverCheckFailedMessage => '无法连接到服务��，请检查网络连接后重试。';

  @override
  String get backToLogin => '返回登录';

  @override
  String get retry => '重试';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get projectInfo => '项目信息';

  @override
  String get sourceCode => '源代码';

  @override
  String get latestRelease => '最新版本';

  @override
  String get downloadLatestVersion => '下载最新版本';

  @override
  String get technicalInfo => '技术信息';

  @override
  String get flutterDescription => 'Google 开源的跨平台 UI 框架';

  @override
  String get materialDescription => 'Flutter 的现代设计系统';

  @override
  String get providerDescription => 'Flutter 的状态管理解决方案';

  @override
  String get license => '开源协议';

  @override
  String get mitLicenseDescription => '基于 MIT 协议开源';

  @override
  String get support => '支持';

  @override
  String get technicalSupport => '技术支持';

  @override
  String get loadingMore => '加载更多...';

  @override
  String get noMoreData => '已经到底了';

  @override
  String get importData => '导入数据';

  @override
  String get dataSource => '数据来源';

  @override
  String get selectFile => '选择文件';

  @override
  String get importFieldsRequired => '请填写所有必填字段';

  @override
  String get importSuccess => '导入成功';

  @override
  String get selectBook => '选择账本';

  @override
  String importSuccessCount(String count) {
    return '成功导入 $count 条记录';
  }

  @override
  String get importErrors => '导入过程中出现以下错误：';
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
  String get serverUrl => '服務器地址';

  @override
  String get noAccountItems => '暫無交易記錄';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String monthDayFormat(String month, String day) {
    return '$month月$day日';
  }

  @override
  String get save => '保存';

  @override
  String get delete => '刪除';

  @override
  String get add => '添加';

  @override
  String get newRecordTitle => '記一筆';

  @override
  String get editRecordTitle => '編輯記錄';

  @override
  String get expenseType => '支出';

  @override
  String get incomeType => '收入';

  @override
  String get pleaseInputAmount => '請輸入金額';

  @override
  String get pleaseSelectCategory => '請選擇分類';

  @override
  String get pleaseSelectAccount => '請選擇賬戶';

  @override
  String get pleaseSelectBook => '請選擇賬本';

  @override
  String get saveRecord => '保存';

  @override
  String get saveRecordSuccess => '保存成功';

  @override
  String get amountLabel => '金額';

  @override
  String get amountHint => '請輸入金額';

  @override
  String get categoryLabel => '分類';

  @override
  String get categoryHint => '請選擇分類';

  @override
  String get dateLabel => '日期';

  @override
  String get timeLabel => '時間';

  @override
  String get accountLabel => '賬戶';

  @override
  String get accountHint => '請選擇賬戶';

  @override
  String get descriptionLabel => '備註';

  @override
  String get descriptionHint => '請輸入備註（選填）';

  @override
  String get shopLabel => '商家';

  @override
  String get shopHint => '請選擇商家';

  @override
  String get selectFund => '選擇賬戶';

  @override
  String get noAvailableFunds => '暫無可用賬戶';

  @override
  String get defaultFund => '默認賬戶';

  @override
  String get searchFund => '搜索賬戶';

  @override
  String get selectFundHint => '請選擇賬戶';

  @override
  String get selectBookTitle => '選擇賬本';

  @override
  String get noAvailableBooks => '暫無可用賬本';

  @override
  String get defaultBook => '默認賬本';

  @override
  String get searchBook => '搜索賬本';

  @override
  String get selectBookHint => '選擇賬本';

  @override
  String get sharedBook => '共享賬本';

  @override
  String get selectBookHeader => '選擇賬本';

  @override
  String get sharedBookLabel => '共享';

  @override
  String get cancelButton => '取消';

  @override
  String get selectCategoryTitle => '選擇分類';

  @override
  String get noAvailableCategories => '暫無可用分類';

  @override
  String get searchCategoryHint => '搜索或輸入新分類';

  @override
  String addCategoryButton(Object name) {
    return '添加\"$name\"';
  }

  @override
  String get selectShopTitle => '選擇商家';

  @override
  String get noAvailableShops => '暫無可用商家';

  @override
  String get searchShopHint => '搜索或輸入新商家';

  @override
  String addShopButton(Object name) {
    return '添加\"$name\"';
  }

  @override
  String get summaryIncome => '收入';

  @override
  String get summaryExpense => '支出';

  @override
  String get summaryBalance => '結餘';

  @override
  String get currencySymbol => '¥';

  @override
  String get noTransactions => '暫無交易';

  @override
  String get statistics => '統計';

  @override
  String get statisticsTimeRange => '時間範圍';

  @override
  String get statisticsWeek => '本週';

  @override
  String get statisticsMonth => '本月';

  @override
  String get statisticsYear => '本年';

  @override
  String get statisticsCustom => '自定義';

  @override
  String get statisticsOverview => '收支總覽';

  @override
  String get statisticsTrend => '收支趨勢';

  @override
  String get statisticsExpenseByCategory => '支出分類';

  @override
  String get statisticsIncomeByCategory => '收入分類';

  @override
  String get statisticsNoData => '暫無數據';

  @override
  String get chartTypeLine => '折線圖';

  @override
  String get chartTypeBar => '柱狀圖';

  @override
  String get chartTypeArea => '面積圖';

  @override
  String get chartTypeStacked => '堆疊圖';

  @override
  String get chartNoData => '暫無數據';

  @override
  String get metricAmount => '金額';

  @override
  String get metricCount => '筆數';

  @override
  String get metricAverage => '平均值';

  @override
  String metricUnit(Object unit) {
    return '$unit';
  }

  @override
  String get addServer => '添加服務器';

  @override
  String get edit => '編輯';

  @override
  String get confirmDeleteServer => '刪除服務器';

  @override
  String confirmDeleteServerMessage(String name) {
    return '確定要刪除服務器\"$name\"嗎？';
  }

  @override
  String get pleaseSelectServer => '請先選擇服務器';

  @override
  String loginFailed(String error) {
    return '登錄失敗：$error';
  }

  @override
  String get wrongCredentials => '用戶名或密碼錯誤';

  @override
  String get rememberLogin => '記住登錄信息';

  @override
  String get selectServer => '選擇服務器';

  @override
  String get serverName => '服務器名稱';

  @override
  String get serverNameHint => '例如：本地服務器';

  @override
  String get serverNameRequired => '請輸入服務器名稱';

  @override
  String get serverType => '服務器類型';

  @override
  String get serverUrlRequired => '請輸入服務器地址';

  @override
  String serverTypeLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'selfHosted': '自托管服務器',
        'clsswjzCloud': 'Clssw雲',
        'localStorage': '本地存儲',
        'other': '未知',
      },
    );
    return '$_temp0';
  }

  @override
  String get pin => '固定';

  @override
  String get unpin => '取消固定';

  @override
  String get shop => '商家';

  @override
  String get noFund => '無賬戶';

  @override
  String get noShop => '無商家';

  @override
  String get more => '更多';

  @override
  String get confirmDeleteMessage => '確定要刪除這條記錄嗎？';

  @override
  String get deleteSuccess => '刪除成功';

  @override
  String get pleaseSelectItems => '請至少選擇一條記錄';

  @override
  String confirmBatchDeleteMessage(int count) {
    return '確定要刪除選中的 $count 條記錄嗎？';
  }

  @override
  String batchDeleteSuccess(int count) {
    return '成功刪除 $count 條記錄';
  }

  @override
  String get checkingServerStatus => '正在檢測伺服器狀態...';

  @override
  String get serverCheckFailed => '伺服器檢測失敗';

  @override
  String get serverCheckFailedMessage => '無法連接到伺服器，請檢查網絡連接後重試。';

  @override
  String get backToLogin => '返回登錄';

  @override
  String get retry => '重試';

  @override
  String get about => '關於';

  @override
  String get version => '版本';

  @override
  String get projectInfo => '項目信息';

  @override
  String get sourceCode => '源代碼';

  @override
  String get latestRelease => '最新版本';

  @override
  String get downloadLatestVersion => '下載最新版本';

  @override
  String get technicalInfo => '技術信息';

  @override
  String get flutterDescription => 'Google 開源的跨平台 UI 框架';

  @override
  String get materialDescription => 'Flutter 的現代設計系統';

  @override
  String get providerDescription => 'Flutter 的狀態管理解決方案';

  @override
  String get license => '開源協議';

  @override
  String get mitLicenseDescription => '基於 MIT 協議開源';

  @override
  String get support => '支持';

  @override
  String get technicalSupport => '技術支持';

  @override
  String get loadingMore => '加載更多...';

  @override
  String get noMoreData => '已經到底了';

  @override
  String get importData => '導入數據';

  @override
  String get dataSource => '數據來源';

  @override
  String get selectFile => '選擇文件';

  @override
  String get importFieldsRequired => '請填寫所有必填欄位';

  @override
  String get importSuccess => '導入成功';

  @override
  String get selectBook => '選擇賬本';
}
