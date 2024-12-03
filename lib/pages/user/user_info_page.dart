import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../utils/api_error_handler.dart';
import '../../services/user_service.dart';
import '../../widgets/app_bar_factory.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

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
        () => ApiService.getLoginUserInfo(),
      );

      setState(() {
        _userInfo = userInfo;
        // 设置初始值
        _initialNickname = userInfo['nickname'];
        _initialEmail = userInfo['email'];
        _initialPhone = userInfo['phone'];

        _nicknameController.text = _initialNickname ?? '';
        _emailController.text = _initialEmail ?? '';
        _phoneController.text = _initialPhone ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserInfo({
    String? nickname,
    String? email,
    String? phone,
  }) async {
    try {
      final updatedInfo = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.saveUserInfo(
          nickname: nickname,
          email: email,
          phone: phone,
        ),
      );

      setState(() => _userInfo = updatedInfo);
      await UserService.updateUserInfo(updatedInfo);
    } catch (e) {
      // 错误已由 ApiErrorHandler 处理
    }
  }

  void _handleNicknameSubmitted(String value) {
    if (value.isEmpty || value == _userInfo?['nickname']) return;
    _saveUserInfo(nickname: value);
  }

  void _handleEmailSubmitted(String value) {
    if (value == _userInfo?['email']) return;
    _saveUserInfo(email: value);
  }

  void _handlePhoneSubmitted(String value) {
    if (value == _userInfo?['phone']) return;
    _saveUserInfo(phone: value);
  }

  Future<void> _resetInviteCode() async {
    try {
      final newInviteCode = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.resetInviteCode(),
      );

      setState(() {
        if (_userInfo != null) {
          _userInfo!['inviteCode'] = newInviteCode;
        }
      });
    } catch (e) {
      // 错误已由 ApiErrorHandler 处理
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
                        _buildInviteCodeField(
                          value: _userInfo?['inviteCode'] ?? '',
                          onReset: _resetInviteCode,
                        ),
                        SizedBox(height: 24),
                        _buildReadOnlyField(
                          label: '注册时间',
                          value: _userInfo?['createdAt'] != null
                              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                  DateTime.parse(_userInfo!['createdAt']))
                              : '',
                        ),
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

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return _buildTextField(
      controller: TextEditingController(text: value),
      label: label,
      readOnly: true,
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
          child: _buildReadOnlyField(
            label: '邀请码',
            value: value,
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

      // 清除导航栈并跳转到登录页
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }
}
