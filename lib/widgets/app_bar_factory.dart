import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarFactory {
  static Widget buildTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  static PreferredSizeWidget buildAppBar({
    required BuildContext context,
    required Widget title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    PreferredSizeWidget? bottom = const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1, thickness: 0),
    ),
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: theme.brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
      ),
    );

    return AppBar(
      title: title,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface.withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      actionsIconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: theme.brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      bottom: bottom,
    );
  }
}
