import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/user_service.dart';
import '../../utils/message_helper.dart';
import '../../widgets/app_bar_factory.dart';
import '../../widgets/dialog_factory.dart';
import '../../widgets/list_item_card.dart';
import '../../widgets/avatar_factory.dart';
import '../../models/models.dart';

class CategoryManagementPage extends StatefulWidget {
  @override
  State<CategoryManagementPage> createState() => CategoryManagementPageState();
}

class CategoryManagementPageState extends State<CategoryManagementPage> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _currentAccountBookId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final currentContext = context;
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      _currentAccountBookId = await UserService.getCurrentAccountBookId();
      if (!mounted) return;

      if (_currentAccountBookId == null) {
        throw '未选择默认账本';
      }

      final categories = await ApiService.getCategories(_currentAccountBookId!);
      setState(() => _categories = categories);

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(currentContext, message: e.toString());
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createCategory() async {
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
      MessageHelper.showSuccess(context, message: '创建成功');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<void> _updateCategory(Category category, String newName) async {
    try {
      final updatedCategory = category.copyWith(
        name: newName,
      );

      await ApiService.updateCategory(category.id, updatedCategory);
      await _loadData();
      if (!mounted) return;
      MessageHelper.showSuccess(context, message: '更新成功');
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Future<String?> _showNameDialog(BuildContext context, [String? initialName]) {
    final controller = TextEditingController(text: initialName);

    return DialogFactory.showFormDialog<String>(
      context: context,
      title: initialName == null ? '新建分类' : '编辑分类',
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: DialogFactory.getInputDecoration(
          context: context,
          label: '分类名称',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: DialogFactory.getDialogButtonStyle(context: context),
          child: Text('取消'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          style: DialogFactory.getDialogButtonStyle(
            context: context,
            isPrimary: true,
          ),
          child: Text(initialName == null ? '创建' : '保存'),
        ),
      ],
    );
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
        title: AppBarFactory.buildTitle(context, '分类管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.primaryColor),
            tooltip: '新建分类',
            onPressed: _createCategory,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
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
