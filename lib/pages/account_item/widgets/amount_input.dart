import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/l10n.dart';

class AmountInput extends StatelessWidget {
  final double? initialValue;
  final ValueChanged<double> onChanged;
  final String type;
  final FocusNode? focusNode;
  final TextEditingController controller;

  const AmountInput({
    Key? key,
    this.initialValue,
    required this.onChanged,
    required this.type,
    this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final typeColor = type == '支出'
        ? Color(0xFFE53935) // Material Red 600
        : Color(0xFF43A047); // Material Green 600

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 60,
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                textInputAction: TextInputAction.done,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: l10n.amountLabel,
                  hintText: l10n.amountHint,
                  hintStyle: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  filled: false,
                  errorStyle: TextStyle(height: 0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入金额';
                  }
                  try {
                    final amount = double.parse(value);
                    if (amount <= 0) {
                      return '金额必须大于0';
                    }
                  } catch (e) {
                    return '请输入有效金额';
                  }
                  return null;
                },
                focusNode: focusNode,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
