import 'package:flutter/material.dart';
import '../utils/message_type.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final MessageType type;
  final VoidCallback? onAction;
  final String? actionLabel;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.type,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    IconData iconData;

    switch (type) {
      case MessageType.success:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        iconData = Icons.check_circle_outline;
        break;
      case MessageType.error:
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        iconData = Icons.error_outline;
        break;
      case MessageType.warning:
        backgroundColor = colorScheme.tertiaryContainer;
        foregroundColor = colorScheme.onTertiaryContainer;
        iconData = Icons.warning_amber_outlined;
        break;
      case MessageType.info:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        iconData = Icons.info_outline;
        break;
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              iconData,
              color: foregroundColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: foregroundColor,
                ),
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(width: 12),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: foregroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
