import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../models/form_selector.dart';
import '../../../widgets/form/form_selector_field.dart';

class FundSelector extends StatelessWidget {
  static const String NO_FUND = 'NO_FUND';

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

  static Map<String, dynamic> getNoFundOption(AppLocalizations l10n) => {
        'id': NO_FUND,
        'name': l10n.noFund,
        'fundType': '',
        'fundRemark': '',
        'fundBalance': 0.0,
        'isDefault': false,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        final items = [
          getNoFundOption(l10n),
          ...provider.fundList,
        ];

        return FormSelectorField<Map<String, dynamic>>(
          items: items,
          value: selectedFund?['id'],
          icon: Icons.account_balance_wallet_outlined,
          placeholder: l10n.selectFundHint,
          required: isRequired,
          config: FormSelectorConfig<Map<String, dynamic>>(
            idField: 'id',
            labelField: 'name',
            valueField: 'id',
            dialogTitle: l10n.selectFund,
            searchHint: l10n.searchFund,
            noDataText: l10n.noAvailableFunds,
            addItemTemplate: '', // 账户不支持快速添加
            showSearch: true,
            showAddButton: false,
            mode: FormSelectorMode.standard,
          ),
          callbacks: FormSelectorCallbacks(
            onChanged: (value) {
              final fund = items.firstWhere((f) => f['id'] == value);
              onChanged(fund);
            },
            onTap: onTap,
          ),
        );
      },
    );
  }
}
