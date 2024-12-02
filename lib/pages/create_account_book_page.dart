import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/currency_symbols.dart';
import '../constants/book_icons.dart';
import '../widgets/icon_picker_dialog.dart';

class CreateAccountBookPage extends StatefulWidget {
  @override
  _CreateAccountBookPageState createState() => _CreateAccountBookPageState();
}

class _CreateAccountBookPageState extends State<CreateAccountBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCurrency = CurrencySymbols.defaultCurrency;
  IconData _selectedIcon = BookIcons.defaultIcon;
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '新增账本',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '账本名称',
                hintText: '请输入账本名称',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入账本名称';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: '账本描述',
                hintText: '请输入账本描述（选填）',
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
            // 币种选择
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: InputDecoration(
                labelText: '币种',
                labelStyle: TextStyle(color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
              ),
              items: CurrencySymbols.currencies.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text('${entry.value} (${entry.key})'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                }
              },
            ),
            SizedBox(height: 24),
            FilledButton(
              onPressed: _submitForm,
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary),
                      ),
                    )
                  : Text(
                      '创建账本',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService.createAccountBook(
        _nameController.text,
        _descriptionController.text,
        currencySymbol: CurrencySymbols.currencies[_selectedCurrency]!,
        icon: _selectedIcon.codePoint.toString(),
      );

      if (!mounted) return;
      MessageHelper.showSuccess(
        context,
        message: '创建成功',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(
        context,
        message: '创建失败：$e',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
