import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/server_config.dart';
import '../../../providers/server_config_provider.dart';
import '../../../l10n/l10n.dart';
import '../../../constants/server_constants.dart';

class AddServerDialog extends StatefulWidget {
  final ServerConfig? initialValue;
  final List<ServerConfig> existingServers;

  const AddServerDialog({
    super.key,
    this.initialValue,
    required this.existingServers,
  });

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

  bool get _isCloudOrLocalExists {
    return widget.existingServers.any((server) =>
        server.type == ServerType.clsswjzCloud ||
        server.type == ServerType.localStorage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );

    return AlertDialog(
      surfaceTintColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: Text(l10n.addServer),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 服务器名称
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(
                  labelText: l10n.serverName,
                  hintText: l10n.serverNameHint,
                  prefixIcon: const Icon(Icons.dns_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.serverNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 服务器类型
              DropdownButtonFormField<ServerType>(
                value: _type,
                decoration: inputDecoration.copyWith(
                  labelText: l10n.serverType,
                  prefixIcon: const Icon(Icons.storage_outlined),
                ),
                items: ServerType.values.map((type) {
                  final isEnabled = (type != ServerType.localStorage) &&
                      (!_isCloudOrLocalExists ||
                          widget.initialValue?.type == type);
                  return DropdownMenuItem(
                    value: type,
                    enabled: isEnabled,
                    child: Text(
                      type.getLabel(context),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isEnabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withOpacity(0.38),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
              ),

              // 服务器地址（仅自托管服务器显示）
              if (_type == ServerType.selfHosted) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: inputDecoration.copyWith(
                    labelText: l10n.serverUrl,
                    hintText: l10n.serverUrlHint,
                    prefixIcon: const Icon(Icons.link),
                  ),
                  validator: (value) {
                    if (_type == ServerType.selfHosted) {
                      if (value == null || value.isEmpty) {
                        return l10n.serverUrlRequired;
                      }
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          child: Text(l10n.add),
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
      serverUrl: _type == ServerType.clsswjzCloud
          ? ServerConstants.clsswjzCloudUrl
          : _urlController.text,
    );

    context.read<ServerConfigProvider>().addConfig(config);
    Navigator.pop(context);
  }
}
