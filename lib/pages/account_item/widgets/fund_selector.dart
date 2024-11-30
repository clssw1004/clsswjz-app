import 'package:clsswjz_app/theme/theme_provider.dart';
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
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: OutlinedButton(
            onPressed: () => _showFundSelector(context, provider, themeColor),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: isDark ? Colors.white10 : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 20,
                  color: selectedFund != null ? themeColor : (isDark ? Colors.white60 : Colors.grey[600]),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFund?['fundName'] ?? '选择账户',
                    style: TextStyle(
                      color: selectedFund != null 
                          ? (isDark ? Colors.white : Colors.grey[800])
                          : (isDark ? Colors.white60 : Colors.grey[600]),
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFundSelector(
    BuildContext context,
    AccountItemProvider provider,
    Color themeColor,
  ) {
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
                                ? themeColor 
                                : (isDark ? Colors.white : Colors.grey[800]),
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: themeColor.withOpacity(0.12),
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