import 'package:flutter/material.dart';
import 'member_list.dart';

class BookInfoView extends StatelessWidget {
  final Map<String, dynamic> data;

  const BookInfoView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'] ?? '',
                  style: theme.textTheme.titleLarge,
                ),
                if ((data['description'] ?? '').isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(data['description'] ?? ''),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('币种：'),
                    SizedBox(width: 8),
                    Text(data['currencySymbol'] ?? '¥'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '成员管理',
            style: theme.textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 8),
        MemberList(
          members: data['members'] ?? [],
          createdBy: data['createdBy'] ?? '',
          isEditing: false,
        ),
      ],
    );
  }
} 