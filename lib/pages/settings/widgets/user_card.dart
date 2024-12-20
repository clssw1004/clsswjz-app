import 'package:clsswjz/models/models.dart';
import 'package:flutter/material.dart';
import '../../../generated/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../user/user_info_page.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  User? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshUserInfo();
  }

  Future<void> _refreshUserInfo() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final userInfo = await ApiService.getUserInfo();
      if (!mounted) return;
      setState(() {
        _userInfo = userInfo;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _userInfo = null;
        _isLoading = false;
      });
    }
  }

  Widget _buildStatItem(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final horizontalPadding = isLargeScreen ? 32.0 : 16.0;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Material(
        elevation: 0,
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            final route = MaterialPageRoute(
              builder: (_) => UserInfoPage(),
            );
            Navigator.push(context, route).then((value) {
              if (mounted && ModalRoute.of(context)?.isCurrent == true) {
                _refreshUserInfo();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        _userInfo?.nickname?.substring(0, 1) ??
                            _userInfo?.username?.substring(0, 1) ??
                            'U',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userInfo?.nickname ?? _userInfo?.username ?? l10n.noAccount,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_userInfo?.email != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _userInfo!.email!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                if (_userInfo != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        l10n.totalItems,
                        _userInfo!.stats.totalItems.toString(),
                        context,
                      ),
                      _buildStatItem(
                        l10n.totalDays,
                        _userInfo!.stats.totalDays.toString(),
                        context,
                      ),
                      _buildStatItem(
                        l10n.totalFunds,
                        '${l10n.currencySymbol}${_userInfo!.stats.totalFunds.toStringAsFixed(2)}',
                        context,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
