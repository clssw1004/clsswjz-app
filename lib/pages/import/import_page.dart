import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/data_source_type.dart';
import '../../services/api_service.dart';
import '../../utils/message_helper.dart';
import '../../l10n/l10n.dart';
import '../../widgets/app_bar_factory.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  String? _selectedBookId;
  DataSourceType? _selectedDataSource;
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  List<Map<String, dynamic>> _accountBooks = [];

  @override
  void initState() {
    super.initState();
    _loadAccountBooks();
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await ApiService.getAccountBooks();
      setState(() {
        _accountBooks = books.map((book) => book.toJson()).toList();
      });
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<void> _importData() async {
    if (_selectedBookId == null ||
        _selectedDataSource == null ||
        _selectedFile == null) {
      MessageHelper.showError(
        context,
        message: L10n.of(context).importFieldsRequired,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.importData(
        accountBookId: _selectedBookId!,
        dataSource: _selectedDataSource!.name,
        file: _selectedFile!,
      );

      if (mounted) {
        MessageHelper.showSuccess(
          context,
          message: L10n.of(context).importSuccess,
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dropdownDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
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
        ),
      ),
      filled: false,
    );

    return Scaffold(
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.importData),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedBookId,
              decoration: dropdownDecoration.copyWith(
                labelText: l10n.selectBook,
              ),
              items: _accountBooks
                  .map((book) => DropdownMenuItem(
                        value: book['id'] as String,
                        child: Text(book['name'] as String),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedBookId = value);
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<DataSourceType>(
              value: _selectedDataSource,
              decoration: dropdownDecoration.copyWith(
                labelText: l10n.dataSource,
              ),
              items: DataSourceType.values
                  .map<DropdownMenuItem<DataSourceType>>(
                      (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedDataSource = value);
              },
            ),
            SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: _pickFile,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 8),
                    Text(_selectedFile?.name ?? l10n.selectFile),
                  ],
                ),
              ),
            ),
            if (_selectedFile != null) ...[
              SizedBox(height: 8),
              Text(
                _selectedFile!.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _importData,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(l10n.importData),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
