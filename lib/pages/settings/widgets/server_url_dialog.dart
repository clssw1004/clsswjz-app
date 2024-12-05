import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import '../../../utils/message_helper.dart';
import '../../../constants/theme_constants.dart';
import '../../../l10n/l10n.dart';

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
    final l10n = L10n.of(context);
    if (url.isEmpty) {
      setState(() => _checkResult = l10n.pleaseInputServerUrl);
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
        _checkResult = l10n.serverStatusNormal(
          status.database.status,
          status.memory.heapUsed,
          status.memory.heapTotal,
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkResult = l10n.serverStatusError(e.toString()));
    } finally {
      setState(() => _isChecking = false);
    }
  }

  Future<void> _saveServerUrl(String url) async {
    final l10n = L10n.of(context);
    if (url.isEmpty) {
      MessageHelper.showError(context, message: l10n.pleaseInputServerUrl);
      return;
    }

    try {
      await ApiService.checkServerStatus(url);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('apiGateway', url);

      if (!mounted) return;
      Navigator.pop(context);
      MessageHelper.showSuccess(
        context,
        message: l10n.saveSuccess,
        showInRelease: true,
      );
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: l10n.saveFailed(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < AppDimens.breakpointMobile;
    final l10n = L10n.of(context);

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
                l10n.serverSettings,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: AppDimens.spacing24),

              // 服务地址输入框
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: l10n.serverAddress,
                  hintText: l10n.serverUrlHint,
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
                    : Text(l10n.checkServer),
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
                l10n.restartAppAfterChange,
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
                    child: Text(l10n.cancel),
                  ),
                  SizedBox(width: AppDimens.spacing8),
                  FilledButton(
                    onPressed: () async {
                      await _saveServerUrl(_controller.text.trim());
                    },
                    child: Text(l10n.save),
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
