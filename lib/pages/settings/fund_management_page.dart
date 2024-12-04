import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../utils/message_helper.dart';
import '../../widgets/app_bar_factory.dart';
import '../../constants/fund_type.dart';
import 'fund_edit_page.dart';

class FundManagementPage extends StatefulWidget {
  @override
  State<FundManagementPage> createState() => _FundManagementPageState();
}

class _FundManagementPageState extends State<FundManagementPage> {
  List<UserFund> _funds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFunds();
  }

  Future<void> _loadFunds() async {
    setState(() => _isLoading = true);
    try {
      final funds = await ApiService.getUserFunds();
      setState(() => _funds = funds);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _editFund(UserFund fund) async {
    final result = await Navigator.push<UserFund>(
      context,
      MaterialPageRoute(
        builder: (context) => FundEditPage(fund: fund),
      ),
    );

    if (result != null) {
      await _loadFunds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, '账户管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _editFund(UserFund(
              id: '',
              name: '',
              fundType: FundType.CASH.name,
              fundRemark: '',
              fundBalance: 0,
            )),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: _funds.length,
              itemBuilder: (context, index) {
                final fund = _funds[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            fund.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '¥${fund.fundBalance.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (fund.fundRemark.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(
                            fund.fundRemark,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                FundType.fromString(fund.fundType).label,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${fund.fundBooks.length}个关联账本',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _editFund(fund),
                  ),
                );
              },
            ),
    );
  }
}
