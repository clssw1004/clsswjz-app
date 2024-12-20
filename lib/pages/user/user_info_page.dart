import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/user_info_state.dart';
import '../../utils/api_error_handler.dart';
import '../../services/user_service.dart';
import '../../widgets/app_bar_factory.dart';
import '../../services/api_service.dart';
import '../../utils/message_helper.dart';
import '../../generated/app_localizations.dart';

class UserInfoPage extends StatefulWidget {
  @override
  State<UserInfoPage> createState() => UserInfoPageState();
}

class UserInfoPageState extends State<UserInfoPage> {
  late UserInfoState _state;
  final _nicknameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _state = UserInfoState.initial();
    _setupFocusListeners();
    _loadUserInfo();
  }

  void _setupFocusListeners() {
    _nicknameFocus.addListener(() {
      if (!_nicknameFocus.hasFocus) {
        _handleFieldSubmitted('nickname', _state.nicknameController.text.trim());
      }
    });

    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _handleFieldSubmitted('email', _state.emailController.text.trim());
      }
    });

    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        _handleFieldSubmitted('phone', _state.phoneController.text.trim());
      }
    });
  }

  void _handleFieldSubmitted(String field, String value) {
    if (!_isFieldValid(field, value)) return;
    if (!_isFieldChanged(field, value)) return;
    _updateUserInfo({field: value});
  }

  bool _isFieldValid(String field, String value) {
    if (value.isEmpty) return false;
    
    switch (field) {
      case 'email':
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
      case 'phone':
        return RegExp(r'^\d{11}$').hasMatch(value);
      default:
        return true;
    }
  }

  bool _isFieldChanged(String field, String value) {
    if (_state.userInfo == null) return false;
    
    switch (field) {
      case 'nickname':
        return value != _state.userInfo?.nickname;
      case 'email':
        return value != _state.userInfo?.email;
      case 'phone':
        return value != _state.userInfo?.phone;
      default:
        return false;
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.getUserInfo(),
      );

      if (mounted) {
        setState(() {
          _state = _state.copyWith(
            userInfo: () => userInfo,
            isLoading: false,
            inviteCode: () => userInfo.inviteCode,
          );
          _state.updateFromUser(userInfo);
        });
        await UserService.updateUserInfo(userInfo);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = _state.copyWith(
            userInfo: () => null,
            isLoading: false,
          );
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
          _state = _state.copyWith(
            userInfo: () => updatedInfo,
          );
          _state.updateFromUser(updatedInfo);
        });
        await UserService.updateUserInfo(updatedInfo);

        if (!mounted) return;
        MessageHelper.showSuccess(context, message: '更新成功');
      }
    } catch (e) {
      // 错误已由 ApiErrorHandler 处理
    }
  }

  Future<void> _resetInviteCode() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final newCode = await ApiService.resetInviteCode();
      setState(() {
        _state = _state.copyWith(
          inviteCode: () => newCode,
        );
      });
      if (!mounted) return;
      MessageHelper.showSuccess(context, message: l10n.resetInviteCodeSuccess);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<void> _copyInviteCode() async {
    final l10n = AppLocalizations.of(context)!;
    if (_state.inviteCode == null) return;

    await Clipboard.setData(ClipboardData(text: _state.inviteCode!));
    if (!mounted) return;
    MessageHelper.showSuccess(context, message: l10n.copiedToClipboard);
  }

  Future<void> _handleLogout() async {
    final l10n = AppLocalizations.of(context)!;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (_state.isLoading) {
      return Scaffold(
        appBar: AppBarFactory.buildAppBar(
          context: context,
          title: AppBarFactory.buildTitle(context, l10n.userInfoTitle),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                  _buildHeader(theme, colorScheme),
                  _buildForm(theme, colorScheme, l10n),
                ],
              ),
            ),
            _buildLogoutButton(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return SliverToBoxAdapter(
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
                  _state.userInfo?.nickname?[0] ?? _state.userInfo?.username[0] ?? '',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              _state.userInfo?.username ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, ColorScheme colorScheme, AppLocalizations l10n) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildTextField(
            controller: _state.nicknameController,
            label: l10n.nicknameLabel,
            focusNode: _nicknameFocus,
            theme: theme,
            colorScheme: colorScheme,
            validator: (value) => value?.isEmpty ?? true ? l10n.nicknameRequired : null,
          ),
          SizedBox(height: 24),
          _buildTextField(
            controller: _state.emailController,
            label: l10n.emailLabel,
            focusNode: _emailFocus,
            theme: theme,
            colorScheme: colorScheme,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isNotEmpty ?? false) {
                if (!_isFieldValid('email', value!)) {
                  return l10n.invalidEmailFormat;
                }
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          _buildTextField(
            controller: _state.phoneController,
            label: l10n.phoneLabel,
            focusNode: _phoneFocus,
            theme: theme,
            colorScheme: colorScheme,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isNotEmpty ?? false) {
                if (!_isFieldValid('phone', value!)) {
                  return l10n.invalidPhoneFormat;
                }
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          _buildInviteCodeField(theme, colorScheme, l10n),
          if (_state.userInfo?.createdAt != null)
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                l10n.registerTimeLabel(
                  DateFormat('yyyy-MM-dd HH:mm').format(_state.userInfo!.createdAt),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required ThemeData theme,
    required ColorScheme colorScheme,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
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
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildInviteCodeField(ThemeData theme, ColorScheme colorScheme, AppLocalizations l10n) {
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
                _state.inviteCode ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (_state.inviteCode?.isNotEmpty == true) ...[
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: _copyInviteCode,
                tooltip: l10n.copiedToClipboard,
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _resetInviteCode,
                tooltip: l10n.resetInviteCode,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(ThemeData theme, ColorScheme colorScheme) {
    return Container(
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
    );
  }

  @override
  void dispose() {
    _nicknameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _state.dispose();
    super.dispose();
  }
}
