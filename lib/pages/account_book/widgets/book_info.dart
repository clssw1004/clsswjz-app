import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../utils/message_helper.dart';
import '../../../constants/book_icons.dart';
import '../../../widgets/icon_picker_dialog.dart';
import 'member_list.dart';

class BookInfo extends StatefulWidget {
  final Map<String, dynamic> accountBook;

  const BookInfo({
    Key? key,
    required this.accountBook,
  }) : super(key: key);

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _currencySymbol;
  late List<dynamic> _members;
  late IconData _selectedIcon;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.accountBook['name']);
    _descriptionController =
        TextEditingController(text: widget.accountBook['description']);
    _currencySymbol = widget.accountBook['currencySymbol'] ?? '¥';
    _members = List<dynamic>.from(widget.accountBook['members'] ?? []);
    _selectedIcon = _getBookIcon(widget.accountBook);
  }

  IconData _getBookIcon(Map<String, dynamic> book) {
    if (book == null) return BookIcons.defaultIcon;

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

  Future<void> _addMember() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddMemberDialog(),
    );

    if (result != null) {
      setState(() {
        _members = [
          ..._members,
          {
            'userId': result['userId'],
            'nickname': result['nickname'],
            'canViewBook': false,
            'canEditBook': false,
            'canDeleteBook': false,
            'canViewItem': false,
            'canEditItem': false,
            'canDeleteItem': false,
          }
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('账本详情'),
        actions: [
          if (_isSaving)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
              tooltip: '保存',
              onPressed: _saveChanges,
            ),
        ],
      ),
      body: ListView(
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
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '账本名称',
                      labelStyle: TextStyle(color: colorScheme.primary),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: '账本描述',
                      labelStyle: TextStyle(color: colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _currencySymbol,
                    decoration: InputDecoration(
                      labelText: '币种',
                      labelStyle: TextStyle(color: colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['¥', '\$', '€', '£'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _currencySymbol = val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '成员管理',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          MemberList(
            members: _members,
            createdBy: widget.accountBook['createdBy'],
            isEditing: true,
            onMembersChanged: (members) {
              setState(() => _members = members);
            },
            onAddMember: _addMember,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class AddMemberDialog extends StatefulWidget {
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _inviteCodeController = TextEditingController();
  Map<String, dynamic>? _searchResult;
  bool _isSearching = false;

  Future<void> _searchUserByCode() async {
    final code = _inviteCodeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final user = await ApiService.getUserByInviteCode(context, code);
      setState(() => _searchResult = user);
    } catch (e) {
      // ApiErrorHandler 已经处理了错误提示
      setState(() => _searchResult = null);
    } finally {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        '添加成员',
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _inviteCodeController,
            decoration: InputDecoration(
              labelText: '邀请码',
              hintText: '请输入用户邀请码',
              prefixIcon: Icon(Icons.key),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _searchUserByCode,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSubmitted: (_) => _searchUserByCode(),
          ),
          if (_isSearching)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
          if (_searchResult != null) ...[
            SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  _searchResult!['nickname'][0].toUpperCase(),
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
              ),
              title: Text(_searchResult!['nickname']),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outline),
                color: colorScheme.primary,
                onPressed: () => Navigator.pop(context, {
                  'userId': _searchResult!['id'],
                  'nickname': _searchResult!['nickname'],
                }),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }
}
