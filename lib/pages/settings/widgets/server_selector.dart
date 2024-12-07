import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/server_config.dart';
import '../../../providers/server_config_provider.dart';
import 'add_server_dialog.dart';
import 'server_selector_dialog.dart';

class ServerSelector extends StatelessWidget {
  const ServerSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(
                labelText: '选择服务器',
                prefixIcon: Icon(Icons.dns_outlined),
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
              label: const Text('添加服务器'),
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