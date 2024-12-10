import 'package:flutter/material.dart';
import '../../../constants/theme_constants.dart';
import '../../../l10n/l10n.dart';

class FundBalanceInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const FundBalanceInput({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.currentBalance,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.brightness == Brightness.light
                ? AppColors.white
                : colorScheme.surfaceVariant,
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.primary,
              ),
            ),
            prefixText: '¥',
            prefixStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
            hintText: '0.00',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: AppDimens.paddingSmall,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
