import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../l10n/app_localizations.dart';
import '../models/attachment.dart';
import '../services/api_service.dart';
import '../widgets/app_bar_factory.dart';
import '../widgets/download_progress_dialog.dart';

class AttachmentUtils {
  /// 文件操作相关
  static Future<Directory> getAttachmentCacheDir() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception('Failed to get external storage directory');
      }
      return _createDirIfNotExists('${dir.path}/attachments');
    } else {
      final cacheDir = await getTemporaryDirectory();
      return _createDirIfNotExists('${cacheDir.path}/attachments');
    }
  }

  static Future<Directory> _createDirIfNotExists(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// 下载相关
  static Future<File> downloadAttachment(
    BuildContext context,
    Attachment attachment,
    StreamController<double> progressController,
  ) async {
    try {
      // 检查缓存
      final localPath = await getAttachmentLocalPath(attachment);
      final localFile = File(localPath);

      if (await localFile.exists()) {
        progressController.add(100);
        return localFile;
      }

      // 显示下载进度
      BuildContext? dialogContext;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return StreamBuilder<double>(
            stream: progressController.stream,
            initialData: 0.0,
            builder: (context, snapshot) {
              return DownloadProgressDialog(progress: snapshot.data!);
            },
          );
        },
      );

      try {
        // 下载文件
        final downloadedFile = await ApiService.downloadAttachment(
          attachment.id,
          onProgress: (received, total) {
            if (total > 0) {
              progressController.add((received / total) * 100);
            }
          },
        );

        await downloadedFile.copy(localPath);
        await downloadedFile.delete();
        return localFile;
      } finally {
        // 确保关闭进度对话框
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.of(dialogContext!).pop();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<File> saveToDownloads(
    File sourceFile,
    String fileName,
  ) async {
    if (Platform.isAndroid) {
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final downloadPath = path.join(downloadsDir.path, fileName);
      return sourceFile.copy(downloadPath);
    }
    throw UnsupportedError('Platform not supported');
  }

  /// 预览相关
  static Future<void> previewAttachment(
    BuildContext context,
    Attachment attachment,
    StreamController<double> progressController,
  ) async {
    try {
      // 下载文件
      final file = await downloadAttachment(
        context,
        attachment,
        progressController,
      );

      if (context.mounted) {
        // 根据文件类型显示不同的预览界面
        if (isImage(attachment.extension)) {
          await showImagePreview(context, file, attachment.originName);
        } else {
          await showUnsupportedPreview(
            context,
            attachment.originName,
            () => _handleDownload(context, file, attachment.originName),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).fileOpenFailed)),
        );
      }
    }
  }

  static Future<void> _handleDownload(
    BuildContext context,
    File file,
    String fileName,
  ) async {
    try {
      final downloadedFile = await saveToDownloads(file, fileName);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              L10n.of(context)
                  .fileDownloaded(path.basename(downloadedFile.path)),
            ),
            action: SnackBarAction(
              label: L10n.of(context).confirm,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).downloadFailed)),
        );
      }
    }
  }

  /// 工具方法
  static bool isImage(String extension) {
    return ['jpg', 'jpeg', 'png', 'gif', 'webp']
        .contains(extension.toLowerCase());
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

  static Future<String> getAttachmentLocalPath(Attachment attachment) async {
    final dir = await getAttachmentCacheDir();
    return '${dir.path}/${attachment.id}_${attachment.originName}';
  }

  /// 显示图片预览
  static Future<void> showImagePreview(
    BuildContext context,
    File file,
    String fileName,
  ) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true, // 允许点击空白区关闭
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
                  icon: const Icon(Icons.download, color: Colors.white),
                  tooltip: L10n.of(context).download,
                  onPressed: () async {
                    try {
                      if (Platform.isAndroid) {
                        final downloadsDir =
                            Directory('/storage/emulated/0/Download');
                        if (!await downloadsDir.exists()) {
                          await downloadsDir.create(recursive: true);
                        }

                        final downloadPath = path.join(
                          downloadsDir.path,
                          fileName,
                        );

                        await file.copy(downloadPath);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '图片已保存到: ${path.basename(downloadPath)}'),
                              action: SnackBarAction(
                                label: '确定',
                                onPressed: () {},
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(L10n.of(context).downloadFailed)),
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

  /// 显示不支持预览的提示页面
  static Future<void> showUnsupportedPreview(
    BuildContext context,
    String fileName,
    VoidCallback onDownload,
  ) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        pageBuilder: (context, _, __) => PopScope(
          canPop: true,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
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
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      getFileIcon(fileName),
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      L10n.of(context).unsupportedPreview,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        onDownload();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.download),
                      label: Text(L10n.of(context).download),
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
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
