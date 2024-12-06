import 'package:flutter/material.dart';
import '../constants/layout_constants.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < LayoutConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= LayoutConstants.mobileBreakpoint &&
      MediaQuery.of(context).size.width < LayoutConstants.tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= LayoutConstants.desktopBreakpoint;

  static double getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= LayoutConstants.maxContentWidth) {
      return LayoutConstants.maxContentWidth;
    }
    return width;
  }
} 