import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './settings/widgets/user_card.dart';
import './settings/widgets/developer_mode_selector.dart';
import './settings/widgets/language_selector.dart';
import './settings/widgets/book_management_section.dart';
import '../widgets/app_bar_factory.dart';
import '../theme/theme_provider.dart';
import '../l10n/l10n.dart';
import '../services/storage_service.dart';
import '../constants/storage_keys.dart';
import 'settings/providers/category_management_provider.dart';
import 'settings/widgets/create_account_book_item.dart';
import 'settings/widgets/theme_color_selector.dart';
import './settings/server_management_page.dart';
import '../data/data_source_factory.dart';
import './settings/about_page.dart';

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
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            children: [
              // 用户信息卡片
              UserCard(),
              SizedBox(height: 16),

              // 账本管理
              const BookManagementSection(),
              SizedBox(height: 16),

              // 主题设置
              _buildSection(
                context,
                title: l10n.themeSettings,
                children: [
                  // 主题模式选择
                  ListTile(
                    leading: Icon(
                      Icons.brightness_6_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(l10n.themeMode),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeProvider.themeMode,
                      onChanged: (ThemeMode? mode) {
                        if (mode != null) {
                          themeProvider.setThemeMode(mode);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text(l10n.system),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(l10n.light),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(l10n.dark),
                        ),
                      ],
                    ),
                  ),
                  // 主题颜色选择
                  ListTile(
                    leading: Icon(
                      Icons.palette_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(l10n.themeColor),
                    trailing: IconButton(
                      onPressed: () =>
                          _showThemeColorPicker(context, themeProvider),
                      icon: Icon(
                        Icons.palette,
                        color: themeProvider.themeColor,
                      ),
                    ),
                  ),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServerManagementPage(),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(l10n.about),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showThemeColorPicker(
      BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.themeColorTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.themeColorSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ThemeColorSelector(
                currentColor: themeProvider.themeColor,
                onColorSelected: (color) {
                  themeProvider.setThemeColor(color);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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
