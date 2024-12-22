import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../services/user_service.dart';
import '../../utils/message_helper.dart';
import '../../l10n/l10n.dart';
import '../../widgets/app_bar_factory.dart';
import '../../theme/app_theme.dart';

class SymbolListPage extends StatefulWidget {
  final String title;
  final String symbolType;

  const SymbolListPage({
    Key? key,
    required this.title,
    required this.symbolType,
  }) : super(key: key);

  @override
  State<SymbolListPage> createState() => _SymbolListPageState();
}

class _SymbolListPageState extends State<SymbolListPage> {
  List<AccountSymbol> _symbols = [];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final currentBookId = UserService.getCurrentAccountBookId();
      if (currentBookId == null) {
        throw Exception('No book selected');
      }

      final symbols = await ApiService.getBookSymbolsByType(
        currentBookId,
        widget.symbolType,
      );

      setState(() {
        _symbols = symbols;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addSymbol() async {
    final l10n = L10n.of(context);
    final currentBookId = UserService.getCurrentAccountBookId();
    if (currentBookId == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
        ),
        title: Text(l10n.addButtonWith(widget.title)),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.name,
              hintText: l10n.pleaseInput(widget.title),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.light
                  ? AppColors.white
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.inputRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.padding,
                vertical: AppDimens.paddingSmall,
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return l10n.fieldRequired;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                try {
                  final symbol = AccountSymbol(
                    id: '',
                    name: _nameController.text,
                    code: _nameController.text,
                    symbolType: widget.symbolType,
                    accountBookId: currentBookId,
                  );
                  await ApiService.createSymbol(symbol);
                  _nameController.clear();
                  Navigator.pop(context);
                  await _loadData();
                } catch (e) {
                  MessageHelper.showError(context, message: e.toString());
                }
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _editSymbol(AccountSymbol symbol) async {
    final l10n = L10n.of(context);
    _nameController.text = symbol.name;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editButtonWith(widget.title)),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.name,
              hintText: l10n.pleaseInput(widget.title),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return l10n.fieldRequired;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                try {
                  final updatedSymbol = symbol.copyWith(
                    name: _nameController.text,
                  );
                  await ApiService.updateSymbol(symbol.id, updatedSymbol);
                  _nameController.clear();
                  Navigator.pop(context);
                  await _loadData();
                } catch (e) {
                  MessageHelper.showError(context, message: e.toString());
                }
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSymbol(AccountSymbol symbol) async {
    final l10n = L10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiService.deleteSymbol(symbol.id);
        await _loadData();
      } catch (e) {
        if (mounted) {
          MessageHelper.showError(context, message: e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _symbols.isEmpty
              ? Center(
                  child: Text(l10n.noDataAvailable),
                )
              : ListView.builder(
                  itemCount: _symbols.length,
                  itemBuilder: (context, index) {
                    final symbol = _symbols[index];
                    return ListTile(
                      title: Text(symbol.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editSymbol(symbol),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () => _deleteSymbol(symbol),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSymbol,
        child: const Icon(Icons.add),
      ),
    );
  }
}
