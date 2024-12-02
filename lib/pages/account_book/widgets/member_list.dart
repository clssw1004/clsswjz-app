import 'package:flutter/material.dart';

class MemberList extends StatelessWidget {
  final List<dynamic> members;
  final String createdBy;
  final bool isEditing;
  final Function(List<dynamic>)? onMembersChanged;
  final Function()? onAddMember;

  const MemberList({
    Key? key,
    required this.members,
    required this.createdBy,
    this.isEditing = false,
    this.onMembersChanged,
    this.onAddMember,
  }) : super(key: key);

  void _updateMemberPermission(int index, String permission, bool value) {
    if (!isEditing) return;
    final updatedMembers = List<dynamic>.from(members);
    updatedMembers[index] = Map<String, dynamic>.from(updatedMembers[index]);
    updatedMembers[index][permission] = value;
    onMembersChanged?.call(updatedMembers);
  }

  void _removeMember(int index) {
    if (!isEditing) return;
    final updatedMembers = List<dynamic>.from(members);
    updatedMembers.removeAt(index);
    onMembersChanged?.call(updatedMembers);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: FilledButton.icon(
              onPressed: onAddMember,
              icon: Icon(Icons.person_add_outlined, size: 18),
              label: Text('添加成员'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size(120, 36),
              ),
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final isCreator = member['userId'] == createdBy;

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Text(
                          member['nickname'] ?? '未知用户',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isCreator) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '创建者',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: isEditing && !isCreator
                        ? IconButton(
                            icon: Icon(Icons.remove_circle_outline, size: 18),
                            color: colorScheme.error,
                            onPressed: () => _removeMember(index),
                          )
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPermissionSection(
                          context,
                          index,
                          member,
                          '账本权限',
                          {
                            'canViewBook': '查看',
                            'canEditBook': '编辑',
                            'canDeleteBook': '删除',
                          },
                        ),
                        SizedBox(height: 8),
                        _buildPermissionSection(
                          context,
                          index,
                          member,
                          '账目权限',
                          {
                            'canViewItem': '查看',
                            'canEditItem': '编辑',
                            'canDeleteItem': '删除',
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPermissionSection(
    BuildContext context,
    int index,
    Map<String, dynamic> member,
    String title,
    Map<String, String> permissionMap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: permissionMap.entries.map((entry) {
            return _buildPermissionButton(
              context,
              index,
              member,
              entry.value,
              entry.key,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPermissionButton(
    BuildContext context,
    int index,
    Map<String, dynamic> member,
    String label,
    String permission,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = member[permission] == true;

    return InkWell(
      onTap: isEditing
          ? () => _updateMemberPermission(index, permission, !isEnabled)
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isEnabled
              ? colorScheme.primary.withOpacity(0.1)
              : colorScheme.surfaceVariant.withOpacity(0.5),
          border: Border.all(
            color: isEnabled
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEnabled)
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.check,
                  size: 12,
                  color: colorScheme.primary,
                ),
              ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withOpacity(0.8),
                fontWeight: isEnabled ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
