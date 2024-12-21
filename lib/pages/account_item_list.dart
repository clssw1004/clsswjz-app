import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../pages/account_item_info.dart';
import 'account_item/widgets/filter_section.dart';
import '../widgets/app_bar_factory.dart';
import '../widgets/global_book_selector.dart';
import '../utils/message_helper.dart';
import 'account_item/widgets/summary_card.dart';
import '../l10n/l10n.dart';
import '../widgets/account_item_tile.dart';
import '../constants/storage_keys.dart';
import '../services/storage_service.dart';
import '../providers/account_item_list_provider.dart';
import '../models/filter_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AccountItemList extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onBookSelected;
  final FilterState? initialFilterState;

  const AccountItemList({
    super.key,
    this.onBookSelected,
    this.initialFilterState,
  });

  @override
  State<AccountItemList> createState() => _AccountItemListState();
}

class _AccountItemListState extends State<AccountItemList>
    with AutomaticKeepAliveClientMixin {
  static const double _loadMoreThreshold = 1;
  final ScrollController _scrollController = ScrollController();
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProvider();
    });
  }

  Future<void> _initializeProvider() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final provider = context.read<AccountItemListProvider>();
      if (!provider.isInitialized) {
        final isExpanded = StorageService.getBool(
          StorageKeys.filterPanelPinned,
          defaultValue: false,
        );
        provider.setFilterExpanded(isExpanded);
        if (widget.initialFilterState != null) {
          provider.setFilterState(widget.initialFilterState!);
        }
        await provider.initializeAccountBooks();
      }
    } finally {
      _isInitializing = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent > 0) {
      final threshold =
          _scrollController.position.maxScrollExtent * _loadMoreThreshold;
      if (_scrollController.position.pixels >= threshold) {
        final provider = context.read<AccountItemListProvider>();
        if (!provider.isLoading && provider.hasMoreData) {
          provider.loadMoreData();
        }
      }
    }
  }

  Future<void> _toggleFilter() async {
    final provider = context.read<AccountItemListProvider>();
    final newState = !provider.isFilterExpanded;
    await StorageService.setBool(StorageKeys.filterPanelPinned, newState);
    if (mounted) {
      provider.setFilterExpanded(newState);
    }
  }

  void _addNewRecord() async {
    final provider = context.read<AccountItemListProvider>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(
          initialBook: provider.selectedBook,
        ),
      ),
    );

    if (result == true) {
      provider.loadAccountItems(isRefresh: true);
    }
  }

  void _editAccountItem(AccountItem item) async {
    final provider = context.read<AccountItemListProvider>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(
          initialData: item,
          initialBook: provider.selectedBook,
        ),
      ),
    );

    if (result == true) {
      await provider.loadAccountItems(isRefresh: true);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Consumer<AccountItemListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          extendBodyBehindAppBar: true,
          appBar: AppBarFactory.buildAppBar(
            context: context,
            title: GlobalBookSelector(
              selectedBook: provider.selectedBook,
              books: provider.accountBooks,
              onBookSelected: provider.setSelectedBook,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isFilterExpanded
                      ? Icons.filter_list
                      : Icons.filter_alt_outlined,
                  color: provider.filterState.hasFilter
                      ? colorScheme.primary
                      : null,
                ),
                tooltip: l10n.filter,
                onPressed: _toggleFilter,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                FilterSection(
                  isExpanded: provider.isFilterExpanded,
                  filterState: provider.filterState,
                  categories: provider.categories,
                  shops: provider.shops,
                  onFilterChanged: (newState) {
                    provider.setFilterState(newState);
                  },
                ),
                if (provider.summary != null)
                  SummaryCard(
                    key: ValueKey('summary_card'),
                    allIn: provider.summary!.allIn,
                    allOut: provider.summary!.allOut,
                    allBalance: provider.summary!.allBalance,
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => provider.loadAccountItems(isRefresh: true),
                    child: provider.items.isEmpty && !provider.isLoading
                        ? _buildEmptyView(colorScheme)
                        : _buildList(provider),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: provider.isBatchMode ||
                  provider.selectedBook == null ||
                  provider.selectedBook!.canEditItem == false
              ? null
              : FloatingActionButton(
                  onPressed: _addNewRecord,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 2,
                  tooltip: l10n.newRecord,
                  child: Icon(Icons.add),
                ),
          bottomNavigationBar: provider.isBatchMode
              ? SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: null, // 暂时禁用
                          child: Text(
                            l10n.edit,
                            style: TextStyle(
                              color: colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _batchDelete(provider),
                          child: Text(
                            l10n.delete,
                            style: TextStyle(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: provider.exitBatchMode,
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildEmptyView(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            L10n.of(context).noAccountItems,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(AccountItemListProvider provider) {
    if (provider.isLoading && provider.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.items.isEmpty) {
      return Center(
        child: Text(L10n.of(context).noAccountItems),
      );
    }

    return ListView(
      key: ValueKey('account_items_${provider.items.length}'),
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 80),
      children: [
        for (final date in provider.groupedItems.keys) ...[
          _buildDateHeader(date, provider.groupedItems[date]!),
          ...provider.groupedItems[date]!
              .map((item) => _buildListItem(item, provider)),
        ],
        if (provider.isLoading || !provider.hasMoreData)
          _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildDateHeader(String date, List<AccountItem> items) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    double dailyIncome = 0;
    double dailyExpense = 0;
    for (var item in items) {
      if (item.type == 'INCOME') {
        dailyIncome += item.amount;
      } else {
        dailyExpense += item.amount;
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            _formatDateHeader(date),
            style: theme.textTheme.titleSmall,
          ),
          Spacer(),
          if (dailyExpense > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_downward,
                  size: 14,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: 2),
                Text(
                  dailyExpense.toStringAsFixed(2),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          if (dailyExpense > 0 && dailyIncome > 0) SizedBox(width: 12),
          if (dailyIncome > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward,
                  size: 14,
                  color: Colors.green,
                ),
                SizedBox(width: 2),
                Text(
                  dailyIncome.toStringAsFixed(2),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDateHeader(String date) {
    final l10n = L10n.of(context);
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    if (date == today) {
      return l10n.today;
    } else if (date == yesterday) {
      return l10n.yesterday;
    }

    final dateTime = DateTime.parse(date);
    return l10n.monthDayFormat(
      dateTime.month.toString(),
      dateTime.day.toString(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        context.read<AccountItemListProvider>().hasMoreData
            ? L10n.of(context).loadingMore
            : L10n.of(context).noMoreData,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Future<void> _batchDelete(AccountItemListProvider provider) async {
    final l10n = L10n.of(context);

    if (provider.selectedItems.isEmpty) {
      MessageHelper.showError(
        context,
        message: l10n.pleaseSelectItems,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content:
            Text(l10n.confirmBatchDeleteMessage(provider.selectedItems.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.batchDelete();
        if (mounted) {
          MessageHelper.showSuccess(
            context,
            message: l10n.batchDeleteSuccess(provider.selectedItems.length),
          );
        }
      } catch (e) {
        if (mounted) {
          MessageHelper.showError(context, message: e.toString());
        }
      }
    }
  }

  Widget _buildListItem(AccountItem item, AccountItemListProvider provider) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            onPressed: (context) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(L10n.of(context).delete),
                  content: Text(L10n.of(context).confirmDeleteMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(L10n.of(context).cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(L10n.of(context).delete),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  await provider.deleteItem(item.id);
                  if (context.mounted) {
                    MessageHelper.showSuccess(
                      context,
                      message: L10n.of(context).deleteSuccess,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    MessageHelper.showError(context, message: e.toString());
                  }
                }
              }
            },
            foregroundColor: Theme.of(context).colorScheme.error,
            child: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      child: AccountItemTile(
        key: ValueKey(item.id),
        item: item,
        onTap: () => _editAccountItem(item),
        onLongPress: () => provider.enterBatchMode(item.id),
        showCheckbox: provider.isBatchMode,
        isChecked: provider.selectedItems.contains(item.id),
        onCheckChanged: (checked) => provider.toggleItemSelection(item.id),
      ),
    );
  }
}
