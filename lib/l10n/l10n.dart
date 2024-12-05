import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

class L10n {
  static AppLocalizations of(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return lookupAppLocalizations(const Locale('zh'));
    }
    return localizations;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return AppLocalizations.of(context);
  }
}
