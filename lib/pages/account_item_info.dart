import 'package:flutter/material.dart';
import '../services/api_service.dart'; // 导入ApiService
import 'package:intl/intl.dart'; // 添加日期格式化包
import '../services/data_service.dart'; // 导入DataService

class AccountItemForm extends StatefulWidget {
  final Map<String, dynamic>? initialData; // 添加初始数据参数
  final Map<String, dynamic>? initialBook; // 新增参数

  const AccountItemForm({Key? key, this.initialData, this.initialBook})
      : super(key: key);

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
  String? _recordId; // 添加记录ID字段

  final _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadAccountBooks().then((_) {
      if (widget.initialBook != null) {
        // 如果有初始账本，直接使用
        setState(() {
          _selectedBook = widget.initialBook;
        });
      }
      _initializeData(); // 在加载完账本后初始化数据
      _loadCategories(); // 在初始化数据后加载分类
    });
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await _dataService.fetchAccountBooks();
      setState(() {
        _accountBooks = books;
        if (_selectedBook == null) {
          _selectedBook = widget.initialBook ??
              (widget.initialData != null
                  ? books.firstWhere(
                      (book) =>
                          book['id'] == widget.initialData!['accountBookId'],
                      orElse: () => books.first,
                    )
                  : books.first);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账本失败: $e')),
      );
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _dataService.fetchCategories(
        _selectedBook!['id'],
        forceRefresh: true,
      );
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取分类失败: $e')),
      );
    }
  }

  // 在账本选择改变时也需要重新加载分类
  void _onBookChanged(Map<String, dynamic>? newBook) {
    setState(() {
      _selectedBook = newBook;
      _selectedCategory = null; // 清空已选分类
      _categories = []; // 清空分类列表
    });
    _loadCategories(); // 重新加载分类
  }

  // 初始化表单数据
  void _initializeData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _amountController.text = data['amount'].toString();
      _descriptionController.text = data['description'] ?? '';
      _transactionType = data['type'] == 'EXPENSE' ? '支出' : '收入';
      _selectedCategory = data['category'];
      _recordId = data['id'];

      // 设置账本
      final bookId = data['accountBookId'];
      _selectedBook = _accountBooks.firstWhere(
        (book) => book['id'] == bookId,
        orElse: () => _accountBooks.first,
      );

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
    if (_selectedDate == null && _selectedTime == null) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    }
    final date = _selectedDate ?? DateTime.now();
    final time = _selectedTime ?? TimeOfDay.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _saveTransaction(Map<String, dynamic> data) async {
    try {
      // 添加账本ID到请求数据中
      data['accountBookId'] = _selectedBook!['id'];

      // 等待保存操作完成
      await ApiService.saveAccountItem(
        data,
        id: _recordId,
      );


      // 返回上一页，并传递刷新标记
      Navigator.pop(context, true);
    } catch (e) {
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_recordId == null ? '保存' : '更新'}失败: $e')),
      );
    }
  }

  // 修改日期时间选择器的布局
  Widget _buildDateTimeSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '时间',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () => _selectDate(context),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(Icons.access_time),
                label: Text(
                  _selectedTime.format(context),
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () => _selectTime(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 添加保存并继续的方法
  Future<void> _saveAndContinue() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'amount': double.parse(_amountController.text),
        'description': _descriptionController.text,
        'type': _transactionType == '支出' ? 'EXPENSE' : 'INCOME',
        'category': _selectedCategory,
        'accountDate': _formattedDateTime,
      };
      
      try {
        data['accountBookId'] = _selectedBook!['id'];
        await ApiService.saveAccountItem(data);
        
        // 显示成功提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存成功，请继续记录'),
            duration: Duration(seconds: 1),
          ),
        );

        // 重新加载页面
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AccountItemForm(
              initialBook: _selectedBook,
            ),
          ),
        );
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    }
  }

  // 类型选择组件
  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _transactionType = '支出'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _transactionType == '支出' 
                  ? Colors.red[400] 
                  : Colors.grey[100],
              foregroundColor: _transactionType == '支出' 
                  ? Colors.white 
                  : Colors.grey[600],
              elevation: _transactionType == '支出' ? 2 : 0,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '支出',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _transactionType = '收入'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _transactionType == '收入' 
                  ? Colors.green[400] 
                  : Colors.grey[100],
              foregroundColor: _transactionType == '收入' 
                  ? Colors.white 
                  : Colors.grey[600],
              elevation: _transactionType == '收入' ? 2 : 0,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '收入',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // 金额输入组件
  Widget _buildAmountInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedBook?['currencySymbol'] ?? '¥',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey[400]),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return '请输入金额';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // 分类选择组件
  Widget _buildCategorySelector() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final spacing = 8.0;
    final itemsPerRow = 4;
    final itemWidth = (screenWidth - (padding * 2) - (spacing * (itemsPerRow - 1))) / itemsPerRow;
    
    // 计算最大显示按钮数（不包括"全部"按钮）
    final maxButtons = itemsPerRow * 3;
    final showAllButton = _categories.length > maxButtons;
    final displayCategories = showAllButton 
        ? _categories.take(maxButtons - 1).toList()
        : _categories;

    List<Widget> categoryButtons = displayCategories.map((category) {
      return SizedBox(
        width: itemWidth,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () => setState(() => _selectedCategory = category),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedCategory == category 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[100],
              foregroundColor: _selectedCategory == category 
                  ? Colors.white 
                  : Colors.grey[700],
              elevation: _selectedCategory == category ? 2 : 0,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      );
    }).toList();

    // 添加"全部"按钮
    if (showAllButton) {
      categoryButtons.add(
        SizedBox(
          width: itemWidth,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: _showCategoryDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.grey[700],
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '全部',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.start,
      children: categoryButtons,
    );
  }

  // 分类选择弹窗
  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final searchController = TextEditingController();
        List<String> filteredCategories = _categories;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('分类'),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: '搜索分类',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredCategories = _categories.where((category) =>
                            category.toLowerCase().contains(value.toLowerCase())
                          ).toList();
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredCategories[index]),
                            onTap: () {
                              setState(() {
                                _selectedCategory = filteredCategories[index];
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _selectedBook?['currencySymbol'] ?? '¥';
    final isEditing = widget.initialData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑账目' : '记录新账目'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 账本信息提示
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.book, color: Colors.grey.shade700),
                      SizedBox(width: 8),
                      Text(
                        '当前账本：${_selectedBook?['name'] ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16), // 缩小间距

                // 类型选择
                _buildTypeSelector(),

                SizedBox(height: 16), // 缩小间距

                // 金额输入
                _buildAmountInput(),

                SizedBox(height: 16), // 缩小间距

                // 分类选择
                _buildCategorySelector(),

                SizedBox(height: 16), // 缩小间距

                // 日期时间选择
                _buildDateTimeSelectors(),

                SizedBox(height: 16), // 缩小间距

                // 描述信息
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '描述',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '添加描述信息（选填）',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),

                SizedBox(height: 24), // 按钮区域保持较大间距

                // 修改按钮区域的布局
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
                              'type': _transactionType == '支出'
                                  ? 'EXPENSE'
                                  : 'INCOME',
                              'category': _selectedCategory,
                              'accountDate': _formattedDateTime,
                            };
                            if (_recordId != null) {
                              data['id'] = _recordId;
                            }
                            _saveTransaction(data);
                          }
                        },
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          '保存',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                          size: 18,
                        ),
                        label: Text(
                          '再记一笔',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          minimumSize: Size(60, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
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
