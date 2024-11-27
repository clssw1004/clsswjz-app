import 'package:flutter/material.dart';
import 'package:clsswjz_app/services/api_service.dart'; // 导入ApiService
import 'package:intl/intl.dart'; // 添加日期格式化包

class AccountItemForm extends StatefulWidget {
  final Map<String, dynamic>? initialData; // 添加初始数据参数

  const AccountItemForm({Key? key, this.initialData}) : super(key: key);

  @override
  _AccountItemFormState createState() => _AccountItemFormState();
}

class _AccountItemFormState extends State<AccountItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _transactionType = '支出'; // 默认类型
  String? _selectedCategory;
  List<String> _categories = []; // 将从API获取分类
  
  // 添加日期时间相关变量
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  List<Map<String, dynamic>> _accountBooks = [];
  Map<String, dynamic>? _selectedBook;

  @override
  void initState() {
    super.initState();
    _loadAccountBooks();
    _fetchCategories();
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await ApiService.fetchAccountBooks();
      setState(() {
        _accountBooks = books;
        _selectedBook = books.isNotEmpty ? books.first : null;
      });
    } catch (e) {
      print('加载账本失败: $e');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('获取分类失败: $e');
    }
  }

  // 初始化表单数据
  void _initializeData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _amountController.text = data['amount'].toString();
      _descriptionController.text = data['description'] ?? '';
      _transactionType = data['type'] == 'EXPENSE' ? '支出' : '收入';
      _selectedCategory = data['category'];
      
      // 解析日期时间
      final dateTime = DateTime.parse(data['accountDate']);
      _selectedDate = dateTime;
      _selectedTime = TimeOfDay.fromDateTime(dateTime);
    }
  }

  // 选择日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 选择时间
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // 获取完整的日期时间字符串
  String get _formattedDateTime {
    final date = _selectedDate;
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime(
        date.year,
        date.month,
        date.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
    );
  }

  Future<void> _saveTransaction(Map<String, dynamic> data) async {
    try {
      await ApiService.saveAccountItem(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存成功')),
      );
      
      // 清空表单
      _amountController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay.now();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
    }
  }

  // 修改日期时间选择行的布局
  Widget _buildDateTimeSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          icon: Icon(Icons.calendar_today),
          label: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
          onPressed: () => _selectDate(context),
        ),
        SizedBox(height: 8),
        OutlinedButton.icon(
          icon: Icon(Icons.access_time),
          label: Text(_selectedTime.format(context)),
          onPressed: () => _selectTime(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _selectedBook?['currencySymbol'] ?? '¥';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData == null ? '记录新账目' : '编辑账目'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 账本选择
              DropdownButtonFormField<Map<String, dynamic>>(
                value: _selectedBook,
                decoration: InputDecoration(
                  labelText: '账本',
                  prefixIcon: Icon(Icons.book),
                ),
                items: _accountBooks.map((book) {
                  return DropdownMenuItem(
                    value: book,
                    child: Text(book['name']),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBook = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '请选择账本';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // 金额输入
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '金额',
                  prefixIcon: Icon(Icons.money),
                  prefixText: currencySymbol,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入金额';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // 交易类型选择
              Row(
                children: [
                  Text('类型：'),
                  Radio(
                    value: '支出',
                    groupValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value.toString();
                      });
                    },
                  ),
                  Text('支出'),
                  Radio(
                    value: '收入',
                    groupValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value.toString();
                      });
                    },
                  ),
                  Text('收入'),
                ],
              ),
              
              SizedBox(height: 16),
              
              // 分类选择
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: '分类',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请选择分类';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // 分类选择后添加日期时间选择
              _buildDateTimeSelectors(),
              
              SizedBox(height: 16),
              
              // 描述信息
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '描述',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              
              SizedBox(height: 24),
              
              // 提交按钮
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        'amount': double.parse(_amountController.text),
                        'description': _descriptionController.text,
                        'type': _transactionType == '支出' ? 'EXPENSE' : 'INCOME',
                        'category': _selectedCategory,
                        'accountBookId': _selectedBook?['id'],
                        'accountDate': _formattedDateTime,
                      };
                      _saveTransaction(data);
                    }
                  },
                  child: Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
