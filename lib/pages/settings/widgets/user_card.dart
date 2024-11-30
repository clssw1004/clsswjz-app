import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const UserCard({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = Theme.of(context).primaryColor;

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildAvatar(themeColor, userInfo['nickname'] ?? ''),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo['nickname'] ?? userInfo['username'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userInfo['username'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Color themeColor, String nickname) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: themeColor.withOpacity(0.1),
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 24,
          color: themeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 