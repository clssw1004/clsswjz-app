import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/app_localizations.dart';
import '../services/account_item_cache.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import '../utils/message_helper.dart';
import './account_item/widgets/type_selector.dart';
import './account_item/widgets/amount_input.dart';
import './account_item/widgets/category_selector.dart';
import './account_item/widgets/datetime_selector.dart';
import './account_item/widgets/fund_selector.dart';
import './account_item/widgets/description_input.dart';
import './account_item/widgets/book_header.dart';
import './account_item/providers/account_item_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_bar_factory.dart';
import './account_item/widgets/shop_selector.dart';
import '../l10n/l10n.dart';
import './account_item/widgets/category_grid_selector.dart';

class AccountItemForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Map<String, dynamic>? initialBook;

  const AccountItemForm({
    Key? key,
    this.initialData,
    this.initialBook,
  }) : super(key: key);

  @override
  State<AccountItemForm> createState() => _AccountItemFormState();
}

class _AccountItemFormState extends State<AccountItemForm> {
  late final AccountItemProvider _provider;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Category> _categories = [];

  static const TYPE_EXPENSE = 'EXPENSE';
  static const TYPE_INCOME = 'INCOME';

  late String _transactionType;

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Map<String, dynamic>? _selectedFund;
  Map<String, dynamic>? _selectedBook;
  String? _recordId;
  String? _selectedShop;
  String? _selectedShopName;

