import 'package:flutter/material.dart';
import '../../../constants/theme_constants.dart';

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

    return Row(
      children: [
        Text(
          '当前余额',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        Spacer(),
        SizedBox(
          width: 120,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
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
              prefixText: '¥',
              prefixStyle: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              hintText: '0.00',
              hintStyle: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: AppDimens.paddingSmall,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
