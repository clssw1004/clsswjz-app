import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatefulWidget {
  final double? initialValue;
  final ValueChanged<double> onChanged;
  final String type;

  const AmountInput({
    Key? key,
    this.initialValue,
    required this.onChanged,
    required this.type,
  }) : super(key: key);

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final typeColor = widget.type == '支出'
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
          Text(
            '¥',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.transactionAmount],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
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
                  return null;
                },
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  widget.onChanged(amount);
                },
                onFieldSubmitted: (value) {
                  final parsedValue = double.tryParse(value) ?? 0.0;
                  _controller.text = parsedValue.toStringAsFixed(2);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
