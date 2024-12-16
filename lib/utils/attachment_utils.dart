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
  static Future<dynamic> openAttachment(
    Attachment attachment, {
    void Function(int received, int total)? onProgress,
    BuildContext? context,
  }) async {
    try {
      final localPath = await getAttachmentLocalPath(attachment);
      final localFile = File(localPath);
      final isCached = await localFile.exists();

      if (!isCached) {
        final downloadedFile = await downloadAndCacheAttachment(
          attachment,
          onProgress: onProgress,
        );
        return downloadedFile;
      }

      // 如果不是图片，直接用系统应用打开
      if (!isImage(attachment.extension) && localFile.existsSync()) {
        final uri = Uri.file(localFile.path);
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return true;
      }

      return localFile;
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

  /// 示图片预览
  static Future<void> showImagePreview(
    BuildContext context,
    File file,
    String fileName,
  ) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true, // 允许点击空白区域关闭
        barrierColor: Colors.black87,
        pageBuilder: (context, _, __) => PopScope(
          canPop: true,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true, // 内容延伸到AppBar下方
            appBar: AppBarFactory.buildAppBar(
              context: context,
              backgroundColor: Colors.black26,
              title: Text(
                fileName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.open_in_new, color: Colors.white),
                  tooltip: L10n.of(context).openInExternalApp,
                  onPressed: () async {
                    try {
                      final uri = Uri.file(file.path);
                      final success = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(L10n.of(context).fileOpenFailed),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(L10n.of(context).fileOpenFailed),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  // 全屏点击区域用于关闭
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      behavior: HitTestBehavior.opaque, // 确保即使透明也能接收点击
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // 图片预览区域
                  Center(
                    child: GestureDetector(
                      onTap: () {}, // 阻止点击事件冒泡
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.file(
                          file,
                          fit: BoxFit.contain,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame == null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                            return child;
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.broken_image_outlined,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Failed to load image: $error',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
