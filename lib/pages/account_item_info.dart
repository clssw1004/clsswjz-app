import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  String _transactionType = '支出';
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Map<String, dynamic>? _selectedFund;
  Map<String, dynamic>? _selectedBook;
  String? _recordId;
  String? _selectedShop;
  String? _selectedShopName;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _provider = AccountItemProvider(selectedBook: widget.initialBook);
    _selectedBook = widget.initialBook;

    // 设置初始交易类型
    _transactionType = widget.initialData?['type'] == 'EXPENSE' ? '支出' : '收入';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final l10n = L10n.of(context);

      // 设置provider中的账本并加载相关数据
      await _provider.setSelectedBook(widget.initialBook);
      if (widget.initialBook != null) {
        setState(() => _selectedBook = widget.initialBook);
        await _loadCategories();
        await _provider.loadData();

        // 如果是编辑模式，设置选中的账户
        if (widget.initialData != null &&
            widget.initialData!['fundId'] != null) {
          final fund = _provider.funds.firstWhere(
            (f) => f.id == widget.initialData!['fundId'],
            orElse: () => AccountBookFund(
              id: '',
              name: '未知账户',
              fundType: 'OTHER',
              fundRemark: '',
              fundBalance: 0,
              fundIn: true,
              fundOut: true,
              isDefault: false,
              accountBookName: '',
            ),
          );

          setState(() {
            _selectedFund = {
              'id': fund.id,
              'name': fund.name,
              'fundType': fund.fundType,
              'fundRemark': fund.fundRemark,
              'fundBalance': fund.fundBalance,
              'isDefault': fund.isDefault,
            };
          });
        }
      }

      // 设置初始数据
      if (widget.initialData != null) {
        setState(() {
          _recordId = widget.initialData!['id'];
          _transactionType = widget.initialData!['type'] == 'EXPENSE' ? '支出' : '收入';
          _provider.setTransactionType(_transactionType);  // 设置 provider 的交易类型
          _amountController.text = widget.initialData!['amount'].toString();
          _selectedCategory = widget.initialData!['category'];

          if (widget.initialData!['shop'] != null) {
            _selectedShop = widget.initialData!['shop'];
            _selectedShopName = widget.initialData!['shop'];
          }

          _descriptionController.text = widget.initialData!['description'] ?? '';

          // 设置日期时间
          if (widget.initialData!['accountDate'] != null) {
            final dateTime = DateTime.parse(widget.initialData!['accountDate']);
            _selectedDate = dateTime;
            _selectedTime = TimeOfDay.fromDateTime(dateTime);
          }
        });
      }
    });
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
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarFactory.buildAppBar(
              context: context,
              title: AppBarFactory.buildTitle(
                context,
                _recordId == null ? l10n.newRecordTitle : l10n.editRecordTitle,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // 账本头部
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                      ),
                    ),
                    child: BookHeader(book: _selectedBook),
                  ),
                  // 主要内容区域
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                              child: Column(
                                children: [
                                  TypeSelector(
                                    value: _transactionType,
                                    onChanged: (value) {
                                      setState(() => _transactionType = value);
                                      _provider.setTransactionType(value);
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  AmountInput(
                                    initialValue: widget.initialData != null
                                        ? double.parse(widget
                                            .initialData!['amount']
                                            .toString())
                                        : null,
                                    onChanged: (value) => _amountController
                                        .text = value.toString(),
                                    type: _transactionType,
                                    focusNode: _amountFocusNode,
                                    controller: _amountController,
                                  ),
                                  SizedBox(height: 12),
                                  CategorySelector(
                                    selectedCategory: _selectedCategory,
                                    onChanged: (category) => setState(
                                        () => _selectedCategory = category),
                                    isRequired: true,
                                  ),
                                  SizedBox(height: 12),
                                  DateTimeSelector(
                                    selectedDate: _selectedDate,
                                    selectedTime: _selectedTime,
                                    onDateChanged: (date) =>
                                        setState(() => _selectedDate = date),
                                    onTimeChanged: (time) =>
                                        setState(() => _selectedTime = time),
                                  ),
                                  SizedBox(height: 8),
                                  ShopSelector(
                                    selectedShop: _selectedShop,
                                    accountBookId: _selectedBook?['id'] ?? '',
                                    onTap: () {
                                      _amountFocusNode.unfocus();
                                    },
                                    onChanged: (shop) {
                                      setState(() {
                                        _selectedShopName = shop;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  _buildFundSelector(),
                                  SizedBox(height: 8),
                                  DescriptionInput(
                                    controller: _descriptionController,
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
                  // 底部按钮区域
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: FilledButton(
                      onPressed: () {
                        print(
                            'Form validation: ${_formKey.currentState?.validate()}');

                        if (_formKey.currentState?.validate() ?? false) {
                          final amount =
                              double.tryParse(_amountController.text) ?? 0.0;
                          _saveTransaction({
                            'amount': amount,
                            'description': _descriptionController.text.trim(),
                            'type': _transactionType == '支出' ? 'EXPENSE' : 'INCOME',
                            'category': _selectedCategory,
                            'accountDate': _formattedDateTime,
                            'fundId': _selectedFund?['id'],
                            'accountBookId': _selectedBook?['id'],
                            if (_recordId != null) 'id': _recordId,
                            'shop': _selectedShopName,
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
    setState(() => _isSaving = true);

    try {
      // 验证必填字段
      if (data['amount'] == 0.0) {
        MessageHelper.showError(context, message: l10n.pleaseInputAmount);
        return;
      }
      if (data['category'] == null) {
        MessageHelper.showError(context, message: l10n.pleaseSelectCategory);
        return;
      }
      if (data['fundId'] == null) {
        MessageHelper.showError(context, message: l10n.pleaseSelectAccount);
        return;
      }
      if (data['accountBookId'] == null) {
        MessageHelper.showError(context, message: l10n.pleaseSelectBook);
        return;
      }

      // 收起键盘
      FocusScope.of(context).unfocus();

      final type = _transactionType == '支出' ? 'EXPENSE' : 'INCOME';

      final accountItem = AccountItem(
        id: data['id'] ?? '',
        accountBookId: data['accountBookId'],
        type: type,
        amount: data['amount'],
        category: data['category'],
        description: data['description'],
        shop: data['shop'],
        fundId: _selectedFund?['id'],
        fundName: _selectedFund?['name'],
        accountDate: DateTime.parse(data['accountDate']),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (accountItem.id.isEmpty) {
        await ApiService.createAccountItem(accountItem);
      } else {
        await ApiService.updateAccountItem(accountItem.id, accountItem);
      }

      // 清除缓存
      AccountItemCache.clearCache();

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  final _amountFocusNode = FocusNode();

  Widget _buildFundSelector() {
    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        return FundSelector(
          selectedFund: _selectedFund,
          accountBookId: _selectedBook!['id'],
          onChanged: (fund) {
            setState(() => _selectedFund = fund);
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
