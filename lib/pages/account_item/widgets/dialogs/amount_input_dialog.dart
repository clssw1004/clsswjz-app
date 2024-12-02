import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputDialog extends StatefulWidget {
  final double? initialAmount;
  final bool isMin;
  final ValueChanged<double?> onAmountChanged;

  const AmountInputDialog({
    Key? key,
    this.initialAmount,
    required this.isMin,
    required this.onAmountChanged,
  }) : super(key: key);

  @override
  State<AmountInputDialog> createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<AmountInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialAmount?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        '输入${widget.isMin ? '最小' : '最大'}金额',
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          hintText: '请输入金额',
          prefixText: '¥',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onAmountChanged(null);
            Navigator.pop(context);
          },
          child: Text('清除'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final amount = double.tryParse(_controller.text);
            widget.onAmountChanged(amount);
            Navigator.pop(context);
          },
          child: Text('确定'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
