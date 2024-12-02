import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../utils/api_error_handler.dart';
import '../../services/user_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await ApiErrorHandler.wrapRequest(
        context,
        () => ApiService.getLoginUserInfo(),
      );

      setState(() {
        _userInfo = userInfo;
        _nicknameController.text = userInfo['nickname'] ?? '';
        _emailController.text = userInfo['email'] ?? '';
        _phoneController.text = userInfo['phone'] ?? '';
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
        appBar: AppBar(title: Text('用户信息')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        // 点击空白处时，保存当前输入框的值并失去焦点
        final currentFocus = FocusScope.of(context);
        if (currentFocus.hasFocus) {
          // 在失去焦点前保存当前输入框的值
          final focusedChild = currentFocus.focusedChild;
          if (focusedChild != null) {
            // 根据当前焦点的输入框保存相应的值
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
        appBar: AppBar(
          title: Text('用户信息'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: '基本信息',
                children: [
                  _buildReadOnlyField(
                    label: '用户名',
                    value: _userInfo?['username'] ?? '',
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      labelText: '昵称',
                      border: OutlineInputBorder(),
                    ),
                    onEditingComplete: () =>
                        _handleNicknameSubmitted(_nicknameController.text),
                    onFieldSubmitted: _handleNicknameSubmitted,
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                title: '联系方式',
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '邮箱',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () =>
                        _handleEmailSubmitted(_emailController.text),
                    onFieldSubmitted: _handleEmailSubmitted,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: '手机号',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onEditingComplete: () =>
                        _handlePhoneSubmitted(_phoneController.text),
                    onFieldSubmitted: _handlePhoneSubmitted,
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                title: '其他信息',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildReadOnlyField(
                          label: '邀请码',
                          value: _userInfo?['inviteCode'] ?? '',
                        ),
                      ),
                      SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: _resetInviteCode,
                        child: Text('重置'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildReadOnlyField(
                    label: '注册时间',
                    value: _userInfo?['createdAt'] != null
                        ? DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.parse(_userInfo!['createdAt']))
                        : '',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      enabled: false,
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
