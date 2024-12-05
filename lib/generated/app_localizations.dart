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

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Account Book'**
  String get appName;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Account management section title
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// Theme settings section title
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// System settings section title
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// Category management menu item
  ///
  /// In en, this message translates to:
  /// **'Category Management'**
  String get categoryManagement;

  /// Shop management menu item
  ///
  /// In en, this message translates to:
  /// **'Shop Management'**
  String get shopManagement;

  /// Fund management menu item
  ///
  /// In en, this message translates to:
  /// **'Fund Management'**
  String get fundManagement;

  /// Create account book menu item
  ///
  /// In en, this message translates to:
  /// **'Create Account Book'**
  String get createAccountBook;

  /// Server settings menu item
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogoutMessage;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// User info page title
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get userInfo;

  /// Nickname field label
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Language settings field label
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Timezone settings field label
  ///
  /// In en, this message translates to:
  /// **'Timezone Settings'**
  String get timezoneSettings;

  /// Invite code field label
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCode;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Reset success message
  ///
  /// In en, this message translates to:
  /// **'Reset successful'**
  String get resetSuccess;

  /// Copied to clipboard message
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// Update success message
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get updateSuccess;

  /// Register time text
  ///
  /// In en, this message translates to:
  /// **'Register time: {time}'**
  String registerTime(String time);

  /// Developer mode menu item
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get developerMode;

  /// Theme mode menu item
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// Theme color menu item
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// Light theme mode
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme mode
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme mode
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Server URL dialog title
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Nickname required error message
  ///
  /// In en, this message translates to:
  /// **'Nickname is required'**
  String get nicknameRequired;

  /// Invalid email error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// Invalid phone error message
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalidPhone;

  /// Merchant management menu item
  ///
  /// In en, this message translates to:
  /// **'Merchant Management'**
  String get merchantManagement;

  /// No description provided for @serverUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Server URL is required'**
  String get serverUrlRequired;

  /// No description provided for @serverStatusNormal.
  ///
  /// In en, this message translates to:
  /// **'Server status: Normal'**
  String get serverStatusNormal;

  /// No description provided for @serverStatusError.
  ///
  /// In en, this message translates to:
  /// **'Server status: Error'**
  String get serverStatusError;

  /// No description provided for @databaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Database status'**
  String get databaseStatus;

  /// No description provided for @memoryUsage.
  ///
  /// In en, this message translates to:
  /// **'Memory usage'**
  String get memoryUsage;

  /// No description provided for @saveSuccessRestartRequired.
  ///
  /// In en, this message translates to:
  /// **'Save successful, please restart the app'**
  String get saveSuccessRestartRequired;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// Theme color dialog title
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColorTitle;

  /// Theme color dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite theme color'**
  String get themeColorSubtitle;

  /// Failed to load server URL message
  ///
  /// In en, this message translates to:
  /// **'Failed to load server URL'**
  String get loadServerUrlFailed;

  /// Server URL input hint
  ///
  /// In en, this message translates to:
  /// **'http://example.com:3000'**
  String get serverUrlHint;

  /// Login page title and button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Username required error message
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// Password required error message
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Register link text
  ///
  /// In en, this message translates to:
  /// **'No account? Register now'**
  String get noAccount;

  /// Book name field label
  ///
  /// In en, this message translates to:
  /// **'Book Name'**
  String get bookName;

  /// Book name field hint
  ///
  /// In en, this message translates to:
  /// **'Please enter book name'**
  String get bookNameHint;

  /// Book name required error message
  ///
  /// In en, this message translates to:
  /// **'Book name is required'**
  String get bookNameRequired;

  /// Book description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get bookDescription;

  /// Book description field hint
  ///
  /// In en, this message translates to:
  /// **'Please enter description (optional)'**
  String get bookDescriptionHint;

  /// Currency field label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Create book button text
  ///
  /// In en, this message translates to:
  /// **'Create Book'**
  String get createBook;

  /// Create success message
  ///
  /// In en, this message translates to:
  /// **'Created successfully'**
  String get createSuccess;

  /// Create failed message
  ///
  /// In en, this message translates to:
  /// **'Create failed: {error}'**
  String createFailed(String error);

  /// New shop button tooltip
  ///
  /// In en, this message translates to:
  /// **'New Shop'**
  String get newShop;

  /// Edit shop dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Shop'**
  String get editShop;

  /// Shop name field label
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// Error message when no default book is selected
  ///
  /// In en, this message translates to:
  /// **'No default account book selected'**
  String get noDefaultBook;

  /// Shop update success message
  ///
  /// In en, this message translates to:
  /// **'Shop updated successfully'**
  String get updateShopSuccess;

  /// Shop create success message
  ///
  /// In en, this message translates to:
  /// **'Shop created successfully'**
  String get createShopSuccess;

  /// Shop name required error message
  ///
  /// In en, this message translates to:
  /// **'Shop name is required'**
  String get shopNameRequired;

  /// New category button tooltip
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// Edit category dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// Category name field label
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// Category name required error message
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryNameRequired;

  /// Category update success message
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get updateCategorySuccess;

  /// Category create success message
  ///
  /// In en, this message translates to:
  /// **'Category created successfully'**
  String get createCategorySuccess;

  /// New fund account button tooltip
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newFund;

  /// Edit fund account dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editFund;

  /// Fund account name field label
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get fundName;

  /// Fund account name required error message
  ///
  /// In en, this message translates to:
  /// **'Account name is required'**
  String get fundNameRequired;

  /// Fund account type field label
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get fundType;

  /// Fund account update success message
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully'**
  String get updateFundSuccess;

  /// Fund account create success message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get createFundSuccess;

  /// Cash account type
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Bank card account type
  ///
  /// In en, this message translates to:
  /// **'Bank Card'**
  String get bankCard;

  /// Credit card account type
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// Alipay account type
  ///
  /// In en, this message translates to:
  /// **'Alipay'**
  String get alipay;

  /// WeChat Pay account type
  ///
  /// In en, this message translates to:
  /// **'WeChat Pay'**
  String get wechat;

  /// Other account type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

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

  /// Error message when loading account books fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load account books'**
  String get loadAccountBooksFailed;

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
