import 'package:flutter/material.dart';

class AvatarFactory {
  static Widget buildCircleAvatar({
    required BuildContext context,
    required String text,
    double size = 40,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        text.substring(0, 1),
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
