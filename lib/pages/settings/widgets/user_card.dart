import 'package:flutter/material.dart';
import '../../../services/user_service.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late Map<String, dynamic> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = UserService.getUserInfo() ?? {};
  }

  void _refreshUserInfo() {
    if (!mounted) return;
    setState(() {
      _userInfo = UserService.getUserInfo() ?? _userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            _userInfo['nickname']?.substring(0, 1) ??
                _userInfo['username']?.substring(0, 1) ??
                'U',
            style: TextStyle(color: colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(
          _userInfo['nickname'] ?? _userInfo['username'] ?? '未登录',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          _userInfo['email'] ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/user-info').then((_) {
            _refreshUserInfo();
          });
        },
      ),
    );
  }
}
