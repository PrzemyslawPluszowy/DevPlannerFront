import 'dart:math' as math;

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    for (final priority in TaskPriority.values) {
      testWidgets('${priority.name} readable in ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        final theme = dark
            ? MaterialTheme.crm().dark()
            : MaterialTheme.crm().light();
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: Center(
                child: TaskCellPriority(
                  priority: priority,
                  onChanged: (_) async => true,
                ),
              ),
            ),
          ),
        );
        final cell = find.byType(TaskCellPriority);
        final textFinder = find.descendant(
          of: cell,
          matching: find.byType(Text),
        );
        expect(
          tester
              .renderObject<RenderParagraph>(
                find.descendant(
                  of: textFinder,
                  matching: find.byType(RichText),
                ),
              )
              .didExceedMaxLines,
          isFalse,
        );
        final text = tester.widget<Text>(textFinder);
        final badge = tester.widget<DecoratedBox>(
          find.descendant(of: cell, matching: find.byType(DecoratedBox)),
        );
        final decoration = badge.decoration as BoxDecoration;
        final background = Color.alphaBlend(
          decoration.color!,
          theme.colorScheme.surface,
        );
        final a = text.style!.color!.computeLuminance();
        final b = background.computeLuminance();
        expect(
          (math.max(a, b) + .05) / (math.min(a, b) + .05),
          greaterThanOrEqualTo(4.5),
        );
      });
    }
  }
}
