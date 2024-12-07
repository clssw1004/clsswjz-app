import 'package:flutter/material.dart';
import '../../../models/server_config.dart';

class ServerSelectorDialog extends StatefulWidget {
  final ServerConfig? initialValue;
  final List<ServerConfig> servers;
  final Function(ServerConfig) onSave;
  final VoidCallback? onDelete;

  const ServerSelectorDialog({
    super.key,
    this.initialValue,
    required this.servers,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<ServerSelectorDialog> createState() => _ServerSelectorDialogState();
}

class _ServerSelectorDialogState extends State<ServerSelectorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late ServerType _selectedType;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final config = widget.initialValue;
    _nameController = TextEditingController(text: config?.name);
    _urlController = TextEditingController(text: config?.serverUrl);
    _selectedType = config?.type ?? ServerType.selfHosted;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  bool get _isCloudOrLocalExists {
    return widget.servers.any((server) =>
        server.type == ServerType.clsswjzCloud ||
        server.type == ServerType.localStorage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(widget.initialValue == null ? '添加服务器' : '编辑服务器'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '服务器名称',
                hintText: '请输入服务器名称',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入服务器名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ServerType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: '服务器类型',
              ),
              items: [
                DropdownMenuItem(
                  value: ServerType.selfHosted,
                  child: const Text('Self-hosted'),
                ),
                DropdownMenuItem(
                  value: ServerType.clsswjzCloud,
                  enabled: !_isCloudOrLocalExists || 
                    widget.initialValue?.type == ServerType.clsswjzCloud,
                  child: const Text('Clsswjz云'),
                ),
                DropdownMenuItem(
                  value: ServerType.localStorage,
                  enabled: !_isCloudOrLocalExists || 
                    widget.initialValue?.type == ServerType.localStorage,
                  child: const Text('本地存储'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            if (_selectedType == ServerType.selfHosted) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: '服务器地址',
                  hintText: '请输入服务器地址',
                ),
                validator: (value) {
                  if (_selectedType == ServerType.selfHosted &&
                      (value == null || value.isEmpty)) {
                    return '请输入服务器地址';
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (widget.initialValue != null)
          TextButton(
            onPressed: widget.onDelete,
            child: Text(
              '删除',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final config = (widget.initialValue ?? ServerConfig(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: '',
                type: ServerType.selfHosted,
              )).copyWith(
                name: _nameController.text,
                type: _selectedType,
                serverUrl: _selectedType == ServerType.selfHosted
                    ? _urlController.text
                    : null,
              );
              widget.onSave(config);
              Navigator.of(context).pop();
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
} 