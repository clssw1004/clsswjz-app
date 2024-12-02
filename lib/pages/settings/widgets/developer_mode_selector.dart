import 'package:flutter/material.dart';
import '../../../utils/run_mode_util.dart';

class DeveloperModeSelector extends StatefulWidget {
  const DeveloperModeSelector({Key? key}) : super(key: key);

  @override
  State<DeveloperModeSelector> createState() => _DeveloperModeSelectorState();
}

class _DeveloperModeSelectorState extends State<DeveloperModeSelector> {
  bool _isDebugMode = false;

  @override
  void initState() {
    super.initState();
    _loadRunMode();
  }

  Future<void> _loadRunMode() async {
    final isDebug = await RunModeUtil.isDebugMode();
    setState(() {
      _isDebugMode = isDebug;
    });
  }

  Future<void> _toggleMode(bool value) async {
    await RunModeUtil.setRunMode(
      value ? RunModeUtil.debugMode : RunModeUtil.productMode,
    );
    setState(() {
      _isDebugMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        Icons.developer_mode,
        color: colorScheme.primary,
      ),
      title: Text(
        '开发者模式',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      trailing: Switch(
        value: _isDebugMode,
        onChanged: _toggleMode,
      ),
    );
  }
}
