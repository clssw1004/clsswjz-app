import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import '../../../utils/message_helper.dart';
import '../../../constants/theme_constants.dart';

class ServerUrlDialog extends StatefulWidget {
  @override
  State<ServerUrlDialog> createState() => _ServerUrlDialogState();
}

class _ServerUrlDialogState extends State<ServerUrlDialog> {
  late TextEditingController _controller;
  bool _isChecking = false;
  String? _checkResult;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadServerUrl();
  }

  Future<void> _loadServerUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final url = prefs.getString('apiGateway') ?? 'http://192.168.2.147:3000';
      if (!mounted) return;
      setState(() {
        _controller.text = url;
      });
    } catch (e) {
      print('加载服务地址失败: $e');
      _controller.text = 'http://192.168.2.147:3000';
    }
  }

  Future<void> _checkServer(String url) async {
    if (url.isEmpty) {
      setState(() => _checkResult = '请输入服务地址');
      return;
    }

    setState(() {
      _isChecking = true;
      _checkResult = null;
    });

    try {
      final status = await ApiService.checkServerStatus(url);
      if (!mounted) return;

      setState(() {
        _checkResult = '服务正常\n'
            '数据库状态: ${status.database.status}\n'
            '内存使用: ${status.memory.heapUsed}/${status.memory.heapTotal}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkResult = '服务异常: ${e.toString()}');
    } finally {
      setState(() => _isChecking = false);
    }
  }

  Future<void> _saveServerUrl(String url) async {
    if (url.isEmpty) {
      MessageHelper.showError(context, message: '请输入服务地址');
      return;
    }

    try {
      // 先检查服务是否可用
      await ApiService.checkServerStatus(url);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiGateway', url);

      if (!mounted) return;
      Navigator.pop(context);
      MessageHelper.showSuccess(
        context,
        message: '保存成功，请重启应用',
        showInRelease: true,
      );
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: '保存失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < AppDimens.breakpointMobile;

    return Dialog(
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.dialogMaxWidth,
          maxHeight: mediaQuery.size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.dialogPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Text(
                '后台服务设置',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: AppDimens.spacing24),

              // 服务地址输入框
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: '服务地址',
                  hintText: 'http://example.com:3000',
                  prefixIcon: Icon(Icons.dns_outlined),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.inputRadius),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.inputRadius),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.inputRadius),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: AppDimens.spacing16),

              // 检测按钮
              FilledButton.tonal(
                onPressed: _isChecking
                    ? null
                    : () => _checkServer(_controller.text.trim()),
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, AppDimens.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
                  ),
                ),
                child: _isChecking
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onSecondaryContainer,
                          ),
                        ),
                      )
                    : Text('检测服务'),
              ),

              // 检测结果
              if (_checkResult != null) ...[
                SizedBox(height: AppDimens.spacing12),
                Container(
                  padding: EdgeInsets.all(AppDimens.spacing12),
                  decoration: BoxDecoration(
                    color: _checkResult!.contains('正常')
                        ? colorScheme.primaryContainer
                        : colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppDimens.cardRadius),
                  ),
                  child: Text(
                    _checkResult!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _checkResult!.contains('正常')
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],

              // 提示信息
              SizedBox(height: AppDimens.spacing12),
              Text(
                '修改后需要重启应用才能生效',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),

              // 操作按钮
              SizedBox(height: AppDimens.spacing24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消'),
                  ),
                  SizedBox(width: AppDimens.spacing8),
                  FilledButton(
                    onPressed: () async {
                      await _saveServerUrl(_controller.text.trim());
                    },
                    child: Text('保存'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
