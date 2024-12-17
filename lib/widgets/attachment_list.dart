import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/attachment.dart';
import '../utils/attachment_utils.dart';
import '../l10n/l10n.dart';
import '../widgets/download_progress_dialog.dart';
import 'package:file_picker/file_picker.dart';

class AttachmentList extends StatefulWidget {
  final List<Attachment> attachments;
  final bool showPreview;
  final double? maxHeight;
  final ScrollPhysics? physics;
  final bool canUpload;
  final ValueChanged<List<File>>? onAttachmentsSelected;
  final ValueChanged<Attachment>? onAttachmentDelete;

  const AttachmentList({
    Key? key,
    required this.attachments,
    this.showPreview = true,
    this.maxHeight,
    this.physics,
    this.canUpload = false,
    this.onAttachmentsSelected,
    this.onAttachmentDelete,
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
    if (widget.attachments.isEmpty && !widget.canUpload) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    Widget buildList() {
      return Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: widget.physics ?? const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.attachments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final attachment = widget.attachments[index];
              return _buildAttachmentItem(attachment);
            },
          ),
          if (widget.canUpload) ...[
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.attachments,
              style: theme.textTheme.titleMedium,
            ),
            if (widget.canUpload) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _pickFiles,
                tooltip: l10n.addAttachment,
              ),
            ],
          ],
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

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && mounted) {
        final files = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();

        widget.onAttachmentsSelected?.call(files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(L10n.of(context).fileSelectFailed(e.toString()))),
        );
      }
    }
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

  Widget _buildAttachmentItem(Attachment attachment) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isImage = AttachmentUtils.isImage(attachment.extension);

    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleAttachmentTap(attachment),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              // 缩略图/图标区域
              Container(
                width: 56,
                height: 56,
                color: colorScheme.surfaceContainerLow,
                child: isImage
                    ? FutureBuilder<String>(
                        future:
                            AttachmentUtils.getAttachmentLocalPath(attachment),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              File(snapshot.data!).existsSync()) {
                            return Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildFileIcon(attachment),
                            );
                          }
                          return _buildFileIcon(attachment);
                        },
                      )
                    : _buildFileIcon(attachment),
              ),
              // 文件信息区域
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 文件名
                      Text(
                        _truncateFileName(attachment.originName),
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // 文件大小
                      Text(
                        _formatFileSize(attachment.fileLength),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 操作按钮区域
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onAttachmentDelete != null)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () =>
                          widget.onAttachmentDelete?.call(attachment),
                      color: colorScheme.error,
                      tooltip: L10n.of(context).delete,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建文件图标
  Widget _buildFileIcon(Attachment attachment) {
    return Center(
      child: Icon(
        _getFileIcon(attachment.extension),
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
    );
  }

  // 截断文件名
  String _truncateFileName(String fileName) {
    if (fileName.length <= 20) return fileName;

    final extension = fileName.split('.').last;
    final nameWithoutExt =
        fileName.substring(0, fileName.length - extension.length - 1);

    if (nameWithoutExt.length <= 16) return fileName;

    return '${nameWithoutExt.substring(0, 16)}....$extension';
  }

  // 处理附件点击
  Future<void> _handleAttachmentTap(Attachment attachment) async {
    try {
      await AttachmentUtils.previewAttachment(
        context,
        attachment,
        _downloadProgress,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).fileOpenFailed)),
        );
      }
    }
  }
}
