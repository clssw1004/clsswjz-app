import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/server_config_provider.dart';
import '../../models/server_config.dart';
import '../../widgets/app_bar_factory.dart';
import '../../l10n/l10n.dart';
import 'widgets/add_server_dialog.dart';

class ServerManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.serverManagement),
      ),
      body: Consumer<ServerConfigProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 添加服务器按钮
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: () => _showAddServerDialog(context),
                  icon: Icon(Icons.add),
                  label: Text(l10n.addServer),
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ),

              // 服务器列表
              Expanded(
                child: ListView.builder(
                  itemCount: provider.configs.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final config = provider.configs[index];
                    final isSelected = config.id == provider.selectedConfig?.id;

                    return _buildServerCard(context, config);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getServerIcon(ServerType type) {
    switch (type) {
      case ServerType.selfHosted:
        return Icons.dns_outlined;
      case ServerType.clsswjzCloud:
        return Icons.cloud_outlined;
      case ServerType.localStorage:
        return Icons.storage_outlined;
    }
  }

  void _showAddServerDialog(BuildContext context) {
    final provider = context.read<ServerConfigProvider>();
    showDialog(
      context: context,
      builder: (context) => AddServerDialog(
        existingServers: provider.configs,
      ),
    );
  }

  void _editServer(BuildContext context, ServerConfig config) {
    // TODO: 实现编辑功能
  }

  void _deleteServer(
    BuildContext context,
    ServerConfigProvider provider,
    ServerConfig config,
  ) {
    final l10n = L10n.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteServer),
        content: Text(l10n.confirmDeleteServerMessage(config.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              provider.deleteConfig(config.id);
              Navigator.pop(context);
            },
            child: Text(l10n.delete),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerCard(BuildContext context, ServerConfig config) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: config.id ==
                  Provider.of<ServerConfigProvider>(context).selectedConfig?.id
              ? colorScheme.primary
              : colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: () => Provider.of<ServerConfigProvider>(context, listen: false)
            .selectConfig(config.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getServerIcon(config.type),
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      config.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (config.id ==
                      Provider.of<ServerConfigProvider>(context)
                          .selectedConfig
                          ?.id)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                    ),
                ],
              ),
              if (config.type == ServerType.selfHosted &&
                  config.serverUrl != null) ...[
                SizedBox(height: 8),
                Text(
                  config.serverUrl!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (config.id ==
                  Provider.of<ServerConfigProvider>(context)
                      .selectedConfig
                      ?.id) ...[
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _editServer(context, config),
                      icon: Icon(Icons.edit_outlined),
                      label: Text(L10n.of(context).edit),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _deleteServer(
                          context,
                          Provider.of<ServerConfigProvider>(context,
                              listen: false),
                          config),
                      icon: Icon(Icons.delete_outline),
                      label: Text(L10n.of(context).delete),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
              Text(
                config.type.getLabel(context),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
