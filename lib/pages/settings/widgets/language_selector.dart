import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/language.dart';
import '../../../providers/locale_provider.dart';
import '../../../l10n/l10n.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return ListTile(
          leading: Icon(
            Icons.language_outlined,
            color: colorScheme.primary,
          ),
          title: Text(
            l10n.languageSettings,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          trailing: DropdownButton<Language>(
            value: Language.values.firstWhere(
              (lang) {
                final locale = localeProvider.locale;
                if (locale.scriptCode == 'Hant') {
                  return lang == Language.ZH_TW;
                }
                return lang.code == locale.languageCode;
              },
              orElse: () => Language.ZH_CN,
            ),
            underline: SizedBox(),
            dropdownColor: colorScheme.surface,
            items: Language.supportedLanguages.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(
                  lang.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (Language? language) {
              if (language != null) {
                localeProvider.setLocale(language);
              }
            },
          ),
        );
      },
    );
  }
}
