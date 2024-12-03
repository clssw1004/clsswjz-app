import 'package:flutter/material.dart';

import '../../../services/api_service.dart';
import '../../../models/models.dart';

class MemberList extends StatefulWidget {
  final List<Member> members;
  final String createdBy;
  final ValueChanged<List<Member>> onUpdate;
  final String? currentUserId;

  const MemberList({
    Key? key,
    required this.members,
    required this.createdBy,
    required this.onUpdate,
    this.currentUserId,
  }) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  bool get isEditable => widget.currentUserId == widget.createdBy;

  void _updateMemberPermission(int index, String permission, bool value) {
    if (!isEditable) return;
    final updatedMembers = List<Member>.from(widget.members);
    final member = updatedMembers[index];
    final updatedMember = member.copyWith(
      canViewBook: permission == 'canViewBook' ? value : member.canViewBook,
      canEditBook: permission == 'canEditBook' ? value : member.canEditBook,
      canDeleteBook:
          permission == 'canDeleteBook' ? value : member.canDeleteBook,
      canViewItem: permission == 'canViewItem' ? value : member.canViewItem,
      canEditItem: permission == 'canEditItem' ? value : member.canEditItem,
      canDeleteItem:
          permission == 'canDeleteItem' ? value : member.canDeleteItem,
    );
    updatedMembers[index] = updatedMember;
    widget.onUpdate(updatedMembers);
  }

  Future<void> _removeMember(int index) async {
    if (!isEditable) return;

    final shouldRemove = await showDialog<bool>(
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
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (shouldRemove ?? false) {
      final updatedMembers = List<Member>.from(widget.members);
      updatedMembers.removeAt(index);
      widget.onUpdate(updatedMembers);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            '成员管理',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        if (isEditable)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: FilledButton.icon(
              onPressed: () => _showAddMemberDialog(context),
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
          itemCount: widget.members.length,
          itemBuilder: (context, index) {
            final member = widget.members[index];
            final isCreator = member.userId == widget.createdBy;

            return _buildMemberCard(
              context,
              member,
              isCreator,
              index,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    Member member,
    bool isCreator,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  member.nickname ?? '未知用户',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isCreator) ...[
                  SizedBox(width: 8),
                  _buildCreatorBadge(context),
                ],
              ],
            ),
            trailing: isEditable && !isCreator
                ? IconButton(
                    icon: Icon(Icons.remove_circle_outline, size: 18),
                    color: colorScheme.error,
                    onPressed: () => _removeMember(index),
                  )
                : null,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildPermissionToggles(member, index),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '创建者',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildPermissionToggles(Member member, int index) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildPermissionToggle(
          '查看账本',
          'canViewBook',
          member.canViewBook,
          index,
        ),
        _buildPermissionToggle(
          '编辑账本',
          'canEditBook',
          member.canEditBook,
          index,
        ),
        _buildPermissionToggle(
          '删除账本',
          'canDeleteBook',
          member.canDeleteBook,
          index,
        ),
        _buildPermissionToggle(
          '查看账目',
          'canViewItem',
          member.canViewItem,
          index,
        ),
        _buildPermissionToggle(
          '编辑账',
          'canEditItem',
          member.canEditItem,
          index,
        ),
        _buildPermissionToggle(
          '删除账目',
          'canDeleteItem',
          member.canDeleteItem,
          index,
        ),
      ],
    );
  }

  Widget _buildPermissionToggle(
    String label,
    String permission,
    bool isEnabled,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: isEditable
          ? () => _updateMemberPermission(index, permission, !isEnabled)
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isEnabled
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEnabled ? Icons.check_box : Icons.check_box_outline_blank,
              size: 16,
              color: isEnabled
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isEnabled
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddMemberDialog(BuildContext dialogContext) async {
    if (!mounted) return;

    // 添加邀请码输入对话框
    final controller = TextEditingController();
    final inviteCode = await showDialog<String>(
      context: dialogContext,
      builder: (context) => AlertDialog(
        title: Text('添加成员'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '邀请码',
            hintText: '请输入邀请码',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('添加'),
          ),
        ],
      ),
    );

    if (inviteCode == null || inviteCode.isEmpty || !mounted) return;

    try {
      final userInfo = await ApiService.getUserByInviteCode(inviteCode);
      if (!mounted) return;

      final userId = userInfo['id'] as String?;
      if (userId == null) throw '无效的用户信息';

      final isAlreadyMember = widget.members.any((m) => m.userId == userId);
      if (isAlreadyMember) {
        if (!mounted) return;
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(content: Text('该用户已经是成员')),
        );
        return;
      }

      // 添加新成员
      final newMember = Member(
        userId: userId,
        nickname:
            userInfo['nickname'] as String? ?? userInfo['username'] as String,
        canViewBook: true,
        canEditBook: false,
        canDeleteBook: false,
        canViewItem: true,
        canEditItem: false,
        canDeleteItem: false,
      );

      final updatedMembers = [...widget.members, newMember];
      widget.onUpdate(updatedMembers);

      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text('成员添加成功')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text('添加成员失败：$e')),
      );
    }
  }
}
