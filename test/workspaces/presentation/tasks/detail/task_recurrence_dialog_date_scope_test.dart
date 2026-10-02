import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/task_detail_visual_fixture.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Criteria extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _Checklist extends Mock implements TaskChecklistRepository {}

final class _Recurrence extends Mock implements TaskRecurrenceRepository {}

void main() {
  testWidgets('kalendarz cyklu w rootowym dialogu zachowuje ownera zadania', (
    tester,
  ) async {
    final task = visualTaskDetails(TaskDetailVisualMode.editable).task
        .copyWith(recurrence: null);
    final details = TaskDetailsCubit(
      repository: _Tasks(),
      acceptanceCriteriaRepository: _Criteria(),
      checklistRepository: _Checklist(),
      workspaceId: task.workspaceId,
      projectId: task.projectId,
      taskId: task.id,
    );
    final recurrence = _Recurrence();
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().light(),
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [BlocProvider.value(value: details)],
          child: RepositoryProvider<TaskRecurrenceRepository>.value(
            value: recurrence,
            child: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => unawaited(
                    TaskRecurrenceDialogLauncher.show(context, task),
                  ),
                  child: const Text('Configure'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Configure'));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(TaskRecurrenceDialog)),
    )!;
    await tester.tap(find.byTooltip(l10n.taskDetailsRecurrenceFirstOccurrence));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await details.close();
  });
}
