import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/book_icons.dart';
import '../widgets/icon_picker_dialog.dart';
import './account_book/widgets/member_list.dart';
import '../widgets/app_bar_factory.dart';
import '../services/user_service.dart';
import 'package:intl/intl.dart';

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
  late List<dynamic> _members;
  late IconData _selectedIcon;
  bool _isSaving = false;
  bool _canEdit = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = UserService.getUserInfo()?['userId'];
    _canEdit = _checkEditPermission();
    _nameController = TextEditingController(text: widget.accountBook['name']);
    _descriptionController =
        TextEditingController(text: widget.accountBook['description']);
    _currencySymbol = widget.accountBook['currencySymbol'] ?? '¥';
    _members = List<dynamic>.from(widget.accountBook['members'] ?? []);
    _selectedIcon = _getBookIcon(widget.accountBook);
  }

  bool _checkEditPermission() {
    if (_currentUserId == null) return false;

    if (widget.accountBook['createdBy'] == _currentUserId) return true;

    final member = (widget.accountBook['members'] as List?)?.firstWhere(
      (m) => m['userId'] == _currentUserId,
      orElse: () => null,
    );

    return member?['canEditBook'] == true;
  }

  IconData _getBookIcon(Map<String, dynamic> book) {
    final String? iconString = book['icon']?.toString();
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
    if (_nameController.text.isEmpty) {
      MessageHelper.showWarning(
        context,
        message: '账本名称不能为空',
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await ApiService.updateAccountBook(
        context,
        widget.accountBook['id'],
        {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'currencySymbol': _currencySymbol,
          'members': _members,
          'icon': _selectedIcon.codePoint.toString(),
        },
      );

      if (response['code'] == 0) {
        final updatedAccountBook = {
          ...widget.accountBook,
          'name': _nameController.text,
          'description': _descriptionController.text,
          'currencySymbol': _currencySymbol,
          'members': _members,
          'icon': _selectedIcon.codePoint.toString(),
          'updatedAt': DateTime.now().toString(),
        };

        MessageHelper.showSuccess(
          context,
          message: '保存成功',
        );

        Navigator.pop(context, updatedAccountBook);
      }
    } catch (e) {
      if (!mounted) return;
    } finally {
      setState(() => _isSaving = false);
    }
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
        title: '账本详情',
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
                          widget.accountBook['name'] ?? '',
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
                          labelText: '账本描述',
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
                            widget.accountBook['description'] ?? '',
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
                          widget.accountBook['fromName'] ?? '',
                        ),
                        SizedBox(width: 24),
                        _buildInfoItem(
                          context,
                          '创建时间',
                          DateFormat('yyyy-MM-dd HH:mm').format(
                              DateTime.parse(widget.accountBook['createdAt'])),
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
                createdBy: widget.accountBook['createdBy'],
                onUpdate: (members) {
                  setState(() => _members = members);
                },
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
