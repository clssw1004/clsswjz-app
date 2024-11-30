import 'package:flutter/material.dart';

class BookHeader extends StatelessWidget {
  final Map<String, dynamic>? book;

  const BookHeader({
    Key? key,
    this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.book_outlined,
            size: 20,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              book != null ? book!['name'] : '未选择账本',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 