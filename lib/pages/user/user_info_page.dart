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

      setState(() {
        _userInfo = userInfo;
        _nicknameController.text = userInfo['nickname'] ?? '';
        _emailController.text = userInfo['email'] ?? '';
        _phoneController.text = userInfo['phone'] ?? '';
        _inviteCode = userInfo['inviteCode'] ?? '';
        _selectedLanguage = Language.fromCode(userInfo['language'] ?? 'zh-CN');
        _selectedTimeZone =
            userInfo['timezone'] ?? TimeZone.getDefaultTimeZone();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserInfo(Map<String, dynamic> data) async {
    try {
      final updatedInfo = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.updateUserInfo({
          ...data,
          if (!data.containsKey('nickname'))
            'nickname': _nicknameController.text,
          if (!data.containsKey('email')) 'email': _emailController.text,
          if (!data.containsKey('phone')) 'phone': _phoneController.text,
          if (!data.containsKey('language')) 'language': _selectedLanguage.code,
          if (!data.containsKey('timezone')) 'timezone': _selectedTimeZone,
        }),
      );

      setState(() {
        _userInfo = updatedInfo;
        if (data.containsKey('language')) {
          _selectedLanguage =
              Language.fromCode(updatedInfo['language'] ?? 'zh-CN');
        }
        if (data.containsKey('timezone')) {
          _selectedTimeZone =
              updatedInfo['timezone'] ?? TimeZone.getDefaultTimeZone();
        }
      });
      await UserService.updateUserInfo(updatedInfo);

      if (!mounted) return;
      MessageHelper.showSuccess(context, message: '更新成功');
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
    try {
      final newInviteCode = await ApiService.resetInviteCode();

      // 更新本地用户信息
      final updatedInfo = {
        ...?_userInfo,
        'inviteCode': newInviteCode,
      };
      await UserService.updateUserInfo(updatedInfo);

      setState(() {
        _userInfo = updatedInfo;
        _inviteCode = newInviteCode;
      });

      if (!mounted) return;
      MessageHelper.showSuccess(context, message: '重置成功');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBarFactory.buildAppBar(
          context: context,
          title: AppBarFactory.buildTitle(context, '用户信息'),
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
          title: AppBarFactory.buildTitle(context, '用户信息'),
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
                          label: '昵称',
                          focusNode: _nicknameFocus,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return '昵称不能为空';
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        _buildTextField(
                          controller: _emailController,
                          label: '邮箱',
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _emailFocus,
                          validator: (value) {
                            if (value?.isNotEmpty ?? false) {
                              if (!_isValidEmail(value)) return '邮箱格式不正确';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        _buildTextField(
                          controller: _phoneController,
                          label: '手机号',
                          keyboardType: TextInputType.phone,
                          focusNode: _phoneFocus,
                          validator: (value) {
                            if (value?.isNotEmpty ?? false) {
                              if (!_isValidPhone(value)) return '手机号格式不正确';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        _buildLanguageField(),
                        SizedBox(height: 24),
                        _buildTimeZoneField(),
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
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildInviteCodeField({
    required String value,
    required VoidCallback onReset,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: TextEditingController(text: value),
            readOnly: true,
            decoration: InputDecoration(
              labelText: '邀请码',
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
              suffixIcon: IconButton(
                icon: Icon(Icons.copy, size: 18),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: value));
                  if (!mounted) return;
                  MessageHelper.showSuccess(context, message: '已复制到剪贴板');
                },
                tooltip: '复制邀请码',
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        TextButton(
          onPressed: onReset,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 12),
            minimumSize: Size(0, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            '重置',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认退出'),
        content: Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            child: Text('退出'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await UserService.logout();
      if (!mounted) return;

      // 清除导航并跳转到登录页
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
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

    if (_userInfo?['createdAt'] == null) return SizedBox.shrink();

    final createdAt = DateTime.parse(_userInfo!['createdAt']);
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);

    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: Text(
        '注册时间：$formattedDate',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
