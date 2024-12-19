import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/server_config_provider.dart';
import '../../../l10n/l10n.dart';
import 'add_server_dialog.dart';

class ServerSelector extends StatelessWidget {
  const ServerSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return Consumer<ServerConfigProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const CircularProgressIndicator();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: provider.selectedConfig?.id,
              decoration: InputDecoration(
                labelText: l10n.selectServer,
                prefixIcon: const Icon(Icons.dns_outlined, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              items: provider.configs.map((config) {
                return DropdownMenuItem(
                  value: config.id,
                  child: Text(
                    config.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  provider.selectConfig(id);
                }
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showAddServerDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: Text(l10n.addServer),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
                  textStyle: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ],
        );
      },
    );
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
} 