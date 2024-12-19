import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CLSSW Account';

  @override
  String get settings => 'Settings';

  @override
  String get accountManagement => 'Account';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get categoryManagement => 'Category';

  @override
  String get shopManagement => 'Shop';

  @override
  String get fundManagement => 'Fund';

  @override
  String get createAccountBook => 'Create Account Book';

  @override
  String get serverSettings => 'Server Configuration';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get userInfo => 'User Info';

  @override
  String get nickname => 'Nickname';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get timezoneSettings => 'Timezone Settings';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get reset => 'Reset';

  @override
  String get resetSuccess => 'Reset successful';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String get updateSuccess => 'Update successful';

  @override
  String registerTime(Object time) {
    return 'Register time: $time';
  }

  @override
  String get developerMode => 'Developer Mode';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get invalidPhone => 'Invalid phone number format';

  @override
  String get merchantManagement => 'Merchant Management';

  @override
  String get themeColorTitle => 'Theme Color';

  @override
  String get themeColorSubtitle => 'Choose your favorite theme color';

  @override
  String get loadServerUrlFailed => 'Failed to load server URL';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get noAccount => 'No account? Register now';

  @override
  String get bookName => 'Book Name';

  @override
  String get bookNameHint => 'Please enter book name';

  @override
  String get bookNameRequired => 'Book name is required';

  @override
  String get bookDescription => 'Description';

  @override
  String get bookDescriptionHint => 'Please enter description (optional)';

  @override
  String get currency => 'Currency';

  @override
  String get createBook => 'Create Book';

  @override
  String get createSuccess => 'Created successfully';

  @override
  String createFailed(Object error) {
    return 'Create failed: $error';
  }

  @override
  String get newShop => 'New Shop';

  @override
  String get editShop => 'Edit Shop';

  @override
  String get shopName => 'Shop Name';

  @override
  String get noDefaultBook => 'No default book selected';

  @override
  String get updateShopSuccess => 'Update successful';

  @override
  String get createShopSuccess => 'Create successful';

  @override
  String get shopNameRequired => 'Shop name is required';

  @override
  String get newCategory => 'New Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryNameRequired => 'Category name is required';

  @override
  String get updateCategorySuccess => 'Category updated successfully';

  @override
  String get createCategorySuccess => 'Category created successfully';

  @override
  String get newFund => 'New Account';

  @override
  String get editFund => 'Edit Account';

  @override
  String get fundName => 'Account Name';

  @override
  String get fundNameRequired => 'Account name is required';

  @override
  String get fundType => 'Account Type';

  @override
  String get updateFundSuccess => 'Update successful';

  @override
  String get createFundSuccess => 'Create successful';

  @override
  String get cash => 'Cash';

  @override
  String get bankCard => 'Bank Card';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get alipay => 'Alipay';

  @override
  String get wechat => 'WeChat Pay';

  @override
  String get other => 'Other';

  @override
  String get filter => 'Filter';

  @override
  String get noAccountItems => 'No transactions yet';

  @override
  String get newRecord => 'New Record';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String monthDayFormat(String month, String day) {
    return '$month/$day';
  }

  @override
  String get filterConditions => 'Filter Conditions';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get type => 'Type';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get category => 'Category';

  @override
  String selectedCount(Object count) {
    return '$count Selected';
  }

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get filtered => 'Filtered';

  @override
  String get totalIncome => 'Income';

  @override
  String get totalExpense => 'Expense';

  @override
  String get balance => 'Balance';

  @override
  String get accountBookList => 'Transactions';

  @override
  String get newAccountBook => 'New Account Book';

  @override
  String get retryLoading => 'Retry';

  @override
  String get noAccountBooks => 'No account books';

  @override
  String get unnamedBook => 'Unnamed Book';

  @override
  String sharedFrom(Object name) {
    return 'Shared from $name';
  }

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get serverAddress => 'Server Address';

  @override
  String serverStatusNormal(Object dbStatus, Object memTotal, Object memUsed) {
    return 'Server Status: OK\nDatabase: $dbStatus\nMemory: $memUsed/$memTotal';
  }

  @override
  String serverStatusError(Object error) {
    return 'Server Error: $error';
  }

  @override
  String get pleaseInputServerUrl => 'Please input server address';

  @override
  String get saveSuccess => 'Configuration saved';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get restartAppAfterChange => 'Modified, please restart the app to take effect';

  @override
  String get checkServer => 'Check Connection';

  @override
  String linkedBooksCount(Object count) {
    return '$count linked books';
  }

  @override
  String get editFundTitle => 'Edit Account';

  @override
  String get newFundTitle => 'New Account';

  @override
  String get linkedBooks => 'Linked Books';

  @override
  String lastUpdated(Object time) {
    return 'Last Updated: $time';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountRemark => 'Account Remark';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get pleaseInputAccountName => 'Please input account name';

  @override
  String get fundIncome => 'Income';

  @override
  String get fundExpense => 'Expense';

  @override
  String get checkButton => 'Check';

  @override
  String get saveButton => 'Save';

  @override
  String get serverUrlLabel => 'Server URL';

  @override
  String get serverUrlHint => 'e.g. https://api.example.com';

  @override
  String get normalStatus => 'Normal';

  @override
  String get categoryTitle => 'Category Management';

  @override
  String get addCategory => 'Add Category';

  @override
  String get noCategories => 'No categories yet';

  @override
  String get create => 'Create';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get save => 'Save';

  @override
  String get bookNameLabel => 'Book Name';

  @override
  String get bookDescriptionLabel => 'Book Description';

  @override
  String get creatorLabel => 'Creator';

  @override
  String get createTimeLabel => 'Create Time';

  @override
  String get unknownTime => 'Unknown';

  @override
  String get memberManagement => 'Member Management';

  @override
  String get addMember => 'Add Member';

  @override
  String get unknownMember => 'Unknown User';

  @override
  String get creator => 'Creator';

  @override
  String get confirmRemoveMember => 'Confirm Remove';

  @override
  String get confirmRemoveMemberMessage => 'Are you sure to remove this member?';

  @override
  String get delete => 'Delete';

  @override
  String get addMemberTitle => 'Add Member';

  @override
  String get inviteCodeLabel => 'Invite Code';

  @override
  String get inviteCodeHint => 'Please enter invite code';

  @override
  String get add => 'Add';

  @override
  String get memberAlreadyExists => 'Member already exists';

  @override
  String get addMemberSuccess => 'Member added successfully';

  @override
  String addMemberFailed(Object error) {
    return 'Failed to add member: $error';
  }

  @override
  String get permViewBook => 'View Book';

  @override
  String get permEditBook => 'Edit Book';

  @override
  String get permDeleteBook => 'Delete Book';

  @override
  String get permViewItem => 'View Records';

  @override
  String get permEditItem => 'Edit Records';

  @override
  String get permDeleteItem => 'Delete Records';

  @override
  String get shopManagementTitle => 'Shop Management';

  @override
  String get newShopButton => 'New Shop';

  @override
  String get newShopTitle => 'New Shop';

  @override
  String get editShopTitle => 'Edit Shop';

  @override
  String get shopNameLabel => 'Shop Name';

  @override
  String get userInfoTitle => 'User Info';

  @override
  String get editUserInfo => 'Edit User Info';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get resetInviteCode => 'Reset Invite Code';

  @override
  String get resetInviteCodeSuccess => 'Reset successful';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get updateUserInfoSuccess => 'Update successful';

  @override
  String registerTimeLabel(Object time) {
    return 'Register time: $time';
  }

  @override
  String get nicknameRequired => 'Nickname is required';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get invalidPhoneFormat => 'Invalid phone number format';

  @override
  String get confirmLogoutTitle => 'Confirm Logout';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to logout?';

  @override
  String get newRecordTitle => 'New Record';

  @override
  String get editRecordTitle => 'Edit Record';

  @override
  String get expenseType => 'Expense';

  @override
  String get incomeType => 'Income';

  @override
  String get pleaseInputAmount => 'Please input amount';

  @override
  String get pleaseSelectCategory => 'Please select category';

  @override
  String get pleaseSelectAccount => 'Please select account';

  @override
  String get pleaseSelectBook => 'Please select book';

  @override
  String get saveRecord => 'Save';

  @override
  String get saveRecordSuccess => 'Save successful';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountHint => 'Please input amount';

  @override
  String get categoryLabel => 'Category';

  @override
  String get categoryHint => 'Please select category';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get accountLabel => 'Account';

  @override
  String get accountHint => 'Please select account';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Please input description (optional)';

  @override
  String get shopLabel => 'Shop';

  @override
  String get shopHint => 'Please select shop';

  @override
  String get selectFund => 'Select Account';

  @override
  String get noAvailableFunds => 'No available accounts';

  @override
  String get defaultFund => 'Default Account';

  @override
  String get searchFund => 'Search accounts';

  @override
  String get selectFundHint => 'Please select account';

  @override
  String get selectBookTitle => 'Select Book';

  @override
  String get noAvailableBooks => 'No available books';

  @override
  String get defaultBook => 'Default Book';

  @override
  String get searchBook => 'Search books';

  @override
  String get selectBookHint => 'Please select book';

  @override
  String get sharedBook => 'Shared Book';

  @override
  String get selectBookHeader => 'Select Book';

  @override
  String get sharedBookLabel => 'Shared';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get selectCategoryTitle => 'Select Category';

  @override
  String get noAvailableCategories => 'No available categories';

  @override
  String get searchCategoryHint => 'Search or input new category';

  @override
  String get selectShopTitle => 'Select Shop';

  @override
  String get noAvailableShops => 'No available shops';

  @override
  String get searchShopHint => 'Search or input new shop';

  @override
  String addButtonWith(Object name) {
    return 'Add \"$name\"';
  }

  @override
  String get summaryIncome => 'Income';

  @override
  String get summaryExpense => 'Expense';

  @override
  String get summaryBalance => 'Balance';

  @override
  String get currencySymbol => '¥';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get statistics => 'Statistics';

  @override
  String get statisticsTimeRange => 'Time Range';

  @override
  String get statisticsWeek => 'Week';

  @override
  String get statisticsMonth => 'Month';

  @override
  String get statisticsYear => 'Year';

  @override
  String get statisticsCustom => 'Custom';

  @override
  String get statisticsOverview => 'Overview';

  @override
  String get statisticsTrend => 'Trend';

  @override
  String get statisticsExpenseByCategory => 'Expense by Category';

  @override
  String get statisticsIncomeByCategory => 'Income by Category';

  @override
  String get statisticsNoData => 'No Data';

  @override
  String get chartTypeLine => 'Line';

  @override
  String get chartTypeBar => 'Bar';

  @override
  String get chartTypeArea => 'Area';

  @override
  String get chartTypeStacked => 'Stacked';

  @override
  String get chartNoData => 'No data available';

  @override
  String get metricAmount => 'Amount';

  @override
  String get metricCount => 'Count';

  @override
  String get metricAverage => 'Average';

  @override
  String metricUnit(Object unit) {
    return '$unit';
  }

  @override
  String get serverManagement => 'Server Management';

  @override
  String get addServer => 'Add Server';

  @override
  String get edit => 'Edit';

  @override
  String get confirmDeleteServer => 'Delete Server';

  @override
  String confirmDeleteServerMessage(String name) {
    return 'Are you sure you want to delete server \"$name\"?';
  }

  @override
  String get pleaseSelectServer => 'Server selection required';

  @override
  String loginFailed(String error) {
    return 'Authentication failed: $error';
  }

  @override
  String get wrongCredentials => 'Invalid username or password';

  @override
  String get rememberLogin => 'Remember credentials';

  @override
  String get selectServer => 'Select Server';

  @override
  String get serverName => 'Server Name';

  @override
  String get serverNameHint => 'e.g. Production Server';

  @override
  String get serverNameRequired => 'Server name is required';

  @override
  String get serverType => 'Server Type';

  @override
  String get serverUrlRequired => 'Server URL is required';

  @override
  String serverTypeLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'selfHosted': 'Self-hosted',
        'clsswjzCloud': 'Clssw Cloud',
        'localStorage': 'Local Storage',
        'other': 'Unknown',
      },
    );
    return '$_temp0';
  }

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get shop => 'Shop';

  @override
  String get noFund => 'No Account';

  @override
  String get noShop => 'No Shop';

  @override
  String get more => 'More';

  @override
  String get confirmDeleteMessage => 'Are you sure you want to delete this record?';

  @override
  String get deleteSuccess => 'Delete successful';

  @override
  String get pleaseSelectItems => 'Please select at least one item';

  @override
  String confirmBatchDeleteMessage(int count) {
    return 'Are you sure you want to delete $count items?';
  }

  @override
  String batchDeleteSuccess(int count) {
    return 'Successfully deleted $count items';
  }

  @override
  String get checkingServerStatus => 'Checking server status...';

  @override
  String get serverCheckFailed => 'Server Check Failed';

  @override
  String get serverCheckFailedMessage => 'Failed to connect to server. Please check your network connection and try again.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get retry => 'Retry';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get projectInfo => 'Project Information';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get latestRelease => 'Latest Release';

  @override
  String get downloadLatestVersion => 'Download latest version';

  @override
  String get technicalInfo => 'Technical Information';

  @override
  String get flutterDescription => 'Cross-platform UI framework by Google';

  @override
  String get materialDescription => 'Modern design system for Flutter';

  @override
  String get providerDescription => 'State management solution for Flutter';

  @override
  String get license => 'License';

  @override
  String get mitLicenseDescription => 'Open source under MIT License';

  @override
  String get support => 'Support';

  @override
  String get technicalSupport => 'Technical Support';

  @override
  String get loadingMore => 'Loading more...';

  @override
  String get noMoreData => 'No more data';

  @override
  String get importData => 'Import Data';

  @override
  String get dataSource => 'Data Source';

  @override
  String get selectFile => 'Select File';

  @override
  String get importFieldsRequired => 'Please fill in all required fields';

  @override
  String get importSuccess => 'Import successful';

  @override
  String get selectBook => 'Select Account Book';

  @override
  String importSuccessCount(String count) {
    return 'Successfully imported $count records';
  }

  @override
  String get importErrors => 'The following errors occurred during import:';

  @override
  String get attachments => 'Attachments';

  @override
  String get addAttachment => 'Add Attachment';

  @override
  String get selectFiles => 'Select Files';

  @override
  String get fileUploadFailed => 'File upload failed';

  @override
  String maxFileSize(String size) {
    return 'File size cannot exceed ${size}MB';
  }

  @override
  String fileSelectFailed(String error) {
    return 'Failed to select file: $error';
  }

  @override
  String get fileOpenFailed => 'Failed to open file';

  @override
  String downloadProgress(String progress) {
    return 'Downloading... $progress%';
  }

  @override
  String get editServer => 'Edit Server';

  @override
  String get openInExternalApp => 'Open in external app';

  @override
  String get download => 'Download';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String downloadFailedMessage(String error) {
    return 'Failed to download file: $error';
  }

  @override
  String get unsupportedPreview => 'Unsupported preview';

  @override
  String fileDownloaded(String path) {
    return 'File downloaded to $path';
  }

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get clear => 'Clear';

  @override
  String get selectShopHint => 'Select shop';

  @override
  String get noCategory => 'No Category';

  @override
  String get selectTagHint => 'Tag';

  @override
  String get selectTagTitle => 'Tag';

  @override
  String get searchTagHint => 'Search tags';

  @override
  String get selectProjectHint => 'Project';

  @override
  String get selectProjectTitle => 'Project';

  @override
  String get searchProjectHint => 'Search projects';

  @override
  String get noEditPermission => 'You don\'t have permission to edit';
}
