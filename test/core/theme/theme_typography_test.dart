import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('globalny ThemeData utrzymuje lekką typografię i akcent zakładek', () {
    final theme = MaterialTheme(Typography.material2021().black).light();
    final colors = theme.colorScheme;

    expect(theme.textTheme.bodyMedium?.fontSize, 12);
    expect(theme.textTheme.bodyMedium?.color, colors.onSurface);
    expect(theme.textTheme.labelLarge?.fontSize, 12);
    expect(theme.textTheme.labelLarge?.color, colors.onSurface);
    expect(theme.textTheme.titleMedium?.color, colors.onSurface);
    expect(theme.iconTheme.size, 18);
    final navigation = theme.extension<DevPlannerNavigationTheme>();
    expect(navigation, isNotNull);
    expect(navigation?.sidebarWidth, 224);
    expect(navigation?.headerHeight, 56);
    expect(navigation?.rowHeight, 28);
    expect(navigation?.rowFontSize, 12);
    expect(
      theme.iconButtonTheme.style?.minimumSize?.resolve({}),
      const Size(36, 36),
    );
    expect(theme.tabBarTheme.labelColor, colors.primary);
    expect(theme.tabBarTheme.unselectedLabelColor, colors.onSurfaceVariant);
    expect(theme.tabBarTheme.labelStyle?.fontWeight, FontWeight.w800);
  });
}
