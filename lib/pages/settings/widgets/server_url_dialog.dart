import 'package:flutter/material.dart';
import '../../../services/storage_service.dart';
import '../../../constants/storage_keys.dart';
import '../../../services/api_service.dart';
import '../../../utils/message_helper.dart';
import '../../../l10n/l10n.dart';
import '../../../models/server_status.dart';

class ServerUrlDialog extends StatefulWidget {
  const ServerUrlDialog({super.key});

  @override
  State<ServerUrlDialog> createState() => _ServerUrlDialogState();
}

class _ServerUrlDialogState extends State<ServerUrlDialog> {
  late TextEditingController _controller;
  bool _isChecking = false;
  ServerStatus _serverStatus = ServerStatus.error('');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadServerUrl();
  }

  Future<void> _loadServerUrl() async {
    try {
      final url = StorageService.getString(StorageKeys.serverUrl,
          defaultValue: 'http://192.168.2.147:3000');
      if (!mounted) return;
      setState(() {
        _controller.text = url;
      });
    } catch (e) {
      print('加载服务器地址失败: $e');
      _controller.text = 'http://192.168.2.147:3000';
    }
  }

  Future<void> _checkServer() async {
    setState(() => _isChecking = true);
    try {
      final status = await ApiService.checkServerStatus();
      if (!mounted) return;
      setState(() {
        _serverStatus = status;
        _isChecking = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _serverStatus = ServerStatus.error(e.toString());
        _isChecking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _saveServerUrl(String url) async {
    final l10n = L10n.of(context);
    if (url.isEmpty) {
      MessageHelper.showError(context, message: l10n.pleaseInputServerUrl);
      return;
    }

    try {
      ApiService.setBaseUrl(url);
      await ApiService.checkServerStatus();
      await StorageService.setString(StorageKeys.serverUrl, url);

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
    final l10n = L10n.of(context);

    print('Building ServerUrlDialog');

    return AlertDialog(
      title: Text(l10n.serverSettings),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: l10n.serverAddress,
                hintText: l10n.serverUrlHint,
                prefixIcon: const Icon(Icons.dns_outlined),
              ),
            ),
            const SizedBox(height: 16),
            if (_isChecking)
              const CircularProgressIndicator()
            else
              Text(
                _serverStatus.status == 'ok'
                    ? '服务器正常'
                    : '服务器异常：${_serverStatus.error}',
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => _checkServer(),
          child: Text(l10n.checkServer),
        ),
        FilledButton(
          onPressed: () => _saveServerUrl(_controller.text.trim()),
          child: Text(l10n.save),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
