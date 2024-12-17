import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/app_localizations.dart';
import '../../models/category.dart';
import 'providers/category_management_provider.dart';
import '../../widgets/app_bar_factory.dart';

class CategoryManagementPage extends StatefulWidget {
  final String bookId;

  const CategoryManagementPage({super.key, required this.bookId});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CategoryManagementProvider>().loadCategories(widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.categoryManagement),
      ),
      body: Column(
        children: [
          _buildTypeSelector(context),
          Expanded(
            child: _buildCategoryList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<CategoryManagementProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SegmentedButton<String>(
        segments: [
          ButtonSegment<String>(
            value: 'EXPENSE',
            label: Text(l10n.expense),
          ),
          ButtonSegment<String>(
            value: 'INCOME',
            label: Text(l10n.income),
          ),
        ],
        selected: {provider.selectedType},
        onSelectionChanged: (Set<String> newSelection) {
          provider.setSelectedType(newSelection.first);
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return Consumer<CategoryManagementProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        final categories = provider.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noCategories),
          );
        }

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditCategoryDialog(context, category),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<CategoryManagementProvider>();
    final controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.categoryName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                return;
              }

              final newCategory = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: controller.text.trim(),
                accountBookId: widget.bookId,
                categoryType: provider.selectedType,
              );

              await provider.createCategory(newCategory);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.createCategorySuccess)),
                );
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditCategoryDialog(
      BuildContext context, Category category) async {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<CategoryManagementProvider>();
    final controller = TextEditingController(text: category.name);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.categoryName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                return;
              }

              final updatedCategory = category.copyWith(
                name: controller.text.trim(),
              );

              await provider.updateCategory(category.id, updatedCategory);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.updateCategorySuccess)),
                );
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
