import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountRangeDialog extends StatefulWidget {
  final double? minAmount;
  final double? maxAmount;
  final Function(double?) onMinAmountChanged;
  final Function(double?) onMaxAmountChanged;

  const AmountRangeDialog({
    Key? key,
    this.minAmount,
    this.maxAmount,
    required this.onMinAmountChanged,
    required this.onMaxAmountChanged,
  }) : super(key: key);

  @override
  State<AmountRangeDialog> createState() => _AmountRangeDialogState();
}

class _AmountRangeDialogState extends State<AmountRangeDialog> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.minAmount?.toString() ?? '',
    );
    _maxController = TextEditingController(
      text: widget.maxAmount?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        '金额范围',
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _minController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: '最小金额',
              prefixText: '¥',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _maxController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: '最大金额',
              prefixText: '¥',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onMinAmountChanged(null);
            widget.onMaxAmountChanged(null);
            Navigator.pop(context);
          },
          child: Text(
            '清除',
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final minAmount = double.tryParse(_minController.text);
            final maxAmount = double.tryParse(_maxController.text);
            widget.onMinAmountChanged(minAmount);
            widget.onMaxAmountChanged(maxAmount);
            Navigator.pop(context);
          },
          child: Text('确定'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }
}
