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

    return Consumer<ServerConfigProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const CircularProgressIndicator();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: provider.selectedConfig?.id,
              decoration: InputDecoration(
                labelText: l10n.selectServer,
                prefixIcon: const Icon(Icons.dns_outlined),
              ),
              items: provider.configs.map((config) {
                return DropdownMenuItem(
                  value: config.id,
                  child: Text(config.name),
                );
              }).toList(),
              onChanged: (id) {
                if (id != null) {
                  provider.selectConfig(id);
                }
              },
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showAddServerDialog(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addServer),
            ),
          ],
        );
      },
    );
  }

  void _showAddServerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddServerDialog(),
    );
  }
} 