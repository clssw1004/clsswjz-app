import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/register_page.dart';
import '../services/user_service.dart';
import '../utils/message_helper.dart';
import '../constants/theme_constants.dart';
import '../pages/settings/widgets/server_url_dialog.dart';
import '../l10n/l10n.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final loginResult = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
      );

      await UserService.saveUserSession(
        loginResult['token'],
        loginResult['userInfo'],
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: AppDimens.dialogMaxWidth,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.padding,
                vertical: AppDimens.spacing24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo 和标题
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  SizedBox(height: AppDimens.spacing16),
                  Text(
                    l10n.appName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimens.spacing24),

                  // 登录表单
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cardRadius),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimens.padding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 用户名输入框
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: l10n.username,
                                prefixIcon: Icon(Icons.person_outline),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.usernameRequired;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppDimens.spacing16),

                            // 密码输入框
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                prefixIcon: Icon(Icons.lock_outline),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.passwordRequired;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppDimens.spacing24),

                            // 登录按钮
                            FilledButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: FilledButton.styleFrom(
                                minimumSize: Size.fromHeight(AppDimens.buttonHeight),
                                backgroundColor: _isLoading 
                                    ? colorScheme.primary.withOpacity(0.8)
                                    : colorScheme.primary,
                                disabledBackgroundColor: colorScheme.primary.withOpacity(0.8),
                                padding: EdgeInsets.zero,
                              ),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: AppDimens.buttonHeight,
                                child: Center(
                                  child: _isLoading
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  colorScheme.onPrimary.withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              '登录中...',
                                              style: theme.textTheme.labelLarge?.copyWith(
                                                color: colorScheme.onPrimary.withOpacity(0.9),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          l10n.login,
                                          style: theme.textTheme.labelLarge?.copyWith(
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 注册链接
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(l10n.noAccount),
                  ),

                  // 服务器设置
                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ServerUrlDialog(),
                    ),
                    icon: Icon(
                      Icons.dns_outlined,
                      size: 18,
                    ),
                    label: Text(l10n.serverSettings),
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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