  @override
  void initState() {
    super.initState();
    _provider = AccountItemProvider(selectedBook: widget.initialBook);
    _selectedBook = widget.initialBook;

    if (widget.initialData != null) {
      _transactionType = widget.initialData!['type'] == TYPE_EXPENSE
          ? TYPE_EXPENSE
          : TYPE_INCOME;
    } else {
      _transactionType = TYPE_EXPENSE;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedFund ??= FundSelector.getNoFundOption(L10n.of(context));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final l10n = L10n.of(context);

      await _provider.loadData();

      if (widget.initialData != null) {
        setState(() {
          _recordId = widget.initialData!['id'];
          _transactionType = widget.initialData!['type'] == TYPE_EXPENSE
              ? TYPE_EXPENSE
              : TYPE_INCOME;
          _provider
              .setTransactionType(_getLocalizedType(l10n, _transactionType));
          _amountController.text = widget.initialData!['amount'].toString();
          _selectedCategory = widget.initialData!['category'];

          if (widget.initialData!['fundId'] != null) {
            if (widget.initialData!['fundId'] == FundSelector.NO_FUND) {
              _selectedFund = FundSelector.getNoFundOption(l10n);
            } else {
              final fund = _provider.funds.firstWhere(
                (f) => f.id == widget.initialData!['fundId'],
                orElse: () => AccountBookFund(
                  id: FundSelector.NO_FUND,
                  name: l10n.noFund,
                  fundType: 'NONE',
                  fundRemark: '',
                  fundBalance: 0,
                  fundIn: true,
                  fundOut: true,
                  isDefault: false,
                  accountBookName: '',
                ),
              );

              _selectedFund = {
                'id': fund.id,
                'name': fund.name,
                'fundType': fund.fundType,
                'fundRemark': fund.fundRemark,
                'fundBalance': fund.fundBalance,
                'isDefault': fund.isDefault,
              };
            }
          }

          if (widget.initialData!['shop'] != null) {
            _selectedShop = widget.initialData!['shop'];
            _selectedShopName = widget.initialData!['shop'];
          } else {
            _selectedShop = ShopSelector.NO_SHOP;
            _selectedShopName = l10n.noShop;
          }

          _descriptionController.text =
              widget.initialData!['description'] ?? '';

          if (widget.initialData!['accountDate'] != null) {
            final dateTime = DateTime.parse(widget.initialData!['accountDate']);
            _selectedDate = dateTime;
            _selectedTime = TimeOfDay.fromDateTime(dateTime);
          }
        });
      } else {
        setState(() {
          _selectedShop = ShopSelector.NO_SHOP;
          _selectedShopName = l10n.noShop;
        });
      }
    });
  }

  String _getLocalizedType(AppLocalizations l10n, String type) {
    return type == TYPE_EXPENSE ? l10n.expense : l10n.income;
  }

  String _getTypeValue(String localizedType, AppLocalizations l10n) {
    return localizedType == l10n.expense ? TYPE_EXPENSE : TYPE_INCOME;
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _provider.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          return Consumer<AccountItemProvider>(
            builder: (context, provider, child) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBarFactory.buildAppBar(
                  context: context,
                  title: AppBarFactory.buildTitle(
                    context,
                    _recordId == null
                        ? l10n.newRecordTitle
                        : l10n.editRecordTitle,
                  ),
                ),
                body: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SafeArea(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                              child: BookHeader(book: _selectedBook),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 12, 16, 16),
                                        child: Column(
                                          children: [
                                            TypeSelector(
                                              value: _getLocalizedType(
                                                  l10n, _transactionType),
                                              onChanged: (value) {
                                                setState(() {
                                                  _transactionType =
                                                      _getTypeValue(
                                                          value, l10n);
                                                });
                                                _provider
                                                    .setTransactionType(value);
                                              },
                                            ),
                                            SizedBox(height: 12),
                                            AmountInput(
                                              initialValue: widget
                                                          .initialData !=
                                                      null
                                                  ? double.parse(widget
                                                      .initialData!['amount']
                                                      .toString())
                                                  : null,
                                              onChanged: (value) =>
                                                  _amountController.text =
                                                      value.toString(),
                                              type: _getLocalizedType(
                                                  l10n, _transactionType),
                                              focusNode: _amountFocusNode,
                                              controller: _amountController,
                                            ),
                                            SizedBox(height: 12),
                                            CategoryGridSelector(
                                              selectedCategory:
                                                  _selectedCategory,
                                              onChanged: (category) => setState(
                                                  () => _selectedCategory =
                                                      category),
                                              isRequired: true,
                                            ),
                                            SizedBox(height: 12),
                                            DateTimeSelector(
                                              selectedDate: _selectedDate,
                                              selectedTime: _selectedTime,
                                              onDateChanged: (date) => setState(
                                                  () => _selectedDate = date),
                                              onTimeChanged: (time) => setState(
                                                  () => _selectedTime = time),
                                            ),
                                            SizedBox(height: 8),
                                            ShopSelector(
                                              selectedShop: _selectedShop,
                                              selectedShopName:
                                                  _selectedShopName,
                                              accountBookId:
                                                  _selectedBook?['id'] ?? '',
                                              onTap: () {
                                                _amountFocusNode.unfocus();
                                              },
                                              onChanged: (shop) {
                                                setState(() {
                                                  _selectedShop = shop ??
                                                      ShopSelector.NO_SHOP;
                                                  _selectedShopName = shop;
                                                });
                                              },
                                            ),
                                            SizedBox(height: 8),
                                            _buildFundSelector(),
                                            SizedBox(height: 8),
                                            DescriptionInput(
                                              controller:
                                                  _descriptionController,
                                            ),
                                            SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                border: Border(
                                  top: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.1),
                                  ),
                                ),
                              ),
                              child: FilledButton(
                                onPressed: () {
                                  print(
                                      'Form validation: ${_formKey.currentState?.validate()}');

                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final amount = double.tryParse(
                                            _amountController.text) ??
                                        0.0;
                                    _saveTransaction({
                                      'amount': amount,
                                      'description':
                                          _descriptionController.text.trim(),
                                      'type': _transactionType,
                                      'category': _selectedCategory,
                                      'accountDate': _formattedDateTime,
                                      'fundId': _selectedFund?['id'],
                                      'accountBookId': _selectedBook?['id'],
                                      if (_recordId != null) 'id': _recordId,
                                      'shop':
                                          _selectedShop == ShopSelector.NO_SHOP
                                              ? ShopSelector.NO_SHOP
                                              : _selectedShopName,
                                    });
                                  } else {
                                    print('Form validation failed');
                                    print('Amount: ${_amountController.text}');
                                    print('Category: $_selectedCategory');
                                    print('Fund: $_selectedFund');
                                    print('Book: $_selectedBook');
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_outlined, size: 18),
                                    SizedBox(width: 8),
                                    Text(l10n.saveRecord),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _loadCategories() async {
    if (_selectedBook == null) return;
    try {
      final categories = await ApiService.getCategories(_selectedBook!['id']);
      if (!mounted) return;
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('加载分类失败: $e');
    }
  }

  String get _formattedDateTime {
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final time =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';
    return '$date $time';
  }

  Future<void> _saveTransaction(Map<String, dynamic> data) async {
    final l10n = L10n.of(context);
    if (!mounted) return;

    try {
      _provider.isLoading = true;

      if (data['amount'] == 0.0) {
        MessageHelper.showError(context, message: l10n.pleaseInputAmount);
        return;
      }
      if (data['category'] == null) {
        MessageHelper.showError(context, message: l10n.pleaseSelectCategory);
        return;
      }
      if (data['accountBookId'] == null) {
        MessageHelper.showError(context, message: l10n.pleaseSelectBook);
        return;
      }

      FocusScope.of(context).unfocus();

      final type = _transactionType;
      final fundId = _selectedFund?['id'] ?? FundSelector.NO_FUND;
      final fundName = _selectedFund?['id'] == FundSelector.NO_FUND
          ? null
          : _selectedFund?['name'];

      final accountItem = AccountItem(
        id: data['id'] ?? '',
        accountBookId: data['accountBookId'],
        type: type,
        amount: data['amount'],
        category: data['category'],
        description: data['description'],
        shop: data['shop'],
        fundId: fundId,
        fundName: fundName,
        accountDate: DateTime.parse(data['accountDate']),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (accountItem.id.isEmpty) {
        await ApiService.createAccountItem(accountItem);
      } else {
        await ApiService.updateAccountItem(accountItem.id, accountItem);
      }

      AccountItemCache.clearCache();

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    } finally {
      if (mounted) {
        _provider.isLoading = false;
      }
    }
  }

  final _amountFocusNode = FocusNode();

  Widget _buildFundSelector() {
    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        if (_selectedBook == null) return SizedBox.shrink();

        return FundSelector(
          selectedFund: _selectedFund,
          accountBookId: _selectedBook!['id'],
          onChanged: (fund) {
            setState(() {
              _selectedFund = fund;
            });
          },
          onTap: () {
            _amountFocusNode.unfocus();
          },
          isRequired: true,
        );
      },
    );
  }
}
