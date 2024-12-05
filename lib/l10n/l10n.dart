import 'package:flutter/material.dart';

import '../generated/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';
export 'package:flutter_localizations/flutter_localizations.dart';

class L10n {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
