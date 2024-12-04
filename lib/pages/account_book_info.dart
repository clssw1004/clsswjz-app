import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/book_icons.dart';
import '../widgets/icon_picker_dialog.dart';
import './account_book/widgets/member_list.dart';
import '../widgets/app_bar_factory.dart';
import '../services/user_service.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class AccountBookInfo extends StatefulWidget {
  final Map<String, dynamic> accountBook;

  const AccountBookInfo({
    Key? key,
    required this.accountBook,
  }) : super(key: key);

  @override
  State<AccountBookInfo> createState() => _AccountBookInfoState();
}

class _AccountBookInfoState extends State<AccountBookInfo> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _currencySymbol;
  late List<Member> _members;
  late IconData _selectedIcon;
  bool _isSaving = false;
  bool _canEdit = false;
  String? _currentUserId;
  late AccountBook _accountBook;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _currentUserId = UserService.getUserInfo()?['userId'];
    _accountBook = AccountBook.fromJson(widget.accountBook);
    _canEdit = _checkEditPermission();

    _nameController = TextEditingController(text: _accountBook.name);
    _descriptionController =
        TextEditingController(text: _accountBook.description);
    _currencySymbol = _accountBook.currencySymbol;
    _members = _accountBook.members;
    _selectedIcon = _getBookIcon(_accountBook);
  }

  bool _checkEditPermission() {
    if (_currentUserId == null) return false;
    if (_accountBook.createdBy == _currentUserId) return true;
    return _accountBook.canEditBook;
  }

  IconData _getBookIcon(AccountBook book) {
    final String? iconString = book.icon?.toString();
    if (iconString == null || iconString.isEmpty) {
      return BookIcons.defaultIcon;
    }

    try {
      final int iconCode = int.parse(iconString);
      return IconData(
        iconCode,
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      debugPrint('解析图标代码失败: $e');
      return BookIcons.defaultIcon;
    }
  }

  Future<void> _showIconPicker() async {
    final IconData? selectedIcon = await showDialog<IconData>(
      context: context,
      builder: (context) => IconPickerDialog(
        selectedIcon: _selectedIcon,
        icons: BookIcons.icons,
      ),
    );

    if (selectedIcon != null) {
      setState(() => _selectedIcon = selectedIcon);
    }
  }

  Future<void> _saveChanges() async {
    try {
      final updatedBook = _accountBook.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        currencySymbol: _currencySymbol,
        icon: _selectedIcon.codePoint.toString(),
        members: _members,
      );

      final response = await ApiService.updateAccountBook(
        _accountBook.id,
        updatedBook,
      );

      if (!mounted) return;
      Navigator.pop(context, response.toJson());
      MessageHelper.showSuccess(context, message: '保存成功');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  void _handleMemberUpdate(List<Member> members) {
    setState(() => _members = members);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, '账本详情'),
        actions: _canEdit
            ? [
                if (_isSaving)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary),
                        ),
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.check),
                    tooltip: '保存',
                    onPressed: _saveChanges,
                  ),
              ]
            : null,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_canEdit)
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '账本名称',
                          labelStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          filled: false,
                          prefixIcon: InkWell(
                            onTap: _showIconPicker,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                _selectedIcon,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      )
                    else
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:
                            Icon(_selectedIcon, color: colorScheme.primary),
                        title: Text(
                          _accountBook.name ?? '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    SizedBox(height: 16),
                    if (_canEdit)
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: '账本描',
                          labelStyle: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          filled: false,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.outline.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        maxLines: 3,
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '账本描述',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _accountBook.description ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInfoItem(
                          context,
                          '创建者',
                          _accountBook.fromName ?? '未知',
                        ),
                        SizedBox(width: 24),
                        _buildInfoItem(
                          context,
                          '创建时间',
                          _accountBook.createdAt != null
                              ? DateFormat('yyyy-MM-dd HH:mm')
                                  .format(_accountBook.createdAt!)
                              : '未知',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_canEdit)
              MemberList(
                members: _members,
                createdBy: _accountBook.createdBy ?? '',
                onUpdate: _handleMemberUpdate,
                currentUserId: _currentUserId,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
