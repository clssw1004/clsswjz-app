import 'package:flutter/material.dart';
import '../../../constants/theme_constants.dart';
import './fund_text_field.dart';
import './fund_type_selector.dart';
import './fund_balance_input.dart';
import '../../../l10n/l10n.dart';

class FundBasicInfoCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController remarkController;
  final TextEditingController balanceController;
  final String selectedType;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String> onBalanceChanged;
  final bool showBalance;

  const FundBasicInfoCard({
    Key? key,
    required this.nameController,
    required this.remarkController,
    required this.balanceController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onBalanceChanged,
    this.showBalance = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.padding),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
            ),
            child: Text(
              l10n.basicInfo,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FundTextField(
                  controller: nameController,
                  label: l10n.accountName,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: AppDimens.padding),
                FundTextField(
                  controller: remarkController,
                  label: l10n.accountRemark,
                ),
                SizedBox(height: AppDimens.padding),
                FundTypeSelector(
                  value: selectedType,
                  onChanged: onTypeChanged,
                ),
                if (showBalance) ...[
                  SizedBox(height: AppDimens.padding),
                  FundBalanceInput(
                    controller: balanceController,
                    onChanged: onBalanceChanged,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
