import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import '../../../theme/theme_manager.dart';

class ThemeColorSelector extends StatelessWidget {
  const ThemeColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.palette),
      title: Text('主题颜色'),
      onTap: () => _showThemeColorPicker(context),
    );
  }

  void _showThemeColorPicker(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '主题颜色',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '选择您喜欢的主题色',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          content: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeManager.themeColors.map((color) {
                      return InkWell(
                        onTap: () {
                          themeProvider.setThemeColor(color);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color == themeColor 
                                  ? Colors.white 
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: color == themeColor
                              ? Icon(Icons.check, color: Colors.white)
                              : null
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 