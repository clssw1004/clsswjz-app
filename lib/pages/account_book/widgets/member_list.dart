import 'package:flutter/material.dart';

import '../../../services/api_service.dart';
import '../../../models/models.dart';
import '../../../l10n/l10n.dart';

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
    final l10n = L10n.of(context);

    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmRemoveMember),
        content: Text(l10n.confirmRemoveMemberMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.delete,
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
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            l10n.memberManagement,
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
              label: Text(l10n.addMember),
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
    final l10n = L10n.of(context);

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
                  member.nickname ?? l10n.unknownMember,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isCreator) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.creator,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
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

  Widget _buildPermissionToggles(Member member, int index) {
    final l10n = L10n.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildPermissionToggle(
          l10n.permViewBook,
          'canViewBook',
          member.canViewBook,
          index,
        ),
        _buildPermissionToggle(
          l10n.permEditBook,
          'canEditBook',
          member.canEditBook,
          index,
        ),
        _buildPermissionToggle(
          l10n.permDeleteBook,
          'canDeleteBook',
          member.canDeleteBook,
          index,
        ),
        _buildPermissionToggle(
          l10n.permViewItem,
          'canViewItem',
          member.canViewItem,
          index,
        ),
        _buildPermissionToggle(
          l10n.permEditItem,
          'canEditItem',
          member.canEditItem,
          index,
        ),
        _buildPermissionToggle(
          l10n.permDeleteItem,
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
    final l10n = L10n.of(dialogContext);

    // 添加邀请码输入对话框
    final controller = TextEditingController();
    final inviteCode = await showDialog<String>(
      context: dialogContext,
      builder: (context) => AlertDialog(
        title: Text(l10n.addMemberTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.inviteCodeLabel,
            hintText: l10n.inviteCodeHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.add),
          ),
        ],
      ),
    );

    if (inviteCode == null || inviteCode.isEmpty || !mounted) return;

    try {
      final userInfo = await ApiService.getUserByInviteCode(inviteCode);
      if (!mounted) return;

      if (userInfo == null) {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(content: Text('邀请码无效')),
        );
        return;
      }

      final userId = userInfo['userId'] as String?;
      if (userId == null) {
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(content: Text('无效的用户信息')),
        );
        return;
      }

      final isAlreadyMember = widget.members.any((m) => m.userId == userId);
      if (isAlreadyMember) {
        if (!mounted) return;
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(content: Text(l10n.memberAlreadyExists)),
        );
        return;
      }

      // 添加新成员
      final newMember = Member(
        userId: userId,
        nickname: userInfo['nickname'] as String? ?? userInfo['username'] as String? ?? l10n.unknownMember,
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
        SnackBar(content: Text(l10n.addMemberSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text(l10n.addMemberFailed(e.toString()))),
      );
    }
  }
}
