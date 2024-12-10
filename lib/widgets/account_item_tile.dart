import 'package:flutter/material.dart';
import '../models/models.dart';
import '../l10n/l10n.dart';

class AccountItemTile extends StatelessWidget {
  final AccountItem item;
  final VoidCallback? onTap;

  const AccountItemTile({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final isExpense = item.type == 'EXPENSE';
    final hasShop = item.shop != null && item.shop != 'NO_SHOP';
    final hasFund = item.fundId != null && item.fundId != 'NO_FUND';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.category,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    DefaultTextStyle(
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      child: Row(
                        children: [
                          if (hasShop)
                            Text(
                              item.shop!,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              l10n.noShop,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.onSurfaceVariant.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          if (hasFund)
                            Text(
                              item.fundName ?? '',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              l10n.noFund,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          if (item.description?.isNotEmpty == true) ...[
                            SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: colorScheme.onSurfaceVariant
                                    .withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                item.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Text(
                '${isExpense ? '-' : '+'}${l10n.currencySymbol}${item.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isExpense ? colorScheme.error : colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
