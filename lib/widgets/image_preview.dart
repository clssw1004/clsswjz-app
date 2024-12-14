import 'dart:io';
import 'package:flutter/material.dart';
import '../models/attachment.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_bar_factory.dart';
import '../l10n/l10n.dart';

class ImagePreview extends StatelessWidget {
  final Attachment attachment;
  final File file;

  const ImagePreview({
    Key? key,
    required this.attachment,
    required this.file,
  }) : super(key: key);

  Future<void> _openInExternalApp() async {
    final uri = Uri.file(file.path);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, attachment.originName),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: L10n.of(context).openInExternalApp,
            onPressed: _openInExternalApp,
          ),
        ],
      ),
      body: Center(
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
                  const Icon(Icons.broken_image_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load image: $error'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
} 