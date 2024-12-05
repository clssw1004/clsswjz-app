import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/user_service.dart';
import '../../utils/message_helper.dart';
import '../../widgets/app_bar_factory.dart';
import '../../widgets/dialog_factory.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/avatar_factory.dart';
import '../../models/models.dart';
import '../../l10n/l10n.dart';

class CategoryManagementPage extends StatefulWidget {
  @override
  State<CategoryManagementPage> createState() => CategoryManagementPageState();
}

class CategoryManagementPageState extends State<CategoryManagementPage> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _currentAccountBookId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _currentAccountBookId = await UserService.getCurrentAccountBookId();
      if (!mounted) return;

      if (_currentAccountBookId == null) {
        setState(() {
          _errorMessage = 'noDefaultBook';
          _isLoading = false;
        });
        return;
      }

      final categories = await ApiService.getCategories(_currentAccountBookId!);
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createCategory() async {
    final l10n = L10n.of(context);
    final name = await _showNameDialog(context);
    if (name == null || name.isEmpty || !mounted) return;

    try {
      final category = Category(
        id: '', // 由后端生成
        name: name,
        accountBookId: _currentAccountBookId!,
      );

      await ApiService.createCategory(category);
      await _loadData();
      if (!mounted) return;
      MessageHelper.showSuccess(context, message: l10n.createCategorySuccess);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<void> _updateCategory(Category category, String newName) async {
    final l10n = L10n.of(context);
    try {
      final updatedCategory = category.copyWith(
        name: newName,
      );

      await ApiService.updateCategory(category.id, updatedCategory);
      await _loadData();
      if (!mounted) return;
      MessageHelper.showSuccess(context, message: l10n.updateCategorySuccess);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<String?> _showNameDialog(BuildContext context, [String? initialName]) {
    final controller = TextEditingController(text: initialName);
    final l10n = L10n.of(context);

    return DialogFactory.showFormDialog<String>(
      context: context,
      title: initialName == null ? l10n.newCategory : l10n.editCategory,
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: DialogFactory.getInputDecoration(
          context: context,
          label: l10n.categoryName,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: DialogFactory.getDialogButtonStyle(context: context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          style: DialogFactory.getDialogButtonStyle(
            context: context,
            isPrimary: true,
          ),
          child: Text(initialName == null ? l10n.create : l10n.save),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    if (_errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_errorMessage == 'noDefaultBook') {
          MessageHelper.showError(context, message: l10n.noDefaultBook);
        } else {
          MessageHelper.showError(context, message: _errorMessage!);
        }
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.categoryTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: l10n.addCategory,
            onPressed: _createCategory,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _categories.isEmpty
                ? Center(
                    child: Text(
                      l10n.noCategories,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _categories.length,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemBuilder: (context, index) {
                      final isLastItem = index == _categories.length - 1;
                      final category = _categories[index];
                      return Column(
                        children: [
                          ListItemCard(
                            title: category.name,
                            onTap: () async {
                              final currentContext = context;
                              final newName = await _showNameDialog(
                                currentContext,
                                category.name,
                              );
                              if (newName != null && newName.isNotEmpty) {
                                await _updateCategory(category, newName);
                              }
                            },
                            leading: AvatarFactory.buildCircleAvatar(
                              context: context,
                              text: category.name,
                            ),
                            trailing: Icon(
                              Icons.edit_outlined,
                              color: colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          if (!isLastItem) SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
