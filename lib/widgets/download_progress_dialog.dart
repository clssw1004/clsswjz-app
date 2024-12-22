import 'package:clsswjz/theme/app_theme.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding,
          vertical: AppDimens.paddingSmall,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: progress,
              color: colorScheme.primary,
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
