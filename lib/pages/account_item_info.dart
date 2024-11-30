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

  @override
  void initState() {
    super.initState();
    _provider = AccountItemProvider();
    
    // 立即设置初始账本
    _selectedBook = widget.initialBook;
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      
      // 设置provider中的账本并加载相关数据
      await _provider.setSelectedBook(widget.initialBook);
      if (widget.initialBook != null) {
        await _loadCategories();
        await _loadFundList();
      }
      
      // 设置初始数据
      if (widget.initialData != null) {
        setState(() {
          _recordId = widget.initialData!['id'];
          _transactionType = widget.initialData!['type'] == 'EXPENSE' ? '支出' : '收入';
          _provider.setTransactionType(_transactionType);
          _amountController.text = widget.initialData!['amount'].toString();
          _selectedCategory = widget.initialData!['category'];  // 设置分类
          _descriptionController.text = widget.initialData!['description'] ?? '';
          
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
    _provider.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final themeColor = themeProvider.themeColor;
          return Scaffold(
            appBar: AppBar(
              title: Text(_recordId == null ? '新增记录' : '编辑记录'),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 账本头部
                    BookHeader(book: _selectedBook),
                    
                    // 类型选择器
                    TypeSelector(
                      value: _transactionType,
                      onChanged: (value) {
                        setState(() => _transactionType = value);
                        _provider.setTransactionType(value);
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // 金额输入
                    AmountInput(
                      initialValue: widget.initialData != null 
                          ? double.parse(widget.initialData!['amount'].toString())
                          : null,
                      onChanged: (value) => _amountController.text = value.toString(),
                    ),
                    SizedBox(height: 16),
                    
                    // 分类选择器
                    CategorySelector(
                      selectedCategory: _selectedCategory,
                      onChanged: (category) => setState(() => _selectedCategory = category),
                    ),
                    SizedBox(height: 16),
                    
                    // 日期时间选择器
                    DateTimeSelector(
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                      onDateChanged: (date) => setState(() => _selectedDate = date),
                      onTimeChanged: (time) => setState(() => _selectedTime = time),
                    ),
                    SizedBox(height: 16),
                    
                    // 账户选择器
                    FundSelector(
                      selectedFund: _selectedFund,
                      onChanged: (fund) => setState(() => _selectedFund = fund),
                    ),
                    
                    // 描述输入
                    DescriptionInput(
                      controller: _descriptionController,
                    ),
                    SizedBox(height: 24),
                    
                    // 按钮区域
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final data = {
                                  'amount': double.parse(_amountController.text),
                                  'description': _descriptionController.text,
                                  'type': _transactionType == '支出' ? 'EXPENSE' : 'INCOME',
                                  'category': _selectedCategory,
                                  'accountDate': _formattedDateTime,
                                  'fundId': _selectedFund?['id'],
                                  'accountBookId': _selectedBook?['id'],
                                };
                                if (_recordId != null) {
                                  data['id'] = _recordId;
                                }
                                _saveTransaction(data);
                              }
                            },
                            icon: Icon(Icons.save_outlined, color: Colors.white, size: 18),
                            label: Text(
                              '保存',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              minimumSize: Size(60, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: OutlinedButton.icon(
                            onPressed: _saveAndContinue,
                            icon: Icon(Icons.add_circle_outline, color: themeColor, size: 18),
                            label: Text(
                              '再记一笔',
                              style: TextStyle(color: themeColor, fontSize: 14),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              minimumSize: Size(60, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: themeColor),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadCategories() async {
    if (_selectedBook == null) return;
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    await provider.loadCategories(_selectedBook!['id']);
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
    if (!mounted) return;
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    try {
      await provider.saveTransaction(data);
      if (!mounted) return;
      // 返回 true 表示数据已更新，需要刷新列表
      Navigator.pop(context, true);
    } catch (e) {
      // 处理错误情况
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败：${e.toString()}')),
      );
    }
  }

  Future<void> _saveAndContinue() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'amount': double.parse(_amountController.text),
        'description': _descriptionController.text,
        'type': _transactionType == '支出' ? 'EXPENSE' : 'INCOME',
        'category': _selectedCategory,
        'accountDate': _formattedDateTime,
        'fundId': _selectedFund?['id'],
        'accountBookId': _selectedBook?['id'],
      };
      try {
        await _saveTransaction(data);
        _resetForm();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败：${e.toString()}')),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    });
  }
}
