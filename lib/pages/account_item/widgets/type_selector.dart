import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';

class TypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TypeSelector({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final themeColor = themeProvider.themeColor;
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onChanged('支出'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: value == '支出' ? themeColor : null,
                  foregroundColor: value == '支出' ? Colors.white : themeColor,
                  side: BorderSide(
                    color: value == '支出' ? themeColor : Colors.grey[300]!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '支出',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onChanged('收入'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: value == '收入' ? themeColor : null,
                  foregroundColor: value == '收入' ? Colors.white : themeColor,
                  side: BorderSide(
                    color: value == '收入' ? themeColor : Colors.grey[300]!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '收入',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 