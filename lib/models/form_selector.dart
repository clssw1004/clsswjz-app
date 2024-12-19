import 'package:flutter/material.dart';

enum FormSelectorMode {
  // 图标+文字模式
  standard,
  // 展开按钮模式
  grid,
  // 徽章模式
  badge,
}

/// 选择器配置
class FormSelectorConfig<T> {
  // ID字段的key
  final String idField;
  // 显示文本的key
  final String labelField;
  // 值字段的key
  final String valueField;
  // 弹窗标题
  final String dialogTitle;
  // 搜索框提示文本
  final String searchHint;
  // 无数据文本
  final String noDataText;
  // 新增项文本模板
  final String addItemTemplate;

  // 新增配置项
  final bool showSearch; // 是否显示搜索框
  final bool showAddButton; // 是否显示添加按钮
  final FormSelectorMode mode; // 替换 showGridSelector 为 mode
  final int gridMaxCount; // 展开显示的最大数量
  final int gridRowCount; // 每行显示数量
  final bool alignGrid; // 新增：是否对齐展开按钮

  const FormSelectorConfig({
    required this.idField,
    required this.labelField,
    required this.valueField,
    required this.dialogTitle,
    required this.searchHint,
    required this.noDataText,
    required this.addItemTemplate,
    this.showSearch = true,
    this.showAddButton = true,
    this.mode = FormSelectorMode.standard,
    this.gridMaxCount = 9,
    this.gridRowCount = 3,
    this.alignGrid = false,
  });
}

/// 选择器回调
class FormSelectorCallbacks<T> {
  // 值变更回调
  final ValueChanged<String?> onChanged;
  // 新增项回调
  final ValueChanged<String>? onItemAdded;
  // 点击回调
  final VoidCallback? onTap;

  const FormSelectorCallbacks({
    required this.onChanged,
    this.onItemAdded,
    this.onTap,
  });
}
