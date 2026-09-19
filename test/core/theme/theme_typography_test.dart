import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('globalny ThemeData utrzymuje lekką typografię i akcent zakładek', () {
    final theme = MaterialTheme(Typography.material2021().black).light();
    final colors = theme.colorScheme;

    expect(theme.textTheme.bodyMedium?.fontSize, 13);
    expect(theme.textTheme.bodyMedium?.color, colors.onSurface);
    expect(theme.textTheme.labelLarge?.fontSize, 13);
    expect(theme.textTheme.labelLarge?.color, colors.onSurface);
    expect(theme.textTheme.titleMedium?.color, colors.onSurface);
    expect(theme.tabBarTheme.labelColor, colors.primary);
    expect(theme.tabBarTheme.unselectedLabelColor, colors.onSurfaceVariant);
    expect(theme.tabBarTheme.labelStyle?.fontWeight, FontWeight.w800);
  });
}
