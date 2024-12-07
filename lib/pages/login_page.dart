import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/server_config_provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../l10n/l10n.dart';
import 'login/widgets/remember_login_checkbox.dart';
import 'settings/widgets/server_selector.dart';
import 'settings/widgets/server_url_dialog.dart';

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
    if (selectedConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择服务器')),
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
            const SnackBar(content: Text('用户名或密码错误')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败: ${e.toString()}')),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: '服务器设置',
            onPressed: () {
              print('Settings button pressed');
              showDialog(
                context: context,
                builder: (context) => const ServerUrlDialog(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '登录',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const ServerSelector(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '密码',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  RememberLoginCheckbox(
                    value: _rememberLogin,
                    onChanged: (value) {
                      setState(() => _rememberLogin = value ?? false);
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('登录'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                    child: const Text('注册新账号'),
                  ),
                ],
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
}
