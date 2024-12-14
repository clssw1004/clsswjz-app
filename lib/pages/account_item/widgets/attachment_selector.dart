import 'dart:io' if (dart.library.html) 'dart:html' show File;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../l10n/l10n.dart';

class AttachmentSelector extends StatelessWidget {
  final List<File> attachments;
  final Function(List<File>) onAttachmentsChanged;

  const AttachmentSelector({
    Key? key,
    required this.attachments,
    required this.onAttachmentsChanged,
  }) : super(key: key);

  IconData _getFileIcon(String path) {
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

  Future<void> _pickFiles(BuildContext context) async {
    final l10n = L10n.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        final newFiles = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
        onAttachmentsChanged([...attachments, ...newFiles]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fileSelectFailed(e.toString()))),
      );
    }
  }

  void _removeAttachment(File file) {
    final newAttachments = List<File>.from(attachments)..remove(file);
    onAttachmentsChanged(newAttachments);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.attachments,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _pickFiles(context),
              tooltip: l10n.addAttachment,
            ),
          ],
        ),
        if (attachments.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: attachments.map((file) {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getFileIcon(file.path),
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          file.path.split('/').last,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, size: 18),
                      onPressed: () => _removeAttachment(file),
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
