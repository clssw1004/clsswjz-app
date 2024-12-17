import 'package:flutter/material.dart';
import '../models/models.dart';
import '../l10n/l10n.dart';

import '../services/user_service.dart';

class AccountItemTile extends StatelessWidget {
  final AccountItem item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showCheckbox;
  final bool? isChecked;
  final ValueChanged<bool?>? onCheckChanged;

  const AccountItemTile({
    Key? key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.showCheckbox = false,
    this.isChecked,
    this.onCheckChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final isExpense = item.type == 'EXPENSE';
    final hasShop = item.shop != null && item.shop != 'NO_SHOP';
    final hasFund = item.fundId != null && item.fundId != 'NO_FUND';
    final currentUserId = UserService.getUserInfo()?['userId'];
    final showCreator =
        item.createdBy != currentUserId && item.createdByName != null;

    final timeStr = item.accountDate.split(' ')[1];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: showCheckbox ? 8 : 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showCheckbox) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: onCheckChanged,
                        shape: CircleBorder(),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      item.category,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isExpense ? '-' : '+'}${l10n.currencySymbol}${item.amount.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color:
                              isExpense ? colorScheme.error : Color(0xFF43A047),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (hasShop || hasFund || showCreator) ...[
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      child: Row(
                        children: [
                          if (hasShop) ...[
                            Icon(
                              Icons.store_outlined,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 4),
                            Text(item.shop!),
                          ],
                          if (hasShop && hasFund) ...[
                            Text(' · '),
                          ],
                          if (hasFund) ...[
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 4),
                            Text(item.fund!),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (showCreator) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.createdByName!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                        Text(
                          timeStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showCreator) ...[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.createdByName!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                    Text(
                      timeStr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
