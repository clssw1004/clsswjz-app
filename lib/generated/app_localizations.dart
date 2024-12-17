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
  /// **'CLSSW Account'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account'**
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
  /// **'Category'**
  String get categoryManagement;

  /// No description provided for @shopManagement.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopManagement;

  /// No description provided for @fundManagement.
  ///
  /// In en, this message translates to:
  /// **'Fund'**
  String get fundManagement;

  /// No description provided for @createAccountBook.
  ///
  /// In en, this message translates to:
  /// **'Create Account Book'**
  String get createAccountBook;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server Configuration'**
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
  /// **'No default book selected'**
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
  /// **'Category updated successfully'**
  String get updateCategorySuccess;

  /// No description provided for @createCategorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Category created successfully'**
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
  /// **'No transactions yet'**
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
  String monthDayFormat(String month, String day);

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

  /// No description provided for @accountBookList.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get accountBookList;

  /// No description provided for @newAccountBook.
  ///
  /// In en, this message translates to:
  /// **'New Account Book'**
  String get newAccountBook;

  /// No description provided for @retryLoading.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLoading;

  /// No description provided for @noAccountBooks.
  ///
  /// In en, this message translates to:
  /// **'No account books'**
  String get noAccountBooks;

  /// No description provided for @unnamedBook.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Book'**
  String get unnamedBook;

  /// No description provided for @sharedFrom.
  ///
  /// In en, this message translates to:
  /// **'Shared from {name}'**
  String sharedFrom(Object name);

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// No description provided for @serverStatusNormal.
  ///
  /// In en, this message translates to:
  /// **'Server Status: OK\nDatabase: {dbStatus}\nMemory: {memUsed}/{memTotal}'**
  String serverStatusNormal(Object dbStatus, Object memTotal, Object memUsed);

  /// No description provided for @serverStatusError.
  ///
  /// In en, this message translates to:
  /// **'Server Error: {error}'**
  String serverStatusError(Object error);

  /// No description provided for @pleaseInputServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Please input server address'**
  String get pleaseInputServerUrl;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved'**
  String get saveSuccess;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(Object error);

  /// No description provided for @restartAppAfterChange.
  ///
  /// In en, this message translates to:
  /// **'Modified, please restart the app to take effect'**
  String get restartAppAfterChange;

  /// No description provided for @checkServer.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get checkServer;

  /// No description provided for @linkedBooksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} linked books'**
  String linkedBooksCount(Object count);

  /// No description provided for @editFundTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editFundTitle;

  /// No description provided for @newFundTitle.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newFundTitle;

  /// No description provided for @linkedBooks.
  ///
  /// In en, this message translates to:
  /// **'Linked Books'**
  String get linkedBooks;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {time}'**
  String lastUpdated(Object time);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @accountRemark.
  ///
  /// In en, this message translates to:
  /// **'Account Remark'**
  String get accountRemark;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @pleaseInputAccountName.
  ///
  /// In en, this message translates to:
  /// **'Please input account name'**
  String get pleaseInputAccountName;

  /// No description provided for @fundIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get fundIncome;

  /// No description provided for @fundExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get fundExpense;

  /// No description provided for @checkButton.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @serverUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrlLabel;

  /// No description provided for @serverUrlHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. https://api.example.com'**
  String get serverUrlHint;

  /// No description provided for @normalStatus.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalStatus;

  /// No description provided for @categoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryTitle;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategories;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @bookDetails.
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get bookDetails;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @bookNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Book Name'**
  String get bookNameLabel;

  /// No description provided for @bookDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Book Description'**
  String get bookDescriptionLabel;

  /// No description provided for @creatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creatorLabel;

  /// No description provided for @createTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Create Time'**
  String get createTimeLabel;

  /// No description provided for @unknownTime.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownTime;

  /// No description provided for @memberManagement.
  ///
  /// In en, this message translates to:
  /// **'Member Management'**
  String get memberManagement;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @unknownMember.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownMember;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @confirmRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Confirm Remove'**
  String get confirmRemoveMember;

  /// No description provided for @confirmRemoveMemberMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove this member?'**
  String get confirmRemoveMemberMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @addMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMemberTitle;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCodeLabel;

  /// No description provided for @inviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter invite code'**
  String get inviteCodeHint;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @memberAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Member already exists'**
  String get memberAlreadyExists;

  /// No description provided for @addMemberSuccess.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get addMemberSuccess;

  /// No description provided for @addMemberFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add member: {error}'**
  String addMemberFailed(Object error);

  /// No description provided for @permViewBook.
  ///
  /// In en, this message translates to:
  /// **'View Book'**
  String get permViewBook;

  /// No description provided for @permEditBook.
  ///
  /// In en, this message translates to:
  /// **'Edit Book'**
  String get permEditBook;

  /// No description provided for @permDeleteBook.
  ///
  /// In en, this message translates to:
  /// **'Delete Book'**
  String get permDeleteBook;

  /// No description provided for @permViewItem.
  ///
  /// In en, this message translates to:
  /// **'View Records'**
  String get permViewItem;

  /// No description provided for @permEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Records'**
  String get permEditItem;

  /// No description provided for @permDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Records'**
  String get permDeleteItem;

  /// No description provided for @shopManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop Management'**
  String get shopManagementTitle;

  /// No description provided for @newShopButton.
  ///
  /// In en, this message translates to:
  /// **'New Shop'**
  String get newShopButton;

  /// No description provided for @newShopTitle.
  ///
  /// In en, this message translates to:
  /// **'New Shop'**
  String get newShopTitle;

  /// No description provided for @editShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Shop'**
  String get editShopTitle;

  /// No description provided for @shopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopNameLabel;

  /// No description provided for @userInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get userInfoTitle;

  /// No description provided for @editUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit User Info'**
  String get editUserInfo;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @resetInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Reset Invite Code'**
  String get resetInviteCode;

  /// No description provided for @resetInviteCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset successful'**
  String get resetInviteCodeSuccess;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @updateUserInfoSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateUserInfoSuccess;

  /// No description provided for @registerTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Register time: {time}'**
  String registerTimeLabel(Object time);

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Nickname is required'**
  String get nicknameRequired;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @invalidPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalidPhoneFormat;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogoutMessage;

  /// No description provided for @newRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'New Record'**
  String get newRecordTitle;

  /// No description provided for @editRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get editRecordTitle;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseType;

  /// No description provided for @incomeType.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeType;

  /// No description provided for @pleaseInputAmount.
  ///
  /// In en, this message translates to:
  /// **'Please input amount'**
  String get pleaseInputAmount;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectAccount.
  ///
  /// In en, this message translates to:
  /// **'Please select account'**
  String get pleaseSelectAccount;

  /// No description provided for @pleaseSelectBook.
  ///
  /// In en, this message translates to:
  /// **'Please select book'**
  String get pleaseSelectBook;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveRecord;

  /// No description provided for @saveRecordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Save successful'**
  String get saveRecordSuccess;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'Please input amount'**
  String get amountHint;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'Please select category'**
  String get categoryHint;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @accountHint.
  ///
  /// In en, this message translates to:
  /// **'Please select account'**
  String get accountHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please input description (optional)'**
  String get descriptionHint;

  /// No description provided for @shopLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopLabel;

  /// No description provided for @shopHint.
  ///
  /// In en, this message translates to:
  /// **'Please select shop'**
  String get shopHint;

  /// No description provided for @selectFund.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get selectFund;

  /// No description provided for @noAvailableFunds.
  ///
  /// In en, this message translates to:
  /// **'No available accounts'**
  String get noAvailableFunds;

  /// No description provided for @defaultFund.
  ///
  /// In en, this message translates to:
  /// **'Default Account'**
  String get defaultFund;

  /// No description provided for @searchFund.
  ///
  /// In en, this message translates to:
  /// **'Search accounts'**
  String get searchFund;

  /// No description provided for @selectFundHint.
  ///
  /// In en, this message translates to:
  /// **'Please select account'**
  String get selectFundHint;

  /// No description provided for @selectBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Book'**
  String get selectBookTitle;

  /// No description provided for @noAvailableBooks.
  ///
  /// In en, this message translates to:
  /// **'No available books'**
  String get noAvailableBooks;

  /// No description provided for @defaultBook.
  ///
  /// In en, this message translates to:
  /// **'Default Book'**
  String get defaultBook;

  /// No description provided for @searchBook.
  ///
  /// In en, this message translates to:
  /// **'Search books'**
  String get searchBook;

  /// No description provided for @selectBookHint.
  ///
  /// In en, this message translates to:
  /// **'Please select book'**
  String get selectBookHint;

  /// No description provided for @sharedBook.
  ///
  /// In en, this message translates to:
  /// **'Shared Book'**
  String get sharedBook;

  /// No description provided for @selectBookHeader.
  ///
  /// In en, this message translates to:
  /// **'Select Book'**
  String get selectBookHeader;

  /// No description provided for @sharedBookLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get sharedBookLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @selectCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategoryTitle;

  /// No description provided for @noAvailableCategories.
  ///
  /// In en, this message translates to:
  /// **'No available categories'**
  String get noAvailableCategories;

  /// No description provided for @searchCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search or input new category'**
  String get searchCategoryHint;

  /// No description provided for @selectShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Shop'**
  String get selectShopTitle;

  /// No description provided for @noAvailableShops.
  ///
  /// In en, this message translates to:
  /// **'No available shops'**
  String get noAvailableShops;

  /// No description provided for @searchShopHint.
  ///
  /// In en, this message translates to:
  /// **'Search or input new shop'**
  String get searchShopHint;

  /// No description provided for @addButtonWith.
  ///
  /// In en, this message translates to:
  /// **'Add \"{name}\"'**
  String addButtonWith(Object name);

  /// No description provided for @summaryIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get summaryIncome;

  /// No description provided for @summaryExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get summaryExpense;

  /// No description provided for @summaryBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get summaryBalance;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'¥'**
  String get currencySymbol;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @statisticsTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get statisticsTimeRange;

  /// No description provided for @statisticsWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statisticsWeek;

  /// No description provided for @statisticsMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statisticsMonth;

  /// No description provided for @statisticsYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statisticsYear;

  /// No description provided for @statisticsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get statisticsCustom;

  /// No description provided for @statisticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get statisticsOverview;

  /// No description provided for @statisticsTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get statisticsTrend;

  /// No description provided for @statisticsExpenseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense by Category'**
  String get statisticsExpenseByCategory;

  /// No description provided for @statisticsIncomeByCategory.
  ///
  /// In en, this message translates to:
  /// **'Income by Category'**
  String get statisticsIncomeByCategory;

  /// No description provided for @statisticsNoData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get statisticsNoData;

  /// No description provided for @chartTypeLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get chartTypeLine;

  /// No description provided for @chartTypeBar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get chartTypeBar;

  /// No description provided for @chartTypeArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get chartTypeArea;

  /// No description provided for @chartTypeStacked.
  ///
  /// In en, this message translates to:
  /// **'Stacked'**
  String get chartTypeStacked;

  /// No description provided for @chartNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get chartNoData;

  /// No description provided for @metricAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get metricAmount;

  /// No description provided for @metricCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get metricCount;

  /// No description provided for @metricAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get metricAverage;

  /// No description provided for @metricUnit.
  ///
  /// In en, this message translates to:
  /// **'{unit}'**
  String metricUnit(Object unit);

  /// No description provided for @serverManagement.
  ///
  /// In en, this message translates to:
  /// **'Server Management'**
  String get serverManagement;

  /// No description provided for @addServer.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get addServer;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirmDeleteServer.
  ///
  /// In en, this message translates to:
  /// **'Delete Server'**
  String get confirmDeleteServer;

  /// No description provided for @confirmDeleteServerMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete server \"{name}\"?'**
  String confirmDeleteServerMessage(String name);

  /// No description provided for @pleaseSelectServer.
  ///
  /// In en, this message translates to:
  /// **'Server selection required'**
  String get pleaseSelectServer;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed: {error}'**
  String loginFailed(String error);

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get wrongCredentials;

  /// No description provided for @rememberLogin.
  ///
  /// In en, this message translates to:
  /// **'Remember credentials'**
  String get rememberLogin;

  /// No description provided for @selectServer.
  ///
  /// In en, this message translates to:
  /// **'Select Server'**
  String get selectServer;

  /// No description provided for @serverName.
  ///
  /// In en, this message translates to:
  /// **'Server Name'**
  String get serverName;

  /// No description provided for @serverNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Production Server'**
  String get serverNameHint;

  /// No description provided for @serverNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Server name is required'**
  String get serverNameRequired;

  /// No description provided for @serverType.
  ///
  /// In en, this message translates to:
  /// **'Server Type'**
  String get serverType;

  /// No description provided for @serverUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Server URL is required'**
  String get serverUrlRequired;

  /// No description provided for @serverTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{type, select, selfHosted{Self-hosted} clsswjzCloud{Clssw Cloud} localStorage{Local Storage} other{Unknown}}'**
  String serverTypeLabel(String type);

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @noFund.
  ///
  /// In en, this message translates to:
  /// **'No Account'**
  String get noFund;

  /// No description provided for @noShop.
  ///
  /// In en, this message translates to:
  /// **'No Shop'**
  String get noShop;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get confirmDeleteMessage;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delete successful'**
  String get deleteSuccess;

  /// No description provided for @pleaseSelectItems.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one item'**
  String get pleaseSelectItems;

  /// No description provided for @confirmBatchDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} items?'**
  String confirmBatchDeleteMessage(int count);

  /// No description provided for @batchDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted {count} items'**
  String batchDeleteSuccess(int count);

  /// No description provided for @checkingServerStatus.
  ///
  /// In en, this message translates to:
  /// **'Checking server status...'**
  String get checkingServerStatus;

  /// No description provided for @serverCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Server Check Failed'**
  String get serverCheckFailed;

  /// No description provided for @serverCheckFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to server. Please check your network connection and try again.'**
  String get serverCheckFailedMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @projectInfo.
  ///
  /// In en, this message translates to:
  /// **'Project Information'**
  String get projectInfo;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCode;

  /// No description provided for @latestRelease.
  ///
  /// In en, this message translates to:
  /// **'Latest Release'**
  String get latestRelease;

  /// No description provided for @downloadLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Download latest version'**
  String get downloadLatestVersion;

  /// No description provided for @technicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Technical Information'**
  String get technicalInfo;

  /// No description provided for @flutterDescription.
  ///
  /// In en, this message translates to:
  /// **'Cross-platform UI framework by Google'**
  String get flutterDescription;

  /// No description provided for @materialDescription.
  ///
  /// In en, this message translates to:
  /// **'Modern design system for Flutter'**
  String get materialDescription;

  /// No description provided for @providerDescription.
  ///
  /// In en, this message translates to:
  /// **'State management solution for Flutter'**
  String get providerDescription;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @mitLicenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Open source under MIT License'**
  String get mitLicenseDescription;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get technicalSupport;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No description provided for @noMoreData.
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get noMoreData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get dataSource;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @importFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get importFieldsRequired;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccess;

  /// No description provided for @selectBook.
  ///
  /// In en, this message translates to:
  /// **'Select Account Book'**
  String get selectBook;

  /// No description provided for @importSuccessCount.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} records'**
  String importSuccessCount(String count);

  /// No description provided for @importErrors.
  ///
  /// In en, this message translates to:
  /// **'The following errors occurred during import:'**
  String get importErrors;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get addAttachment;

  /// No description provided for @selectFiles.
  ///
  /// In en, this message translates to:
  /// **'Select Files'**
  String get selectFiles;

  /// No description provided for @fileUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'File upload failed'**
  String get fileUploadFailed;

  /// No description provided for @maxFileSize.
  ///
  /// In en, this message translates to:
  /// **'File size cannot exceed {size}MB'**
  String maxFileSize(String size);

  /// No description provided for @fileSelectFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select file: {error}'**
  String fileSelectFailed(String error);

  /// No description provided for @fileOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open file'**
  String get fileOpenFailed;

  /// No description provided for @downloadProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading... {progress}%'**
  String downloadProgress(String progress);

  /// No description provided for @editServer.
  ///
  /// In en, this message translates to:
  /// **'Edit Server'**
  String get editServer;

  /// No description provided for @openInExternalApp.
  ///
  /// In en, this message translates to:
  /// **'Open in external app'**
  String get openInExternalApp;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @downloadFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to download file: {error}'**
  String downloadFailedMessage(String error);

  /// No description provided for @unsupportedPreview.
  ///
  /// In en, this message translates to:
  /// **'Unsupported preview'**
  String get unsupportedPreview;

  /// No description provided for @fileDownloaded.
  ///
  /// In en, this message translates to:
  /// **'File downloaded to {path}'**
  String fileDownloaded(String path);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @selectShopHint.
  ///
  /// In en, this message translates to:
  /// **'Select shop'**
  String get selectShopHint;
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
