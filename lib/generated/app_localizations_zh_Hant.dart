  @override
  String get noAvailableProjects => '暫無可用項目';

  @override
  String actionWithTarget(String action, String target) => '$action$target';

  @override
  Map<String, String> get action => {
    'new': '新建',
    'edit': '編輯',
    'add': '添加',
  };

  @override
  Map<String, String> get target => {
    'shop': '商家',
    'category': '分類',
    'fund': '賬戶',
    'book': '賬本',
    'member': '成員',
    'attachment': '附件',
    'record': '記錄',
  }; 