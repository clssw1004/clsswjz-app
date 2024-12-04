import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';

class FundSelector extends StatelessWidget {
  final Map<String, dynamic>? selectedFund;
  final String accountBookId;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback? onTap;
  final bool isRequired;

  const FundSelector({
    Key? key,
    this.selectedFund,
    required this.accountBookId,
    required this.onChanged,
    this.onTap,
    this.isRequired = false,
  }) : super(key: key);

  void _showFundDialog(BuildContext context) {
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _FundDialog(
        selectedFundId: selectedFund?['id'],
        provider: provider,
      ),
    ).then((fund) {
      if (fund != null) {
        onChanged(fund);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 48,
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
            Icons.account_balance_wallet_outlined,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                onTap?.call();
                _showFundDialog(context);
              },
              child: Text(
                selectedFund?['name'] ?? '选择账户',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selectedFund != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 18),
            onPressed: () => _showFundDialog(context),
            color: colorScheme.onSurfaceVariant,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _FundDialog extends StatelessWidget {
  final String? selectedFundId;
  final AccountItemProvider provider;

  const _FundDialog({
    Key? key,
    this.selectedFundId,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      surfaceTintColor: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '选择账户',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: _buildFundList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFundList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fundList = provider.fundList;

    if (fundList.isEmpty) {
      return Center(
        child: Text(
          '暂无可用账户',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: fundList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final fund = fundList[index];
        final isSelected = fund['id'] == selectedFundId;

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Text(
            fund['name'],
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  fund['fundType'],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (fund['fundRemark']?.isNotEmpty == true) ...[
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fund['fundRemark'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? colorScheme.primary : null,
            size: 20,
          ),
          trailing: fund['isDefault']
              ? Icon(
                  Icons.star,
                  size: 16,
                  color: colorScheme.primary,
                )
              : null,
          onTap: () => Navigator.pop(context, fund),
        );
      },
    );
  }
}
