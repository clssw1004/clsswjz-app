import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/attachment.dart';
import '../utils/attachment_utils.dart';
import '../l10n/l10n.dart';
import '../widgets/download_progress_dialog.dart';

class AttachmentList extends StatefulWidget {
  final List<Attachment> attachments;
  final bool showPreview;
  final double? maxHeight;
  final ScrollPhysics? physics;

  const AttachmentList({
    Key? key,
    required this.attachments,
    this.showPreview = true,
    this.maxHeight,
    this.physics,
  }) : super(key: key);

  @override
  State<AttachmentList> createState() => _AttachmentListState();
}

class _AttachmentListState extends State<AttachmentList> {
  final _downloadProgress = StreamController<double>.broadcast();

  @override
  void initState() {
    super.initState();
    _downloadProgress.add(0.0);
  }

  @override
  void dispose() {
    _downloadProgress.close();
    super.dispose();
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    Widget buildList() {
      return ListView.separated(
        shrinkWrap: true,
        physics: widget.physics ?? const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: widget.attachments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final attachment = widget.attachments[index];
          return Material(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                if (widget.showPreview && AttachmentUtils.isImage(attachment.extension)) {
                  // 重置进度
                  _downloadProgress.add(0.0);
                  
                  // 检查是否已缓存
                  final localPath = await AttachmentUtils.getAttachmentLocalPath(attachment);
                  final localFile = File(localPath);
                  final isCached = await localFile.exists();

                  BuildContext? dialogContext;
                  
                  // 只有未缓存时才显示进度对话框
                  if (!isCached && context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        dialogContext = context;
                        return StreamBuilder<double>(
                          stream: _downloadProgress.stream,
                          initialData: 0.0,
                          builder: (context, snapshot) {
                            return DownloadProgressDialog(
                              progress: snapshot.data! ,
                            );
                          },
                        );
                      },
                    );
                  }

                  try {
                    final success = await AttachmentUtils.openAttachment(
                      attachment,
                      onProgress: (received, total) {
                        if (total > 0) {
                          final progress = (received / total) * 100;
                          _downloadProgress.add(progress);
                        }
                      },
                      context: context,
                    );

                    // 关闭进度对话框（如果存在）
                    if (dialogContext != null && dialogContext!.mounted) {
                      Navigator.of(dialogContext!).pop();
                    }

                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fileOpenFailed)),
                      );
                    }
                  } catch (e) {
                    if (dialogContext != null && dialogContext!.mounted) {
                      Navigator.of(dialogContext!).pop();
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fileOpenFailed)),
                      );
                    }
                  }
                } else {
                  // 非图片文件直接调用系统打开
                  final success = await AttachmentUtils.openAttachment(
                    attachment,
                    onProgress: (received, total) {
                      if (total > 0) {
                        final progress = (received / total) * 100;
                        _downloadProgress.add(progress);
                      }
                    },
                  );

                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.fileOpenFailed)),
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      _getFileIcon(attachment.extension),
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attachment.originName,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatFileSize(attachment.fileLength),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.attachments,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (widget.maxHeight != null)
          SizedBox(
            height: widget.maxHeight,
            child: buildList(),
          )
        else
          buildList(),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
} 