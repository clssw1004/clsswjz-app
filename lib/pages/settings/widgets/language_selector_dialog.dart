import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../constants/language.dart';
import '../../../l10n/l10n.dart';

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    Theme.of(context);

    return AlertDialog(
      title: Text(l10n.languageSettings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: Language.supportedLanguages.map((language) {
          return RadioListTile<Language>(
            value: language,
            groupValue: context.watch<LocaleProvider>().currentLanguage,
            title: Text(language.label),
            onChanged: (Language? value) {
              if (value != null) {
                context.read<LocaleProvider>().setLocale(value);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
} 