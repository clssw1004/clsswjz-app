import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/server_config.dart';
import '../../../providers/server_config_provider.dart';

class AddServerDialog extends StatefulWidget {
  @override
  State<AddServerDialog> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<AddServerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  ServerType _type = ServerType.selfHosted;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加服务器'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '服务器名称',
                hintText: '例如：本地服务器',
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
              value: _type,
              decoration: const InputDecoration(
                labelText: '服务器类型',
              ),
              items: ServerType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            if (_type == ServerType.selfHosted) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: '服务器地址',
                  hintText: 'http://example.com:3000',
                ),
                validator: (value) {
                  if (_type == ServerType.selfHosted) {
                    if (value == null || value.isEmpty) {
                      return '请输入服务器地址';
                    }
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          child: const Text('添加'),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final config = ServerConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      type: _type,
      serverUrl: _type == ServerType.selfHosted ? _urlController.text : null,
    );

    context.read<ServerConfigProvider>().addConfig(config);
    Navigator.pop(context);
  }
}
