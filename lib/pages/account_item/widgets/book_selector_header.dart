import 'package:flutter/material.dart';
import '../../../services/user_service.dart';
import '../../../constants/book_icons.dart';
import '../../../l10n/l10n.dart';

class BookSelectorHeader extends StatelessWidget {
  final Map<String, dynamic>? selectedBook;
  final List<Map<String, dynamic>> books;
  final ValueChanged<Map<String, dynamic>> onBookSelected;

  const BookSelectorHeader({
    Key? key,
    required this.selectedBook,
    required this.books,
    required this.onBookSelected,
  }) : super(key: key);

  IconData _getBookIcon(Map<String, dynamic>? book) {
    if (book == null) return BookIcons.defaultIcon;

    final String? iconString = book['icon']?.toString();
    if (iconString == null || iconString.isEmpty) {
      return BookIcons.defaultIcon;
    }

    try {
      return IconData(
        int.parse(iconString),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return BookIcons.defaultIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: () => _showBookSelector(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                radius: 24,
                child: Icon(
                  Icons.account_balance_wallet,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedBook?['name'] ?? l10n.selectBookHeader,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (selectedBook?['description'] != null) ...[
                      SizedBox(height: 4),
                      Text(
                        selectedBook!['description'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showBookSelector(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final currentUserId = UserService.getUserInfo()?.id;

    if (books.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noAvailableBooks)),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.selectBookHeader,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final isSelected = selectedBook?['id'] == book['id'];
              final isShared = book['createdBy'] != currentUserId;

              return ListTile(
                selected: isSelected,
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  child: Icon(
                    _getBookIcon(book),
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        book['name'] ?? l10n.unnamedBook,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isShared) ...[
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4),
                      Text(
                        l10n.sharedBookLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: book['description'] != null &&
                        book['description'].isNotEmpty
                    ? Text(
                        book['description'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () => Navigator.pop(context, book),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
        ],
      ),
    );

    if (result != null) {
      onBookSelected(result);
    }
  }
}
