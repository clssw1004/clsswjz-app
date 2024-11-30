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
    return Consumer2<AccountItemProvider, ThemeProvider>(
      builder: (context, provider, themeProvider, _) {
        final themeColor = themeProvider.themeColor;
        
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: OutlinedButton(
            onPressed: () => _showFundSelector(context, provider, themeColor),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 20,
                  color: selectedFund != null ? themeColor : Colors.grey[600],
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFund?['fundName'] ?? '选择账户',
                    style: TextStyle(
                      color: selectedFund != null ? Colors.grey[800] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
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
    final isExpense = provider.transactionType == 'EXPENSE';
    final availableFunds = provider.fundList.where((fund) =>
        isExpense ? fund['fundOut'] == true : fund['fundIn'] == true).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('选择账户'),
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: availableFunds.isEmpty
                ? Center(
                    child: Text(
                      '没有可用的${isExpense ? '支出' : '收入'}账户',
                      style: TextStyle(color: Colors.grey[600]),
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
                            color: isSelected ? themeColor : Colors.grey[800],
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