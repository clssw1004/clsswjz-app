import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: ListView(
        children: [
          // Logo 和版本信息
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appName,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    return Text(
                      '${l10n.version}: ${snapshot.data!.version}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 项目信息
          _buildSection(
            context,
            title: l10n.projectInfo,
            children: [
              _buildLinkTile(
                context,
                icon: Icons.code,
                title: l10n.sourceCode,
                subtitle: 'GitHub',
                url: 'https://github.com/clssw1004/clsswjz-app',
              ),
              _buildLinkTile(
                context,
                icon: Icons.download,
                title: l10n.latestRelease,
                subtitle: l10n.downloadLatestVersion,
                url: 'https://github.com/clssw1004/clsswjz-app/releases',
              ),
            ],
          ),

          // 技术框架
          _buildSection(
            context,
            title: l10n.technicalInfo,
            children: [
              _buildInfoTile(
                context,
                title: 'Flutter',
                subtitle: l10n.flutterDescription,
              ),
              _buildInfoTile(
                context,
                title: 'Material Design 3',
                subtitle: l10n.materialDescription,
              ),
              _buildInfoTile(
                context,
                title: 'Provider',
                subtitle: l10n.providerDescription,
              ),
            ],
          ),

          // 开源协议
          _buildSection(
            context,
            title: l10n.license,
            children: [
              _buildLinkTile(
                context,
                icon: Icons.gavel_outlined,
                title: 'MIT License',
                subtitle: l10n.mitLicenseDescription,
                url:
                    'https://github.com/clssw1004/clsswjz-app/blob/main/LICENSE',
              ),
            ],
          ),

          // 添加技术支持部分
          _buildSection(
            context,
            title: l10n.support,
            children: [
              _buildLinkTile(
                context,
                icon: Icons.email_outlined,
                title: l10n.technicalSupport,
                subtitle: 'clssw@foxmail.com',
                url: 'mailto:clssw@foxmail.com',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.open_in_new),
      onTap: () => _launchUrl(url),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (url.startsWith('mailto:')) {
        await launchUrl(uri); // 邮件链接不需要 externalApplication 模式
      } else {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }
}
