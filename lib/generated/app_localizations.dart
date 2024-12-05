import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Account Book'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// No description provided for @categoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// No description provided for @shopManagement.
  ///
  /// In en, this message translates to:
  /// **'Shop Management'**
  String get shopManagement;

  /// No description provided for @fundManagement.
  ///
  /// In en, this message translates to:
  /// **'Fund Management'**
  String get fundManagement;

  /// No description provided for @createAccountBook.
  ///
  /// In en, this message translates to:
  /// **'Create Account Book'**
  String get createAccountBook;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get userInfo;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @timezoneSettings.
  ///
  /// In en, this message translates to:
  /// **'Timezone Settings'**
  String get timezoneSettings;

  /// No description provided for @inviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCode;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset successful'**
  String get resetSuccess;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateSuccess;

  /// No description provided for @registerTime.
  ///
  /// In en, this message translates to:
  /// **'Register time: {time}'**
  String registerTime(Object time);

  /// No description provided for @developerMode.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get developerMode;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Nickname is required'**
  String get nicknameRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalidPhone;

  /// No description provided for @merchantManagement.
  ///
  /// In en, this message translates to:
  /// **'Merchant Management'**
  String get merchantManagement;

  /// No description provided for @themeColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColorTitle;

  /// No description provided for @themeColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite theme color'**
  String get themeColorSubtitle;

  /// No description provided for @loadServerUrlFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load server URL'**
  String get loadServerUrlFailed;

  /// No description provided for @serverUrlHint.
  ///
  /// In en, this message translates to:
  /// **'http://example.com:3000'**
  String get serverUrlHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Register now'**
  String get noAccount;

  /// No description provided for @bookName.
  ///
  /// In en, this message translates to:
  /// **'Book Name'**
  String get bookName;

  /// No description provided for @bookNameHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter book name'**
  String get bookNameHint;

  /// No description provided for @bookNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Book name is required'**
  String get bookNameRequired;

  /// No description provided for @bookDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get bookDescription;

  /// No description provided for @bookDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter description (optional)'**
  String get bookDescriptionHint;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @createBook.
  ///
  /// In en, this message translates to:
  /// **'Create Book'**
  String get createBook;

  /// No description provided for @createSuccess.
  ///
  /// In en, this message translates to:
  /// **'Created successfully'**
  String get createSuccess;

  /// No description provided for @createFailed.
  ///
  /// In en, this message translates to:
  /// **'Create failed: {error}'**
  String createFailed(Object error);

  /// No description provided for @newShop.
  ///
  /// In en, this message translates to:
  /// **'New Shop'**
  String get newShop;

  /// No description provided for @editShop.
  ///
  /// In en, this message translates to:
  /// **'Edit Shop'**
  String get editShop;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// No description provided for @noDefaultBook.
  ///
  /// In en, this message translates to:
  /// **'No default account book selected'**
  String get noDefaultBook;

  /// No description provided for @updateShopSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateShopSuccess;

  /// No description provided for @createShopSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successful'**
  String get createShopSuccess;

  /// No description provided for @shopNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop name is required'**
  String get shopNameRequired;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryNameRequired;

  /// No description provided for @updateCategorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateCategorySuccess;

  /// No description provided for @createCategorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successful'**
  String get createCategorySuccess;

  /// No description provided for @newFund.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newFund;

  /// No description provided for @editFund.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editFund;

  /// No description provided for @fundName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get fundName;

  /// No description provided for @fundNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Account name is required'**
  String get fundNameRequired;

  /// No description provided for @fundType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get fundType;

  /// No description provided for @updateFundSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateFundSuccess;

  /// No description provided for @createFundSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successful'**
  String get createFundSuccess;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bankCard.
  ///
  /// In en, this message translates to:
  /// **'Bank Card'**
  String get bankCard;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @alipay.
  ///
  /// In en, this message translates to:
  /// **'Alipay'**
  String get alipay;

  /// No description provided for @wechat.
  ///
  /// In en, this message translates to:
  /// **'WeChat Pay'**
  String get wechat;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @noAccountItems.
  ///
  /// In en, this message translates to:
  /// **'No account records'**
  String get noAccountItems;

  /// No description provided for @newRecord.
  ///
  /// In en, this message translates to:
  /// **'New Record'**
  String get newRecord;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @monthDayFormat.
  ///
  /// In en, this message translates to:
  /// **'{month}/{day}'**
  String monthDayFormat(Object day, Object month);

  /// No description provided for @filterConditions.
  ///
  /// In en, this message translates to:
  /// **'Filter Conditions'**
  String get filterConditions;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String selectedCount(Object count);

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @filtered.
  ///
  /// In en, this message translates to:
  /// **'Filtered'**
  String get filtered;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get totalExpense;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Account book list page title
  ///
  /// In en, this message translates to:
  /// **'Account Books'**
  String get accountBookList;

  /// New account book button tooltip
  ///
  /// In en, this message translates to:
  /// **'New Account Book'**
  String get newAccountBook;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLoading;

  /// Message when no account books exist
  ///
  /// In en, this message translates to:
  /// **'No account books'**
  String get noAccountBooks;

  /// Default name for unnamed book
  ///
  /// In en, this message translates to:
  /// **'Unnamed Book'**
  String get unnamedBook;

  /// Shared book indicator
  ///
  /// In en, this message translates to:
  /// **'Shared from {name}'**
  String sharedFrom(String name);

  /// Default name for unknown user
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// Server address input label
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// Server status check result when normal
  ///
  /// In en, this message translates to:
  /// **'Server Status: Normal\nDatabase Status: {dbStatus}\nMemory Usage: {memUsed}/{memTotal}'**
  String serverStatusNormal(String dbStatus, String memUsed, String memTotal);

  /// Server status check result when error
  ///
  /// In en, this message translates to:
  /// **'Server Error: {error}'**
  String serverStatusError(String error);

  /// Server address input hint
  ///
  /// In en, this message translates to:
  /// **'Please input server address'**
  String get pleaseInputServerUrl;

  /// Save success message
  ///
  /// In en, this message translates to:
  /// **'Save successful'**
  String get saveSuccess;

  /// Save server url failed message
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(String error);

  /// No description provided for @restartAppAfterChange.
  ///
  /// In en, this message translates to:
  /// **'Modified, please restart the app to take effect'**
  String get restartAppAfterChange;

  /// No description provided for @checkServer.
  ///
  /// In en, this message translates to:
  /// **'Check Server'**
  String get checkServer;

  /// Number of linked account books
  ///
  /// In en, this message translates to:
  /// **'{count} linked books'**
  String linkedBooksCount(int count);

  /// Title for edit fund page
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editFundTitle;

  /// Title for new fund page
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newFundTitle;

  /// Title for linked books section
  ///
  /// In en, this message translates to:
  /// **'Linked Books'**
  String get linkedBooks;

  /// Last updated time
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {time}'**
  String lastUpdated(String time);

  /// Text for unknown value
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Basic information section title
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// Account name field label
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// Account remark field label
  ///
  /// In en, this message translates to:
  /// **'Account Remark'**
  String get accountRemark;

  /// Current balance field label
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// Account name required error message
  ///
  /// In en, this message translates to:
  /// **'Please input account name'**
  String get pleaseInputAccountName;

  /// Fund income filter chip label
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get fundIncome;

  /// Fund expense filter chip label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get fundExpense;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return AppLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
