import 'package:flutter/material.dart';
import '../services/data_service.dart';
import './settings/widgets/user_card.dart';
import './settings/widgets/theme_mode_selector.dart';
import './settings/widgets/theme_color_selector.dart';
import './settings/widgets/create_account_book_item.dart';
import './settings/widgets/developer_mode_selector.dart';
import '../services/user_service.dart';

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const SettingsPage({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Map<String, dynamic> _userInfo;
  final _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: ListView(
        children: [
          UserCard(
            userInfo: _userInfo,
            onUserInfoUpdated: _refreshUserInfo,
          ),
          SizedBox(height: 16),
          _buildSettingsGroup(
            context,
            title: '外观设置',
            children: [
              ThemeModeSelector(),
              ThemeColorSelector(),
            ],
          ),
          SizedBox(height: 16),
          _buildSettingsGroup(
            context,
            title: '账本管理',
            children: [
              CreateAccountBookItem(dataService: _dataService),
            ],
          ),
          SizedBox(height: 16),
          _buildSettingsGroup(
            context,
            title: '开发者选项',
            children: [
              DeveloperModeSelector(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Container(
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    color: theme.dividerColor,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
