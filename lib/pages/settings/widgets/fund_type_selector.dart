import 'package:flutter/material.dart';
import '../../../constants/fund_type.dart';
import '../../../constants/theme_constants.dart';

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

    return DropdownButtonFormField<String>(
      value: value,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: '账户类型',
        filled: true,
        fillColor: AppColors.white,
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
        isDense: true,
      ),
      items: FundType.values
          .map((type) => DropdownMenuItem(
                value: type.name,
                child: Text(type.label),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
