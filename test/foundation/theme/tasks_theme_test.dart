import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final lightTheme = MaterialTheme.crm().light();
  final darkTheme = MaterialTheme.crm().dark();

  DevPlannerTasksTheme tasksThemeOf(ThemeData theme) {
    final tasks = theme.extension<DevPlannerTasksTheme>();
    expect(
      tasks,
      isNotNull,
      reason: 'Motyw aplikacji musi wnosić tokeny Tasks.',
    );
    return tasks!;
  }

  group('DevPlannerTasksTheme — typografia', () {
    test('podnosi podłogę czytelności ponad 10 px', () {
      final theme = tasksThemeOf(lightTheme);
      for (final style in [
        theme.projectTitleText,
        theme.dataText,
        theme.dataStrongText,
        theme.cardTitleText,
        theme.controlText,
        theme.metaText,
      ]) {
        expect(
          style.fontSize,
          greaterThanOrEqualTo(11),
          reason: 'Żadna etykieta Tasks nie może schodzić pod 11 px.',
        );
      }
    });

    test('trzyma kontrakt rozmiarów i interlinii z planu', () {
      final theme = tasksThemeOf(lightTheme);
      expect(theme.dataText.fontSize, 13);
      expect(theme.dataText.height, 18 / 13);
      expect(theme.controlText.fontSize, 12);
      expect(theme.controlText.height, 16 / 12);
      expect(theme.controlText.fontWeight, FontWeight.w600);
      expect(theme.metaText.fontSize, 11);
      expect(theme.metaText.height, 16 / 11);
      expect(theme.cardTitleText.fontSize, 14);
      expect(theme.cardTitleText.height, 20 / 14);
      expect(theme.projectTitleText.fontSize, 15);
      expect(theme.projectTitleText.height, 20 / 15);
    });

    test('zachowuje rodzinę fontu produktu', () {
      final theme = tasksThemeOf(lightTheme);
      final family = lightTheme.textTheme.bodyLarge?.fontFamily;
      expect(family, isNotNull);
      expect(theme.dataText.fontFamily, family);
      expect(theme.controlText.fontFamily, family);
      expect(theme.metaText.fontFamily, family);
    });
  });

  group('DevPlannerTasksTheme — gęstość i geometria', () {
    test('skala odstępów stoi na siatce 4 px', () {
      final theme = tasksThemeOf(lightTheme);
      for (final gap in [
        theme.tightGap,
        theme.controlGap,
        theme.rowGutter,
        theme.sectionGap,
        theme.blockGap,
      ]) {
        expect(gap % 4, 0, reason: 'Odstęp $gap nie należy do siatki 4 px.');
      }
      expect([
        theme.tightGap,
        theme.controlGap,
        theme.rowGutter,
        theme.sectionGap,
        theme.blockGap,
      ], orderedEquals([4, 8, 12, 16, 24]));
    });

    test('wysokości wierszy mieszczą się w zakresie z planu', () {
      final theme = tasksThemeOf(lightTheme);
      expect(theme.contextRowHeight, inInclusiveRange(44, 48));
      expect(theme.commandRowHeight, inInclusiveRange(36, 40));
      expect(theme.tableHeaderHeight, inInclusiveRange(36, 40));
      expect(theme.tableRowHeight, inInclusiveRange(36, 40));
      expect(theme.tableGroupRowHeight, inInclusiveRange(36, 44));
    });

    test('promienie rozdzielają kontrolki od paneli', () {
      final theme = tasksThemeOf(lightTheme);
      expect(theme.controlRadius, inInclusiveRange(6, 8));
      expect(theme.menuRadius, inInclusiveRange(6, 8));
      expect(theme.panelRadius, 12);
    });
  });

  group('DevPlannerTasksTheme — powierzchnie', () {
    test('bierze powierzchnie i akcent z palety, a nie z lokalnych kolorów', () {
      final theme = tasksThemeOf(lightTheme);
      final colors = lightTheme.colorScheme;
      expect(theme.canvas, colors.surface);
      expect(theme.shadow, colors.shadow);
      expect(theme.scrim, colors.scrim);
      expect(theme.selectionAccent, colors.primary);
      expect(theme.onAccent, colors.onPrimary);
      expect(theme.divider, colors.outlineVariant);
    });

    test('rozróżnia motyw jasny i ciemny', () {
      final light = tasksThemeOf(lightTheme);
      final dark = tasksThemeOf(darkTheme);
      expect(light.canvas, isNot(dark.canvas));
      expect(light.onAccent, isNot(dark.onAccent));
      expect(dark.canvas, darkTheme.colorScheme.surface);
    });

    test('copyWith podmienia pojedynczy token bez ruszania reszty', () {
      final theme = tasksThemeOf(lightTheme);
      final changed = theme.copyWith(tableRowHeight: 44);
      expect(changed.tableRowHeight, 44);
      expect(changed.tableHeaderHeight, theme.tableHeaderHeight);
      expect(changed.canvas, theme.canvas);
    });

    test('lerp przechodzi między motywami w połowie drogi', () {
      final light = tasksThemeOf(lightTheme);
      final dark = tasksThemeOf(darkTheme);
      final middle = light.lerp(dark, .5);
      expect(middle.canvas, Color.lerp(light.canvas, dark.canvas, .5));
      expect(middle.tableRowHeight, closeTo(light.tableRowHeight, .001));
    });
  });
}
