import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import './account_item/widgets/type_selector.dart';
import './account_item/widgets/amount_input.dart';
import './account_item/widgets/category_selector.dart';
import './account_item/widgets/datetime_selector.dart';
import './account_item/widgets/fund_selector.dart';
import './account_item/widgets/description_input.dart';
import './account_item/widgets/book_header.dart';
import './account_item/providers/account_item_provider.dart';
import 'package:intl/intl.dart';
import '../utils/message_helper.dart';
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
    _provider = AccountItemProvider();

    // 立即设置初始账本
    _selectedBook = widget.initialBook;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 设置provider中的账本并加载相关数据
      await _provider.setSelectedBook(context, widget.initialBook);
      if (widget.initialBook != null) {
        await _loadCategories();
        await _loadFundList();
      }

      // 设置初始数据
      if (widget.initialData != null) {
        setState(() {
          _recordId = widget.initialData!['id'];
          _transactionType =
              widget.initialData!['type'] == 'EXPENSE' ? '支出' : '收入';
          _provider.setTransactionType(_transactionType);
          _amountController.text = widget.initialData!['amount'].toString();
          _selectedCategory = widget.initialData!['category'];
          _selectedShop = widget.initialData!['shopCode'];
          _selectedShopName = widget.initialData!['shop'];
          _descriptionController.text =
              widget.initialData!['description'] ?? '';

          // 设置账户信息
          if (widget.initialData!['fundId'] != null) {
            _selectedFund = _provider.fundList.firstWhere(
              (fund) => fund['id'] == widget.initialData!['fundId'],
              orElse: () => <String, dynamic>{},
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
    final theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(_recordId == null ? '新增记录' : '编辑记录'),
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
                          color:
                              theme.colorScheme.outlineVariant.withOpacity(0.5),
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
                                      print('Selected shop changed: $shop');
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
                      color: theme.colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color:
                              theme.colorScheme.outlineVariant.withOpacity(0.1),
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
    await _provider.loadCategories(context, _selectedBook!['id']);
  }

  Future<void> _loadFundList() async {
    if (_selectedBook == null) return;
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    await provider.loadFundList(_selectedBook!['id']);
  }

  String get _formattedDateTime {
    final date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final time = _selectedTime.format(context).padLeft(5, '0');
    return '$date $time:00';
  }

  Future<void> _saveTransaction(Map<String, dynamic> data) async {
    print('Saving transaction with shop: $_selectedShop');
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

      // 修改保存数据的结构
      final saveData = {
        ...data,
        'shop': _selectedShopName,
      };

      await _provider.saveTransaction(context, saveData);
      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
      _selectedShop = null;
      _selectedFund = null; // 也重置账户选择
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    });
  }

  void _resetFormForContinue() {
    setState(() {
      _amountController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
      _selectedShop = null;
      _selectedFund = null;
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      // 不重置 _selectedBook 和 _transactionType
    });

    // 只在重置后立即聚焦一次，不保持焦点
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_amountFocusNode);
        // 聚焦后立即释放焦点，这样点击其他地方时不会再次聚焦
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            _amountFocusNode.unfocus();
          }
        });
      }
    });
  }

  final _amountFocusNode = FocusNode();
}
