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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: ElevatedButton.icon(
              onPressed: onAddMember,
              icon: Icon(Icons.person_add_outlined),
              label: Text('添加成员'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
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

            return Dismissible(
              key: Key(member['userId']),
              direction: isEditing && !isCreator 
                  ? DismissDirection.endToStart 
                  : DismissDirection.none,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 16),
                color: theme.colorScheme.error,
                child: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.onError,
                ),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('确认删除'),
                    content: Text('确定要移除该成员吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('取消'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          '删除',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) => _removeMember(index),
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCreator 
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : theme.colorScheme.surfaceVariant,
                        child: Text(
                          member['nickname']?[0].toUpperCase() ?? '?',
                          style: TextStyle(
                            color: isCreator 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      title: Text(member['nickname'] ?? '未知用户'),
                      subtitle: isCreator ? Text('创建者') : null,
                      trailing: isEditing && !isCreator
                          ? IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              color: theme.colorScheme.error,
                              onPressed: () => _removeMember(index),
                            )
                          : null,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
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
                          SizedBox(height: 12),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
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
    final isEnabled = member[permission] == true;

    return InkWell(
      onTap: isEditing ? () => _updateMemberPermission(index, permission, !isEnabled) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isEnabled
              ? theme.colorScheme.primary.withOpacity(0.15)
              : theme.colorScheme.surfaceVariant.withOpacity(0.5),
          border: Border.all(
            color: isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEnabled)
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.check_circle,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isEnabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                fontWeight: isEnabled ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}