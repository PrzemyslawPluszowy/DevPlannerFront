import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';

void main() {
  testWidgets('przekazuje wybór statusu bez lokalnego stanu domenowego', (
    tester,
  ) async {
    TaskSavedViewGroupBy? selected;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListWorkflowSegmentedSwitch(
            selected: TaskSavedViewGroupBy.customStatus,
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Symbols.grid_view_rounded));

    expect(selected, TaskSavedViewGroupBy.status);
  });
}
