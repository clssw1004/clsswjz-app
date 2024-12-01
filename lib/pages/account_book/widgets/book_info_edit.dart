import 'package:flutter/material.dart';
import 'member_list.dart';

class BookInfoEdit extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final bool isSaving;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const BookInfoEdit({
    Key? key,
    required this.initialData,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<BookInfoEdit> createState() => _BookInfoEditState();
}

class _BookInfoEditState extends State<BookInfoEdit> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _currencySymbol;
  late List<dynamic> _members;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _descriptionController = TextEditingController(text: widget.initialData['description']);
    _currencySymbol = widget.initialData['currencySymbol'] ?? '¥';
    _members = List<dynamic>.from(widget.initialData['members'] ?? []);
  }

  void _handleSave() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('账本名称不能为空')),
      );
      return;
    }

    widget.onSave({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'currencySymbol': _currencySymbol,
      'members': _members,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        ListView(
          children: [
            Card(
              margin: EdgeInsets.all(16),
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '成员管理',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 8),
            MemberList(
              members: _members,
              createdBy: widget.initialData['createdBy'] ?? '',
              isEditing: true,
              onMembersChanged: (members) {
                setState(() => _members = members);
              },
            ),
            SizedBox(height: 80), // 为底部按钮留出空间
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.isSaving)
                  FilledButton(
                    onPressed: _handleSave,
                    child: Text('保存'),
                  )
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(
                    '取消',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 