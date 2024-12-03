import 'package:flutter/material.dart';

class ListItemCard extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? subtitle;

  const ListItemCard({
    Key? key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle,
        leading: leading,
        trailing: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: trailing ?? SizedBox(),
        ),
      ),
    );
  }
}
