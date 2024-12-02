import 'package:flutter/material.dart';
import '../services/data_service.dart';
import './settings/widgets/user_card.dart';
import './settings/widgets/theme_mode_selector.dart';
import './settings/widgets/theme_color_selector.dart';
import './settings/widgets/create_account_book_item.dart';
import './settings/widgets/logout_button.dart';
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
    setState(() {
      _userInfo = UserService.getUserInfo() ?? _userInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserCard(
                  userInfo: _userInfo,
                  onUserInfoUpdated: _refreshUserInfo,
                ),
                Divider(),
                ThemeModeSelector(),
                ThemeColorSelector(),
                Divider(),
                CreateAccountBookItem(dataService: _dataService),
                Divider(),
                DeveloperModeSelector(),
                Divider(),
              ],
            ),
          ),
          LogoutButton(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
