import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Account Book';

  @override
  String get settings => 'Settings';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get shopManagement => 'Shop Management';

  @override
  String get fundManagement => 'Fund Management';

  @override
  String get createAccountBook => 'Create Account Book';

  @override
  String get serverSettings => 'Server Settings';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to logout?';

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
  String registerTime(String time) {
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
  String get save => 'Save';

  @override
  String get nicknameRequired => 'Nickname is required';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get invalidPhone => 'Invalid phone number format';

  @override
  String get merchantManagement => 'Merchant Management';

  @override
  String get serverUrlRequired => 'Server URL is required';

  @override
  String get serverStatusNormal => 'Server status: Normal';

  @override
  String get serverStatusError => 'Server status: Error';

  @override
  String get databaseStatus => 'Database status';

  @override
  String get memoryUsage => 'Memory usage';

  @override
  String get saveSuccessRestartRequired => 'Save successful, please restart the app';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get themeColorTitle => 'Theme Color';

  @override
  String get themeColorSubtitle => 'Choose your favorite theme color';

  @override
  String get loadServerUrlFailed => 'Failed to load server URL';

  @override
  String get serverUrlHint => 'http://example.com:3000';

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
  String createFailed(String error) {
    return 'Create failed: $error';
  }

  @override
  String get newShop => 'New Shop';

  @override
  String get editShop => 'Edit Shop';

  @override
  String get shopName => 'Shop Name';

  @override
  String get noDefaultBook => 'No default account book selected';

  @override
  String get updateShopSuccess => 'Shop updated successfully';

  @override
  String get createShopSuccess => 'Shop created successfully';

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
  String get updateFundSuccess => 'Account updated successfully';

  @override
  String get createFundSuccess => 'Account created successfully';

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
  String get accountBookList => 'Account Books';

  @override
  String get newAccountBook => 'New Account Book';

  @override
  String get retryLoading => 'Retry';

  @override
  String get loadAccountBooksFailed => 'Failed to load account books';

  @override
  String get noAccountBooks => 'No account books';

  @override
  String get unnamedBook => 'Unnamed Book';

  @override
  String sharedFrom(String name) {
    return 'Shared from $name';
  }

  @override
  String get unknownUser => 'Unknown User';
}
