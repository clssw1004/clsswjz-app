import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../constants/app_colors.dart';
import '../utils/amount_formatter.dart';

class AccountItemTile extends StatelessWidget {
  final AccountItem item;
  final VoidCallback onTap;

  const AccountItemTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      if (item.description?.isNotEmpty == true) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${item.type == 'EXPENSE' ? '-' : '+'}${AmountFormatter.formatWithSymbol(
                    item.amount,
                    '¥',
                    locale,
                  )}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: item.type == 'EXPENSE'
                        ? AppColors.expense
                        : AppColors.income,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (item.fundId != null && item.fundName?.isNotEmpty == true) ...[
                  _buildTag(
                    context,
                    colorScheme.primaryContainer.withOpacity(0.5),
                    colorScheme.onPrimaryContainer,
                    Icons.account_balance_wallet_outlined,
                    item.fundName!,
                  ),
                  const SizedBox(width: 8),
                ],
                if (item.shop?.isNotEmpty == true)
                  _buildTag(
                    context,
                    colorScheme.tertiaryContainer.withOpacity(0.5),
                    colorScheme.onTertiaryContainer,
                    Icons.store_outlined,
                    item.shop!,
                  ),
                const Spacer(),
                Text(
                  DateFormat('HH:mm').format(item.accountDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTag(
    BuildContext context,
    Color backgroundColor,
    Color foregroundColor,
    IconData icon,
    String text,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: foregroundColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
} 