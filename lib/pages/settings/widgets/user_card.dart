import 'package:flutter/material.dart';
import '../../user/user_info_page.dart';

class UserCard extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final VoidCallback? onUserInfoUpdated;

  const UserCard({
    Key? key,
    required this.userInfo,
    this.onUserInfoUpdated,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future<void> _navigateToUserInfo() async {
    final needsRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => UserInfoPage()),
    );

    if (needsRefresh == true && mounted && widget.onUserInfoUpdated != null) {
      widget.onUserInfoUpdated!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: _navigateToUserInfo,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                radius: 24,
                child: Text(
                  widget.userInfo['nickname']?[0] ??
                      widget.userInfo['username'][0],
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userInfo['nickname'] ??
                          widget.userInfo['username'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.userInfo['username'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
