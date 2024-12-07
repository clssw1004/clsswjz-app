import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/language.dart';
import '../models/register_request.dart';
import '../constants/timezone.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  Language _selectedLanguage = Language.ZH_CN;
  String _selectedTimeZone = TimeZone.getDefaultTimeZone();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedTimeZone = TimeZone.getDefaultTimeZone();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService.register(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        nickname: _nicknameController.text,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('注册成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('注册失败：${e.toString()}')),
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
        title: Text('注册'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.padding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: '用户名',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                    ),
                    helperText: '2-50个字符',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入用户名';
                    }
                    if (value.length < 2 || value.length > 50) {
                      return '用户名长度必须在2-50个字符之间';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimens.spacing16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                    ),
                    helperText: '6-50个字符',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    if (value.length < 6 || value.length > 50) {
                      return '密码长度必须在6-50个字符之间';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimens.spacing16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: '确认密码',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return '两次输入的密码不一致';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimens.spacing16),
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: '昵称（选填）',
                    prefixIcon: Icon(Icons.face),
                  ),
                ),
                SizedBox(height: AppDimens.spacing16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '邮箱（选填）',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return '请输入有效的邮箱地址';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimens.spacing16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: '手机号（选填）',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return '请输入有效的手机号';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimens.spacing24),
                Padding(
                  padding: EdgeInsets.only(
                    top: AppDimens.spacing24,
                    bottom: AppDimens.spacing16,
                  ),
                  child: Text(
                    '区域设置',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                DropdownButtonFormField<Language>(
                  value: _selectedLanguage,
                  decoration: InputDecoration(
                    labelText: '语言设置',
                    prefixIcon: Icon(Icons.language),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                    ),
                  ),
                  items: Language.supportedLanguages.map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang.label),
                    );
                  }).toList(),
                  onChanged: (Language? value) {
                    if (value != null) {
                      setState(() => _selectedLanguage = value);
                    }
                  },
                ),
                SizedBox(height: AppDimens.spacing16),
                DropdownButtonFormField<String>(
                  value: _selectedTimeZone,
                  decoration: InputDecoration(
                    labelText: '时区设置',
                    prefixIcon: Icon(Icons.schedule),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                    ),
                  ),
                  items: TimeZone.supportedTimeZones.map((tz) {
                    return DropdownMenuItem(
                      value: tz['code']!,
                      child: Text(
                        tz['label']!,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null && TimeZone.isValidTimeZone(value)) {
                      setState(() => _selectedTimeZone = value);
                    }
                  },
                ),
                SizedBox(height: AppDimens.spacing24),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary),
                        ),
                      )
                    : FilledButton(
                        onPressed: _handleRegister,
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '注册',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
