import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/attachment.dart';
import '../services/api_service.dart';
import '../widgets/app_bar_factory.dart';

class AttachmentUtils {
  /// 获取附件缓存目录
  static Future<Directory> getAttachmentCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    final attachmentDir = Directory('${cacheDir.path}/attachments');
    if (!await attachmentDir.exists()) {
      await attachmentDir.create(recursive: true);
    }
    return attachmentDir;
  }

  /// 获取附件本地缓存路径
  static Future<String> getAttachmentLocalPath(Attachment attachment) async {
    final dir = await getAttachmentCacheDir();
    return '${dir.path}/${attachment.id}_${attachment.originName}';
  }

  /// 检查附件是否已缓存
  static Future<bool> isAttachmentCached(Attachment attachment) async {
    final path = await getAttachmentLocalPath(attachment);
    return File(path).exists();
  }

  /// 下载并缓存附件
  static Future<File> downloadAndCacheAttachment(
    Attachment attachment, {
    void Function(int received, int total)? onProgress,
  }) async {
    final localPath = await getAttachmentLocalPath(attachment);
    final localFile = File(localPath);

    if (await localFile.exists()) {
      // 如果本地已有缓存，直接返回，并通知进度为100%
      onProgress?.call(100, 100);
      return localFile;
    }

    final downloadedFile = await ApiService.downloadAttachment(
      attachment.id,
      onProgress: onProgress,
    );

    // 确保目标目录存在
    final dir = await getAttachmentCacheDir();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // 复制文件并验证
    await downloadedFile.copy(localPath);
    final newFile = File(localPath);
    if (!await newFile.exists()) {
      throw Exception('Failed to save downloaded file');
    }

    // 删除临时文件
    await downloadedFile.delete();

    return newFile;
  }

  /// 判断是否为图片
  static bool isImage(String extension) {
    return ['jpg', 'jpeg', 'png', 'gif', 'webp']
        .contains(extension.toLowerCase());
  }

  /// 打开附件
  static Future<bool> openAttachment(
    Attachment attachment, {
    void Function(int received, int total)? onProgress,
    BuildContext? context,
  }) async {
    try {
      // 先检查是否已缓存
      final localPath = await getAttachmentLocalPath(attachment);
      final localFile = File(localPath);
      final isCached = await localFile.exists();

      // 如果已缓存，直接通知100%进度
      if (isCached) {
        onProgress?.call(100, 100);
      }

      final file = await downloadAndCacheAttachment(
        attachment,
        onProgress: isCached ? null : onProgress, // 已缓存时不需要进度回调
      );

      if (kIsWeb) {
        final url = Uri.parse('/api/attachments/${attachment.id}');
        return launchUrl(url);
      } else {
        if (context != null && isImage(attachment.extension)) {
          // 如果是图片且提供了context，显示预览对话框
          if (context.mounted) {
            await showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBarFactory.buildAppBar(
                      context: context,
                      title: AppBarFactory.buildTitle(
                          context, attachment.originName),
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          tooltip: L10n.of(context).openInExternalApp,
                          onPressed: () {
                            final uri = Uri.file(file.path);
                            launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        ),
                      ],
                    ),
                    Flexible(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.file(
                          file,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.broken_image_outlined,
                                    size: 48),
                                const SizedBox(height: 16),
                                Text('Failed to load image: $error'),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return true;
        } else {
          // 其他文件使用系统默认应用打开
          final uri = Uri.file(file.path);
          return launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to open attachment: $e');
      return false;
    }
  }

  /// 清理过期缓存
  static Future<void> cleanExpiredCache({Duration? maxAge}) async {
    try {
      final dir = await getAttachmentCacheDir();
      final now = DateTime.now();
      final maxAgeDate = now.subtract(maxAge ?? const Duration(days: 7));

      await for (final entity in dir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(maxAgeDate)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to clean attachment cache: $e');
    }
  }

  static IconData getFileIcon(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}
