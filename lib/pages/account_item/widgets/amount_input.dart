import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';

class AmountInput extends StatefulWidget {
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
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  String? _errorText;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    if (!_isInitialized) {
      _isInitialized = true;
      return;
    }

    setState(() {
      _errorText = _validateAmount(text);
    });

    if (_errorText == null && text.isNotEmpty) {
      final amount = double.tryParse(text);
      if (amount != null) {
        widget.onChanged(amount);
      }
    }
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).pleaseInputAmount;
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return L10n.of(context).pleaseInputAmount;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final typeColor = widget.type == '支出'
        ? Color(0xFFE53935) // Material Red 600
        : Color(0xFF43A047); // Material Green 600

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                    controller: widget.controller,
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
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
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
                      errorStyle: TextStyle(
                        fontSize: 0,
                        height: 0,
                      ),
                    ),
                    validator: _validateAmount,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: widget.focusNode,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 错误提示
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              _errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
