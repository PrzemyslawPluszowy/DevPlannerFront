import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'empty and whitespace title show error and return focus without creating',
    (tester) async {
      var calls = 0;
      String? receivedTitle;
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskQuickCreateDialog(
              columns: const [
                KanbanColumnResponse(
                  status: ProjectTaskStatus.todo,
                  displayName: 'Do zrobienia',
                  color: '#2563EB',
                  totalTaskCount: 0,
                  isWipLimitExceeded: false,
                  tasks: [],
                ),
              ],
              onCreate:
                  ({
                    required title,
                    required column,
                    taskTemplateId,
                    useDefaultTemplate = true,
                  }) async {
                    calls++;
                    receivedTitle = title;
                    return false;
                  },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Nadaj zadaniu tytuł i wybierz jego początkowy status.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(find.text('Wprowadź tytuł zadania'), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode!.hasFocus, isTrue);
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      await tester.enterText(find.byType(TextField), '  Przegląd projektu  ');
      await tester.pump();
      expect(find.text('Wprowadź tytuł zadania'), findsNothing);
      await tester.tap(find.text('Utwórz'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(receivedTitle, 'Przegląd projektu');
      expect(tester.takeException(), isNull);
    },
  );
}
