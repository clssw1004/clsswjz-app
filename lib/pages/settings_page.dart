import 'package:flutter/material.dart';
import './settings/widgets/user_card.dart';
import './settings/widgets/theme_mode_selector.dart';
import './settings/widgets/theme_color_selector.dart';
import './settings/widgets/create_account_book_item.dart';
import './settings/widgets/developer_mode_selector.dart';
import './settings/category_management_page.dart';
import '../widgets/app_bar_factory.dart';
import './settings/shop_management_page.dart';
import './settings/fund_management_page.dart';
import './settings/widgets/server_url_dialog.dart';
import './settings/widgets/language_selector.dart';
import '../l10n/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.settings),
      ),
      body: ListView(
        children: [
          // 用户信息卡片
          UserCard(),
          SizedBox(height: 16),

          // 账本管理
          _buildSection(
            context,
            title: l10n.accountManagement,
            children: [
              AccountBookManager(),
              ListTile(
                leading: Icon(Icons.category_outlined),
                title: Text(l10n.categoryManagement),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryManagementPage(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.store_outlined),
                title: Text(l10n.shopManagement),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopManagementPage(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet_outlined),
                title: Text(l10n.fundManagement),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FundManagementPage(),
                  ),
                ),
              ),
            ],
          ),

          // 主题设置
          _buildSection(
            context,
            title: l10n.themeSettings,
            children: [
              ThemeModeSelector(),
              ThemeColorSelector(),
            ],
          ),

          // 系统设置
          _buildSection(
            context,
            title: l10n.systemSettings,
            children: [
              DeveloperModeSelector(),
              LanguageSelector(),
              ListTile(
                leading: Icon(Icons.dns_outlined),
                title: Text(l10n.serverSettings),
                trailing: Icon(Icons.chevron_right),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ServerUrlDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
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
