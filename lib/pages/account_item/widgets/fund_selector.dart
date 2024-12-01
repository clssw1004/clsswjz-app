import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';

class FundSelector extends StatelessWidget {
  final Map<String, dynamic>? selectedFund;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const FundSelector({
    Key? key,
    this.selectedFund,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: OutlinedButton(
            onPressed: () => _showFundSelector(context, provider),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: BorderSide(color: colorScheme.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 20,
                  color: selectedFund != null 
                      ? colorScheme.primary 
                      : colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFund?['fundName'] ?? '选择账户',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selectedFund != null 
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFundSelector(BuildContext context, AccountItemProvider provider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isExpense = provider.transactionType == 'EXPENSE';
    final availableFunds = provider.fundList.where((fund) =>
        isExpense ? fund['fundOut'] == true : fund['fundIn'] == true).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '选择账户',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: availableFunds.isEmpty
                ? Center(
                    child: Text(
                      '没有可用的${isExpense ? '支出' : '收入'}账户',
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableFunds.length,
                    itemBuilder: (context, index) {
                      final fund = availableFunds[index];
                      final isSelected = selectedFund?['id'] == fund['id'];
                      return ListTile(
                        title: Text(
                          fund['fundName'],
                          style: TextStyle(
                            color: isSelected 
                                ? colorScheme.primary 
                                : (isDark ? Colors.white : Colors.grey[800]),
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: colorScheme.primary.withOpacity(0.12),
                        onTap: () {
                          onChanged(fund);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
} 