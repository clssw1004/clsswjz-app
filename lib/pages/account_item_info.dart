import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  String _transactionType = '支出';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 设置provider中的账本并加载相关数据
      await _provider.setSelectedBook(widget.initialBook);
      if (widget.initialBook != null) {
        setState(() => _selectedBook = widget.initialBook);
        await _loadCategories();
        await _loadFundList();
      }

      // 设置初始数据
      if (widget.initialData != null) {
        print('Initial data: ${widget.initialData}');
        setState(() {
          _recordId = widget.initialData!['id'];
          _transactionType =
              widget.initialData!['type'] == 'EXPENSE' ? '支出' : '收入';
          _provider.setTransactionType(_transactionType);
          _amountController.text = widget.initialData!['amount'].toString();
          _selectedCategory = widget.initialData!['category'];

          // 修改商家信息的设置
          if (widget.initialData!['shop'] != null) {
            _selectedShop = widget.initialData!['shop']; // 使用 shop 而不是 shopCode
            _selectedShopName = widget.initialData!['shop'];
          }

          _descriptionController.text =
              widget.initialData!['description'] ?? '';

          // 设置账户信息
          if (widget.initialData!['fundId'] != null) {
            _selectedFund = _provider.fundList.firstWhere(
              (fund) => fund['id'] == widget.initialData!['fundId'],
              orElse: () => Map<String, Object>.from({
                'id': '',
                'name': '',
                'fundType': '',
                'fundRemark': '',
                'fundBalance': 0.0,
                'isDefault': false,
              }),
            );
          }

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
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBarFactory.buildAppBar(
              context: context,
              title: AppBarFactory.buildTitle(
                context,
                _recordId == null ? '记一笔' : '编辑记录',
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
                                  FundSelector(
                                    selectedFund: _selectedFund,
                                    accountBookId: _selectedBook?['id'] ?? '',
                                    onTap: () {
                                      _amountFocusNode.unfocus();
                                    },
                                    onChanged: (fund) =>
                                        setState(() => _selectedFund = fund),
                                    isRequired: true,
                                  ),
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
                        if (_formKey.currentState!.validate()) {
                          final amount =
                              double.tryParse(_amountController.text) ?? 0.0;
                          _saveTransaction({
                            'amount': amount,
                            'description': _descriptionController.text.trim(),
                            'type':
                                _transactionType == '支出' ? 'EXPENSE' : 'INCOME',
                            'category': _selectedCategory,
                            'accountDate': _formattedDateTime,
                            'fundId': _selectedFund?['id'],
                            'accountBookId': _selectedBook?['id'],
                            if (_recordId != null) 'id': _recordId,
                            'shop': _selectedShopName,
                          });
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
                          Text('保存'),
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
    await _provider.loadData();
  }

  Future<void> _loadFundList() async {
    if (_selectedBook == null) return;
    await _provider.loadData();
  }

  String get _formattedDateTime {
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final time = _selectedTime.format(context).padLeft(5, '0');
    return '$date $time:00';
  }

  Future<void> _saveTransaction(Map<String, dynamic> data) async {
    if (!mounted) return;
    try {
      // 验证必填字段
      if (data['amount'] == 0.0) {
        MessageHelper.showError(context, message: '请输入金额');
        return;
      }
      if (data['category'] == null) {
        MessageHelper.showError(context, message: '请选择分类');
        return;
      }
      if (data['fundId'] == null) {
        MessageHelper.showError(context, message: '请选择账户');
        return;
      }
      if (data['accountBookId'] == null) {
        MessageHelper.showError(context, message: '请选择账本');
        return;
      }

      // 收起键盘
      FocusScope.of(context).unfocus();

      final accountItem = AccountItem(
        id: data['id'] ?? '',
        accountBookId: data['accountBookId'],
        type: data['type'],
        amount: data['amount'],
        category: data['category'],
        description: data['description'],
        shop: data['shop'],
        fundId: data['fundId'],
        accountDate: DateTime.parse(data['accountDate']),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (accountItem.id.isEmpty) {
        await ApiService.createAccountItem(accountItem);
      } else {
        await ApiService.updateAccountItem(accountItem.id, accountItem);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
      MessageHelper.showSuccess(context, message: '保存成功');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  final _amountFocusNode = FocusNode();
}
