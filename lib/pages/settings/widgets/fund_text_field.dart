import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class FundTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final ValueChanged<String>? onChanged;

  const FundTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.style,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.prefixText,
    this.prefixStyle,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: style ??
              theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
          keyboardType: keyboardType,
          textAlign: textAlign,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.brightness == Brightness.light
                ? AppColors.white
                : colorScheme.surfaceContainerHighest,
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
              ),
            ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: AppDimens.paddingSmall,
            ),
            isDense: true,
            prefixText: prefixText,
            prefixStyle: prefixStyle,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
