import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'account_book/widgets/book_info_view.dart';
import 'account_book/widgets/book_info_edit.dart';

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
  late String _name;
  late String _description;
  late String _currencySymbol;
  late List<dynamic> _members;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _name = widget.accountBook['name'];
    _description = widget.accountBook['description'];
    _currencySymbol = widget.accountBook['currencySymbol'] ?? '¥';
    _members = List<dynamic>.from(widget.accountBook['members'] ?? []);
  }

  Future<void> _saveChanges(Map<String, dynamic> data) async {
    setState(() => _isSaving = true);

    try {
      final response = await ApiService.updateAccountBook(
        widget.accountBook['id'],
        {
          'name': data['name'],
          'description': data['description'],
          'currencySymbol': data['currencySymbol'],
          'members': data['members'],
        },
      );

      if (response['code'] == 0) {
        setState(() {
          _name = data['name'];
          _description = data['description'];
          _currencySymbol = data['currencySymbol'];
          _members = data['members'];
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存成功')),
        );
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败：$e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账本详情'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else if (_isSaving)
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
        ],
      ),
      body: _isEditing
          ? BookInfoEdit(
              initialData: {
                'name': _name,
                'description': _description,
                'currencySymbol': _currencySymbol,
                'members': _members,
                'createdBy': widget.accountBook['createdBy'],
              },
              isSaving: _isSaving,
              onSave: _saveChanges,
              onCancel: () => setState(() => _isEditing = false),
            )
          : BookInfoView(
              data: {
                'name': _name,
                'description': _description,
                'currencySymbol': _currencySymbol,
                'members': _members,
                'createdBy': widget.accountBook['createdBy'],
              },
            ),
    );
  }
} 