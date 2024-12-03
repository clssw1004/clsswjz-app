import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/user_service.dart';
import '../../utils/message_helper.dart';
import '../../widgets/app_bar_factory.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShopManagementPage extends StatefulWidget {
  @override
  _ShopManagementPageState createState() => _ShopManagementPageState();
}

class _ShopManagementPageState extends State<ShopManagementPage> {
  List<Map<String, dynamic>> _shops = [];
  bool _isLoading = true;
  String? _currentAccountBookId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _currentAccountBookId = await UserService.getCurrentAccountBookId();
      if (_currentAccountBookId == null) {
        throw '未选择默认账本';
      }

      final shops = await ApiService.fetchShops(
        context,
        _currentAccountBookId!,
      );

      setState(() {
        _shops = shops;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createShop() async {
    final name = await _showNameDialog(context);
    if (name == null || name.isEmpty) return;

    try {
      await ApiService.createShop(
        context,
        name,
        _currentAccountBookId!,
      );
      await _loadData();
      if (mounted) {
        MessageHelper.showSuccess(context, message: '创建成功');
      }
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
      }
    }
  }

  Future<void> _updateShop(String oldName, String newName) async {
    if (oldName == newName) return;

    try {
      final shop = _shops.firstWhere(
        (s) => s['name'] == oldName,
        orElse: () => throw '未找到商家',
      );
      await ApiService.updateShop(
        context,
        shop['id'],
        newName,
      );
      await _loadData();
      if (mounted) {
        MessageHelper.showSuccess(context, message: '更新成功');
      }
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
      }
    }
  }

  Future<String?> _showNameDialog(BuildContext context, [String? initialName]) {
    final controller = TextEditingController(text: initialName);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(initialName == null ? '新建商家' : '编辑商家'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: '商家名称',
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(initialName == null ? '创建' : '保存'),
          ),
        ],
      ),
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
        title: '商家管理',
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: '新建商家',
            onPressed: _createShop,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _shops.length,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemBuilder: (context, index) {
                  final isLastItem = index == _shops.length - 1;
                  final shop = _shops[index];
                  return Column(
                    children: [
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: colorScheme.outlineVariant.withOpacity(0.5),
                          ),
                        ),
                        child: ListTile(
                          onTap: () async {
                            final newName = await _showNameDialog(
                              context,
                              shop['name'],
                            );
                            if (newName != null && newName.isNotEmpty) {
                              await _updateShop(shop['name'], newName);
                            }
                          },
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            shop['name'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              shop['name'].substring(0, 1),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.edit_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
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
