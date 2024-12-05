import 'package:flutter/material.dart';
import './message_type.dart';
import '../widgets/message_widget.dart';

class MessageHelper {
  static void showMessage(
    BuildContext context, {
    required String message,
    required MessageType type,
    VoidCallback? onAction,
    String? actionLabel,
    Duration duration = const Duration(seconds: 4),
    bool floating = true,
  }) {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + (floating ? 16 : 0),
        left: 16,
        right: 16,
        child: SafeArea(
          child: MessageWidget(
            message: message,
            type: type,
            onAction: onAction,
            actionLabel: actionLabel,
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    VoidCallback? onAction,
    String? actionLabel,
    Duration? duration,
    bool showInRelease = false,
  }) {
    if (!const bool.fromEnvironment('dart.vm.product') && !showInRelease) {
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 80 + mediaQuery.padding.bottom,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    VoidCallback? onAction,
    String? actionLabel,
    Duration? duration,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onErrorContainer,
          ),
        ),
        backgroundColor: colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: 80 + mediaQuery.padding.bottom, // 底部导航栏高度 + 底部安全区域
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: colorScheme.onErrorContainer,
                onPressed: onAction,
              )
            : null,
        duration: Duration(seconds: 3),
      ),
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    VoidCallback? onAction,
    String? actionLabel,
    Duration? duration,
  }) {
    showMessage(
      context,
      message: message,
      type: MessageType.warning,
      onAction: onAction,
      actionLabel: actionLabel,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    VoidCallback? onAction,
    String? actionLabel,
    Duration? duration,
  }) {
    showMessage(
      context,
      message: message,
      type: MessageType.info,
      onAction: onAction,
      actionLabel: actionLabel,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
