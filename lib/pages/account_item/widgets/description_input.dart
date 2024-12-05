import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';

class DescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
                hintText: l10n.descriptionHint,
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
              ),
              textInputAction: TextInputAction.newline,
              maxLines: 2,
              minLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
