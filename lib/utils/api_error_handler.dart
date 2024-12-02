import 'package:flutter/material.dart';
import './run_mode_util.dart';
import './message_helper.dart';

class ApiErrorHandler {
  static Future<void> handleError(BuildContext context, dynamic error) async {
    final isDebug = await RunModeUtil.isDebugMode();

    if (isDebug) {
      // 调试模式展示详细错误信息
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('API 错误'),
            content: SingleChildScrollView(
              child: Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('关闭'),
              ),
            ],
          ),
        );
      }
    } else {
      // 生产模式展示友好提示
      if (context.mounted) {
        MessageHelper.showError(
          context,
          message: '操作失败，请稍后重试',
        );
      }
    }
  }

  // 包装 API 调用的辅助方法
  static Future<T> wrapRequest<T>(
    BuildContext context,
    Future<T> Function() apiCall,
  ) async {
    try {
      return await apiCall();
    } catch (e) {
      await handleError(context, e);
      rethrow;
    }
  }
}
