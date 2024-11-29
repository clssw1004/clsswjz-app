import 'package:flutter/material.dart';
import '../services/api_service.dart'; // 导入ApiService
import 'package:intl/intl.dart'; // 添加日期格式化包
import '../services/data_service.dart'; // 导入DataService
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

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

  // 添加一个变量来存储显示在前三行的分类
  List<String> _displayCategories = [];

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
        _selectedBook ??= widget.initialBook ??
              (widget.initialData != null
                  ? books.firstWhere(
                      (book) =>
                          book['id'] == widget.initialData!['accountBookId'],
                      orElse: () => books.first,
                    )
                  : books.first);
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
        _updateDisplayCategories();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取分类失败: $e')),
      );
    }
  }

  void _updateDisplayCategories() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0;
    final spacing = 8.0;
    final itemsPerRow = 4;
    final maxButtons = itemsPerRow * 3;
    
    if (_categories.length <= maxButtons) {
      _displayCategories = List.from(_categories);
    } else {
      // 如果选中的分类不在前几个，则将其放在倒数第二个位置
      if (_selectedCategory != null && 
          !_categories.take(maxButtons - 1).contains(_selectedCategory)) {
        final initialCategories = _categories.take(maxButtons - 2).toList();
        initialCategories.add(_selectedCategory!);
        _displayCategories = initialCategories;
      } else {
        _displayCategories = _categories.take(maxButtons - 1).toList();
      }
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
    final themeColor = Provider.of<ThemeProvider>(context, listen: false).themeColor;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColor,  // 设置主题色
              onPrimary: Colors.white,  // 主题色上的文字颜色
              surface: Colors.white,
              onSurface: Colors.grey[800]!,  // 日期文字颜色
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeColor,  // 按钮文字颜色
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 选择时间
  Future<void> _selectTime(BuildContext context) async {
    final themeColor = Provider.of<ThemeProvider>(context, listen: false).themeColor;
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColor,  // 设置主题色
              onPrimary: Colors.white,  // 主题色上的文字颜色
              surface: Colors.white,
              onSurface: Colors.grey[800]!,  // 时间文字颜色
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeColor,  // 按钮文字颜色
              ),
            ),
          ),
          child: child!,
        );
      },
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

  // 修改日期时间选择器的样式
  Widget _buildDateTimeSelectors(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],  // 浅色背景
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.calendar_today,
                color: themeColor,
                size: 18,
              ),
              label: Text(
                DateFormat('yyyy年MM月dd日').format(_selectedDate),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Colors.grey[300]!),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _selectDate(context),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.access_time,
                color: themeColor,
                size: 18,
              ),
              label: Text(
                _selectedTime.format(context),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Colors.grey[300]!),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _selectTime(context),
            ),
          ),
        ],
      ),
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
  Widget _buildTypeSelector(Color themeColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _transactionType = '支出'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _transactionType == '支出' 
                  ? themeColor.withOpacity(0.9)  // 选中时使用主题色，稍微降低透明度
                  : Colors.grey[100],
              foregroundColor: _transactionType == '支出' 
                  ? Colors.white 
                  : Colors.grey[800],  // 未选中时使用深灰色
              elevation: _transactionType == '支出' ? 1 : 0,  // 降低阴影
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('支出', style: TextStyle(fontSize: 16)),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _transactionType = '收入'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _transactionType == '收入' 
                  ? themeColor.withOpacity(0.9)
                  : Colors.grey[100],
              foregroundColor: _transactionType == '收入' 
                  ? Colors.white 
                  : Colors.grey[800],
              elevation: _transactionType == '收入' ? 1 : 0,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('收入', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // 金额输入组件
  Widget _buildAmountInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
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
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],  // 更深的颜色提高可读性
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 28,
                ),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final themeColor = themeProvider.themeColor;
        
        final screenWidth = MediaQuery.of(context).size.width;
        final padding = 16.0;
        final spacing = 8.0;
        final itemsPerRow = 4;
        final itemWidth = (screenWidth - (padding * 2) - (spacing * (itemsPerRow - 1))) / itemsPerRow;
        
        final maxButtons = itemsPerRow * 3;
        final showAllButton = _categories.length > maxButtons;

        List<Widget> categoryButtons = _displayCategories.map((category) {
          final isSelected = _selectedCategory == category;
          return SizedBox(
            width: itemWidth,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: () => setState(() => _selectedCategory = category),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected 
                      ? themeColor.withOpacity(0.9)
                      : Colors.grey[100],
                  foregroundColor: isSelected 
                      ? Colors.white 
                      : themeColor,
                  elevation: isSelected ? 1 : 0,
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

        // "全部"按钮样式
        if (showAllButton) {
          categoryButtons.add(
            SizedBox(
              width: itemWidth,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: OutlinedButton(  // 改用 OutlinedButton
                  onPressed: _showCategoryDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: themeColor,
                    side: BorderSide(color: themeColor.withOpacity(0.5)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('全部', style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: categoryButtons,
        );
      },
    );
  }

  // 分类选择弹窗
  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final searchController = TextEditingController();
        List<String> filteredCategories = List.from(_categories);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('分类'),
              content: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(maxHeight: 400),
                child: Column(
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
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return ListTile(
                            title: Text(category),
                            selected: _selectedCategory == category,
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedCategory = category;
                                _updateDisplayCategories();
                              });
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

  // 添加账本名称提示组件
  Widget _buildBookNameHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.book_outlined,
            size: 20,
            color: Colors.grey[700],
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedBook?['name'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
                  // 添加账本名称提示
                  _buildBookNameHeader(),
                  // 类型选择
                  _buildTypeSelector(themeColor),
                  SizedBox(height: 16),
                  // 金额输入
                  _buildAmountInput(),
                  SizedBox(height: 16),
                  // 分类选择 - 移到金额输入后面
                  _buildCategorySelector(),
                  SizedBox(height: 16),
                  // 日期时间选择 - 移到分类选择后面
                  _buildDateTimeSelectors(themeColor),
                  SizedBox(height: 16),
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
                  SizedBox(height: 24),
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
                            backgroundColor: themeColor,
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
                            color: themeColor,
                            size: 18,
                          ),
                          label: Text(
                            '再记一笔',
                            style: TextStyle(
                              color: themeColor,
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
                              color: themeColor,
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
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
