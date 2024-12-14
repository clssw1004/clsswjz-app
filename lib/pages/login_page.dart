import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/server_config.dart';
import '../providers/server_config_provider.dart';
import '../services/auth_service.dart';
import '../l10n/l10n.dart';
import '../widgets/app_bar_factory.dart';
import 'login/widgets/remember_login_checkbox.dart';
import 'settings/widgets/language_selector_dialog.dart';
import 'settings/widgets/add_server_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberLogin = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadSavedCredentials() {
    final provider = context.read<ServerConfigProvider>();
    final selectedConfig = provider.selectedConfig;
    if (selectedConfig != null) {
      setState(() {
        _usernameController.text = selectedConfig.savedUsername ?? '';
        _passwordController.text = selectedConfig.savedPassword ?? '';
        _rememberLogin = selectedConfig.savedUsername != null;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ServerConfigProvider>();
    final selectedConfig = provider.selectedConfig;
    final l10n = L10n.of(context);

    if (selectedConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectServer)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        if (_rememberLogin) {
          await provider.saveCredentials(
            selectedConfig.id,
            _usernameController.text,
            _passwordController.text,
          );
        } else {
          await provider.clearCredentials(selectedConfig.id);
        }

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.wrongCredentials)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = L10n.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loginFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );

    Widget buildServerSelector() {
      final provider = context.watch<ServerConfigProvider>();
      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: provider.selectedConfig?.id,
              decoration: inputDecoration.copyWith(
                labelText: l10n.selectServer,
                prefixIcon: Icon(
                    provider.selectedConfig?.type == ServerType.selfHosted
                        ? Icons.computer_outlined
                        : Icons.cloud_outlined,
                    size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              ),
              dropdownColor: Theme.of(context).colorScheme.surface,
              menuMaxHeight: 300,
              icon: const Icon(Icons.arrow_drop_down, size: 24),
              selectedItemBuilder: (context) {
                return provider.configs.map((config) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      config.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              items: provider.configs.map((config) {
                return DropdownMenuItem<String>(
                  value: config.id,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          config.type == ServerType.selfHosted
                              ? Icons.computer_outlined
                              : Icons.cloud_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                config.name,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (config.serverUrl != null &&
                                  config.serverUrl!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  config.serverUrl ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  provider.selectConfig(id);
                }
              },
              isExpanded: true,
            ),
          ),
          IconButton(
            onPressed: () => _showAddServerDialog(context),
            icon: const Icon(Icons.add, size: 20),
            tooltip: l10n.addServer,
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
              foregroundColor: colorScheme.primary,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_outlined),
            tooltip: l10n.languageSettings,
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 添加 App Logo
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primaryContainer,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 登录表单卡片
                    Card(
                      elevation: 0,
                      color: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 使用新的服务器选择器
                            buildServerSelector(),
                            const SizedBox(height: 16),

                            // 用户名输入框
                            TextFormField(
                              controller: _usernameController,
                              decoration: inputDecoration.copyWith(
                                labelText: l10n.username,
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.usernameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // 密码输入框
                            TextFormField(
                              controller: _passwordController,
                              decoration: inputDecoration.copyWith(
                                labelText: l10n.password,
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.passwordRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),

                            // 记住登录选项
                            RememberLoginCheckbox(
                              value: _rememberLogin,
                              onChanged: (value) {
                                setState(() => _rememberLogin = value ?? false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 登录按钮
                    FilledButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : Text(l10n.login),
                    ),
                    const SizedBox(height: 16),

                    // 注册链接
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text(l10n.noAccount),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
    });
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageSelectorDialog(),
    );
  }

  void _showAddServerDialog(BuildContext context) {
    final provider = context.read<ServerConfigProvider>();
    showDialog(
      context: context,
      builder: (context) => AddServerDialog(
        existingServers: provider.configs,
      ),
    );
  }
}
