import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';

class FundSelector extends StatefulWidget {
  final Map<String, dynamic>? selectedFund;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final String accountBookId;
  final bool isRequired;
  final VoidCallback? onTap;

  const FundSelector({
    Key? key,
    this.selectedFund,
    required this.onChanged,
    required this.accountBookId,
    this.isRequired = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<FundSelector> createState() => _FundSelectorState();
}

class _FundSelectorState extends State<FundSelector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider =
            Provider.of<AccountItemProvider>(context, listen: false);
        provider.loadFundList(widget.accountBookId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        final fundList = provider.fundList;

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
                Icons.account_balance_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    widget.onTap?.call();

                    if (fundList.isEmpty) return;

                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => Dialog(
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
                              ...fundList.map(
                                (fund) => ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    fund['fundName'] ?? '',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: fund['id'] ==
                                              widget.selectedFund?['id']
                                          ? colorScheme.primary
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                  leading: Icon(
                                    fund['id'] == widget.selectedFund?['id']
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    size: 20,
                                    color:
                                        fund['id'] == widget.selectedFund?['id']
                                            ? colorScheme.primary
                                            : null,
                                  ),
                                  onTap: () => Navigator.pop(context, fund),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (result != null) {
                      widget.onChanged(result);
                    }
                  },
                  child: Text(
                    '${widget.selectedFund?['fundName'] ?? '选择账户'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: widget.selectedFund != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  size: 18,
                ),
                onPressed: fundList.isEmpty ? null : () {},
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
      },
    );
  }
}
