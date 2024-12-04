import 'package:flutter/material.dart';
import '../../../constants/theme_constants.dart';

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

    return TextField(
      controller: controller,
      style: style ?? theme.textTheme.bodyMedium,
      keyboardType: keyboardType,
      textAlign: textAlign,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.white,
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
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
