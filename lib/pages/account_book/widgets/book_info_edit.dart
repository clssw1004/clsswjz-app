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
    return Stack(
      children: [
        ListView(
          children: [
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '账本名称',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: '账本描述',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('币种：'),
                        SizedBox(width: 8),
                        Text(_currencySymbol),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '成员管理',
                style: Theme.of(context).textTheme.titleMedium,
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
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.isSaving)
                  TextButton(
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
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text('取消'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 