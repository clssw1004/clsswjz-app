import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../utils/message_helper.dart';
import '../../widgets/app_bar_factory.dart';
import 'package:intl/intl.dart';
import '../../constants/theme_constants.dart';
import '../../pages/settings/widgets/fund_book_list.dart';
import '../../pages/settings/widgets/fund_basic_info_card.dart';

class FundEditPage extends StatefulWidget {
  final UserFund fund;

  const FundEditPage({Key? key, required this.fund}) : super(key: key);

  @override
  State<FundEditPage> createState() => _FundEditPageState();
}

class _FundEditPageState extends State<FundEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _remarkController;
  late TextEditingController _balanceController;
  late String _selectedType;
  List<AccountBook> _availableBooks = [];
  List<FundBook> _selectedBooks = [];
  bool _isLoading = false;
  double _fundBalance = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fund.name);
    _remarkController = TextEditingController(text: widget.fund.fundRemark);
    _fundBalance = widget.fund.fundBalance;
    _balanceController = TextEditingController(
      text: _fundBalance.toStringAsFixed(2),
    );
    _selectedType = widget.fund.fundType;
    _selectedBooks = List.from(widget.fund.fundBooks);
    _loadAccountBooks();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _nameController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await ApiService.getAccountBooks();
      setState(() => _availableBooks = books);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  void _handleBalanceChanged(String value) {
    if (value.isEmpty) {
      setState(() => _fundBalance = 0);
      return;
    }

    try {
      final newBalance = double.parse(value);
      setState(() => _fundBalance = newBalance);
    } catch (e) {
      _balanceController.text = _fundBalance.toStringAsFixed(2);
    }
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty) {
      MessageHelper.showError(context, message: '请输入账户名称');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.fund.id.isEmpty) {
        // 新增账户
        final newFund = UserFund(
          id: '', // 空ID，由后端生成
          name: _nameController.text,
          fundType: _selectedType,
          fundRemark: _remarkController.text,
          fundBalance: _fundBalance,
          fundBooks: [], // 空列表，由后端处理账本关联
        );
        final result = await ApiService.createFund(newFund);
        if (!mounted) return;
        Navigator.pop(context, result);
      } else {
        // 更新账户
        final updatedFund = widget.fund.copyWith(
          name: _nameController.text,
          fundRemark: _remarkController.text,
          fundType: _selectedType,
          fundBalance: _fundBalance,
          fundBooks: _selectedBooks,
        );
        final result = await ApiService.updateFund(widget.fund.id, updatedFund);
        if (!mounted) return;
        Navigator.pop(context, result);
      }

      MessageHelper.showSuccess(context, message: '保存成功');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '未知';
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBarFactory.buildAppBar(
            context: context,
            title: AppBarFactory.buildTitle(
              context,
              widget.fund.id.isEmpty ? '新建账户' : '编辑账户',
            ),
            actions: [
              if (_isLoading)
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.padding),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _save,
                ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 600 : double.infinity,
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimens.paddingSmall,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingSmall),
                      child: FundBasicInfoCard(
                        nameController: _nameController,
                        remarkController: _remarkController,
                        balanceController: _balanceController,
                        selectedType: _selectedType,
                        onTypeChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        },
                        onBalanceChanged: _handleBalanceChanged,
                        showBalance: widget.fund.id.isNotEmpty,
                      ),
                    ),
                    if (widget.fund.id.isNotEmpty) ...[
                      SizedBox(height: AppDimens.padding),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '关联账本',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: AppDimens.paddingSmall),
                            _buildBookList(),
                          ],
                        ),
                      ),
                    ],
                    if (widget.fund.updatedAt != null) ...[
                      SizedBox(height: AppDimens.padding),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingSmall),
                        child: Text(
                          '最近更新：${_formatDate(widget.fund.updatedAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookList() {
    return FundBookList(
      books: _availableBooks,
      selectedBooks: _selectedBooks,
      onBookSettingsChanged: _updateBookSettings,
    );
  }

  void _updateBookSettings(FundBook updatedBook) {
    setState(() {
      final index = _selectedBooks.indexWhere(
        (fb) => fb.accountBookId == updatedBook.accountBookId,
      );
      if (index != -1) {
        _selectedBooks[index] = updatedBook;
      }
    });
  }
}
