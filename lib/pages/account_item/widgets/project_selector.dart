import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../models/form_selector.dart';
import '../../../widgets/form/form_selector_field.dart';

class ProjectSelector extends StatelessWidget {
  final String? selectedProject;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onTap;

  const ProjectSelector({
    Key? key,
    this.selectedProject,
    required this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        return FormSelectorField<AccountSymbol>(
          items: provider.projects,
          value: selectedProject,
          icon: Icons.folder_outlined,
          placeholder: l10n.selectProjectHint,
          config: FormSelectorConfig<AccountSymbol>(
            idField: 'code',
            labelField: 'name',
            valueField: 'name',
            dialogTitle: l10n.selectProjectTitle,
            searchHint: l10n.searchProjectHint,
            noDataText: l10n.selectProjectTitle,
            addItemTemplate: l10n.addButtonWith('项目'),
            showSearch: true,
            showAddButton: true,
            mode: FormSelectorMode.badge,
            gridMaxCount: 9,
            alignGrid: true,
          ),
          callbacks: FormSelectorCallbacks(
            onChanged: onChanged,
            onItemAdded: (name) async {
              final symbol = AccountSymbol(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                code: name,
                symbolType: 'PROJECT',
                accountBookId: provider.selectedBook?.id ?? '',
              );
              provider.addTag(symbol);
              onChanged(symbol.name);
            },
            onTap: onTap,
          ),
        );
      },
    );
  }
}
