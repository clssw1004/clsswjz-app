import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'account_book/widgets/member_list.dart';

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
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.accountBook['name']);
    _descriptionController =
        TextEditingController(text: widget.accountBook['description']);
    _currencySymbol = widget.accountBook['currencySymbol'] ?? '¥';
    _members = List<dynamic>.from(widget.accountBook['members'] ?? []);
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('账本名称不能为空')),
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
        },
      );

      if (response['code'] == 0) {
        final updatedAccountBook = {
          ...widget.accountBook,
          'name': _nameController.text,
          'description': _descriptionController.text,
          'currencySymbol': _currencySymbol,
          'members': _members,
          'updatedAt': DateTime.now().toString(),
        };

        setState(() => _isEditing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存成功')),
        );

        Navigator.pop(context, updatedAccountBook);
      } else {
        throw Exception(response['message']);
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

    return PopScope(
      canPop: !_isEditing,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('放弃更改？'),
              content: Text('您有未保存的更改，确定要放弃吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    Navigator.pop(context, widget.accountBook);
                  },
                  child: Text('放弃'),
                ),
              ],
            ),
          );
          if (shouldPop ?? false) {
            Navigator.pop(context, widget.accountBook);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('账本详情'),
          actions: [
            if (!_isEditing)
              IconButton(
                icon: Icon(Icons.edit_outlined),
                tooltip: '编辑',
                onPressed: () => setState(() => _isEditing = true),
              )
            else ...[
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
              else ...[
                IconButton(
                  icon: Icon(Icons.close),
                  tooltip: '取消',
                  onPressed: () => setState(() => _isEditing = false),
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  tooltip: '保存',
                  onPressed: _saveChanges,
                ),
              ],
            ],
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
                    if (_isEditing) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '账本名称',
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
                    ] else ...[
                      Text(
                        _nameController.text,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_descriptionController.text.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Text(
                          _descriptionController.text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '币种：',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _currencySymbol,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
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
              isEditing: _isEditing,
              onMembersChanged: (members) {
                setState(() => _members = members);
              },
              onAddMember: _addMember,
            ),
          ],
        ),
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
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchUsers(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);

    // try {
    //   final response = await ApiService.searchUsers(keyword);
    //   if (response['code'] == 0) {
    //     setState(() => _searchResults = List<Map<String, dynamic>>.from(response['data']));
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('搜索用户失败：$e')),
    //   );
    // } finally {
    //   setState(() => _isSearching = false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('添加成员'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: '搜索用户',
              border: OutlineInputBorder(),
            ),
            onChanged: _searchUsers,
          ),
          if (_isSearching)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),
          if (_searchResults.isNotEmpty) ...[
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];

                return ListTile(
                  title: Text(user['nickname']),
                  trailing: IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () => Navigator.pop(context, user),
                  ),
                );
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
              context, _searchResults.isNotEmpty ? _searchResults[0] : null),
          child: Text('添加'),
        ),
      ],
    );
  }
}
