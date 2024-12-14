import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

class DownloadProgressDialog extends StatelessWidget {
  final double progress;

  const DownloadProgressDialog({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: progress,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.downloadProgress(progress.toStringAsFixed(1)),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
} 