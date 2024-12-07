import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../utils/api_error_handler.dart';
import '../../services/user_service.dart';
import '../../widgets/app_bar_factory.dart';
import '../../services/api_service.dart';
import '../../utils/message_helper.dart';
import '../../constants/language.dart';
import '../../constants/timezone.dart';
import '../../l10n/l10n.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<UserInfoPage> createState() => UserInfoPageState();
}

class UserInfoPageState extends State<UserInfoPage> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _inviteCode;
  Language _selectedLanguage = Language.ZH_CN;
  String _selectedTimeZone = TimeZone.getDefaultTimeZone();

  // 添加焦点节点
  final _nicknameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  // 添加初始值记录
  String? _initialNickname;
  String? _initialEmail;
  String? _initialPhone;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _nicknameFocus.addListener(() {
      if (!_nicknameFocus.hasFocus) {
        final newValue = _nicknameController.text.trim();
        if (newValue.isNotEmpty && newValue != _initialNickname) {
          _handleNicknameSubmitted(newValue);
        }
      }
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        final newValue = _emailController.text.trim();
        if (newValue != _initialEmail && newValue.isNotEmpty) {
          if (_isValidEmail(newValue)) {
            _handleEmailSubmitted(newValue);
          }
        }
      }
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        final newValue = _phoneController.text.trim();
        if (newValue != _initialPhone && newValue.isNotEmpty) {
          if (_isValidPhone(newValue)) {
            _handlePhoneSubmitted(newValue);
          }
        }
      }
    });
  }

  bool _isValidEmail(String? email) {
    if (email == null || email.isEmpty) return true;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return true;
    return RegExp(r'^\d{11}$').hasMatch(phone);
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.getUserInfo(),
      );

      if (mounted) {
        setState(() {
          _userInfo = userInfo;
          _nicknameController.text = userInfo['nickname'] ?? '';
          _emailController.text = userInfo['email'] ?? '';
          _phoneController.text = userInfo['phone'] ?? '';
          _inviteCode = userInfo['inviteCode'];
          _selectedLanguage = Language.fromCode(userInfo['language'] ?? 'zh-CN');
          _selectedTimeZone = userInfo['timezone'] ?? TimeZone.getDefaultTimeZone();
          
          // 记录初始值
          _initialNickname = _nicknameController.text;
          _initialEmail = _emailController.text;
          _initialPhone = _phoneController.text;
          
          _isLoading = false;
        });
        await UserService.updateUserInfo(userInfo);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userInfo = null;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUserInfo(Map<String, dynamic> data) async {
    try {
      final updatedInfo = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.updateUserInfo(data),
      );

      if (mounted) {
        setState(() {
          _userInfo = updatedInfo;
          if (data.containsKey('nickname')) {
            _nicknameController.text = updatedInfo['nickname'] ?? '';
            _initialNickname = _nicknameController.text;
          }
          if (data.containsKey('email')) {
            _emailController.text = updatedInfo['email'] ?? '';
            _initialEmail = _emailController.text;
          }
          if (data.containsKey('phone')) {
            _phoneController.text = updatedInfo['phone'] ?? '';
            _initialPhone = _phoneController.text;
          }
          if (data.containsKey('language')) {
            _selectedLanguage = Language.fromCode(updatedInfo['language'] ?? 'zh-CN');
          }
          if (data.containsKey('timezone')) {
            _selectedTimeZone = updatedInfo['timezone'] ?? TimeZone.getDefaultTimeZone();
          }
        });
        await UserService.updateUserInfo(updatedInfo);
        
        if (!mounted) return;
        MessageHelper.showSuccess(context, message: '更新成功');
      }
    } catch (e) {
      // 错误已由 ApiErrorHandler 处理
    }
  }

  void _handleNicknameSubmitted(String value) {
    if (value.isEmpty || value == _userInfo?['nickname']) return;
    _updateUserInfo({'nickname': value});
  }

  void _handleEmailSubmitted(String value) {
    if (value == _userInfo?['email']) return;
    _updateUserInfo({'email': value});
  }

  void _handlePhoneSubmitted(String value) {
    if (value == _userInfo?['phone']) return;
    _updateUserInfo({'phone': value});
  }

  Future<void> _resetInviteCode() async {
    final l10n = L10n.of(context);
    try {
      final newCode = await ApiService.resetInviteCode();
      setState(() => _inviteCode = newCode);
      if (!mounted) return;
      MessageHelper.showSuccess(context, message: l10n.resetInviteCodeSuccess);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<void> _copyInviteCode() async {
    final l10n = L10n.of(context);
    if (_inviteCode == null) return;

    await Clipboard.setData(ClipboardData(text: _inviteCode!));
    if (!mounted) return;
    MessageHelper.showSuccess(context, message: l10n.copiedToClipboard);
  }

  Future<void> _showEditDialog() async {
    final l10n = L10n.of(context);
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editUserInfo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: l10n.nicknameLabel,
                // ... 其他装饰保持不变 ...
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l10n.emailLabel,
                // ... 其他装饰保持不变 ...
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: l10n.phoneLabel,
                // ... 其他装饰保持不变 ...
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, {
              'nickname': _nicknameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
            }),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        await ApiService.updateUserInfo(result);
        await _loadUserInfo();
        if (!mounted) return;
        MessageHelper.showSuccess(context, message: l10n.updateUserInfoSuccess);
      } catch (e) {
        if (!mounted) return;
        MessageHelper.showError(context, message: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBarFactory.buildAppBar(
          context: context,
          title: AppBarFactory.buildTitle(context, l10n.userInfoTitle),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          final focusedChild = currentFocus.focusedChild;
          if (focusedChild != null) {
            if (_nicknameController.text != _userInfo?['nickname']) {
              _handleNicknameSubmitted(_nicknameController.text);
            } else if (_emailController.text != _userInfo?['email']) {
              _handleEmailSubmitted(_emailController.text);
            } else if (_phoneController.text != _userInfo?['phone']) {
              _handlePhoneSubmitted(_phoneController.text);
            }
          }
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBarFactory.buildAppBar(
          context: context,
          title: AppBarFactory.buildTitle(context, l10n.userInfoTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outlineVariant.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'user_avatar',
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: colorScheme.primaryContainer,
                              child: Text(
                                _userInfo?['nickname']?[0] ??
                                    _userInfo?['username'][0] ??
                                    '',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            _userInfo?['username'] ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildTextField(
                          controller: _nicknameController,
                          label: l10n.nicknameLabel,
                          focusNode: _nicknameFocus,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return '昵称不能为空';
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        _buildTextField(
                          controller: _emailController,
                          label: l10n.emailLabel,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocus,
                        ),
                        SizedBox(height: 24),
                        _buildTextField(
                          controller: _phoneController,
                          label: l10n.phoneLabel,
                          keyboardType: TextInputType.phone,
                          focusNode: _phoneFocus,
                        ),
                        SizedBox(height: 24),
                        _buildInviteCodeField(
                          value: _userInfo?['inviteCode'] ?? '',
                          onReset: _resetInviteCode,
                        ),
                        _buildCreatedAtText(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.2),
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _handleLogout,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '退出登录',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: readOnly
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
        ),
        contentPadding: EdgeInsets.only(bottom: 4),
        filled: readOnly,
        fillColor: readOnly
            ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
            : null,
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: readOnly ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: (value) {
        if (validator != null) {
          if (label == l10n.nicknameLabel) {
            if (value?.isEmpty ?? true) return l10n.nicknameRequired;
          } else if (label == l10n.emailLabel) {
            if (value?.isNotEmpty ?? false) {
              if (!_isValidEmail(value)) return l10n.invalidEmailFormat;
            }
          } else if (label == l10n.phoneLabel) {
            if (value?.isNotEmpty ?? false) {
              if (!_isValidPhone(value)) return l10n.invalidPhoneFormat;
            }
          }
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildInviteCodeField({
    required String? value,
    required VoidCallback onReset,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.inviteCodeLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (value?.isNotEmpty == true) ...[
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: _copyInviteCode,
                tooltip: l10n.copiedToClipboard,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: onReset,
                tooltip: l10n.resetInviteCode,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
          ),
        ),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  @override
  void dispose() {
    _nicknameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final l10n = L10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmLogoutTitle),
        content: Text(l10n.confirmLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await UserService.logout();
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Widget _buildLanguageField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<Language>(
      value: _selectedLanguage,
      decoration: InputDecoration(
        labelText: '语言设置',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: 4),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      items: Language.supportedLanguages.map((lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang.label),
        );
      }).toList(),
      onChanged: (Language? value) {
        if (value != null) {
          _updateUserInfo({'language': value.code});
        }
      },
    );
  }

  Widget _buildTimeZoneField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<String>(
      value: _selectedTimeZone,
      decoration: InputDecoration(
        labelText: '时区设置',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.only(bottom: 4),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      items: TimeZone.supportedTimeZones.map((tz) {
        return DropdownMenuItem(
          value: tz['code']!,
          child: Text(
            tz['label']!,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null && TimeZone.isValidTimeZone(value)) {
          _updateUserInfo({'timezone': value});
        }
      },
    );
  }

  Widget _buildCreatedAtText() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    if (_userInfo?['createdAt'] == null) return SizedBox.shrink();

    final createdAt = DateTime.parse(_userInfo!['createdAt']);
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Text(
        l10n.registerTimeLabel(formattedDate),
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
