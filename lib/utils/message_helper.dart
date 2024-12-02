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
  }) {
    showMessage(
      context,
      message: message,
      type: MessageType.success,
      onAction: onAction,
      actionLabel: actionLabel,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    VoidCallback? onAction,
    String? actionLabel,
    Duration? duration,
  }) {
    showMessage(
      context,
      message: message,
      type: MessageType.error,
      onAction: onAction,
      actionLabel: actionLabel,
      duration: duration ?? const Duration(seconds: 4),
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
