import 'package:flutter/material.dart';
import '../../../constants/fund_type.dart';
import '../../../constants/theme_constants.dart';
import '../../../l10n/l10n.dart';

class FundTypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const FundTypeSelector({
    Key? key,
    required this.value,
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
          l10n.fundType,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: AppDimens.paddingSmall,
            ),
            isDense: true,
          ),
          items: FundType.values
              .map((type) => DropdownMenuItem(
                    value: type.name,
                    child: Text(type.label),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
