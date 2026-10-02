import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/templates/task_template_copy_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../test_support/task_detail_visual_fixture.dart';

void main() {
  test('preview counts saved custom values rather than empty definitions', () {
    final source = visualTaskDetails(TaskDetailVisualMode.editable);
    final field = source.customFields.first;
    final details = source.copyWith(
      customFields: [
        field.copyWith(value: null, valueUpdatedAtUtc: null),
        field.copyWith(value: null, valueUpdatedAtUtc: DateTime.utc(2026)),
        field.copyWith(value: 'Saved', valueUpdatedAtUtc: DateTime.utc(2026)),
      ],
    );
    final preview = TaskTemplateCopyPreviewData.fromDetails(details);
    expect(preview.key, details.task.key);
    expect(preview.customValues, 2);
    expect(preview.assignees, details.task.assignees.length);
    expect(preview.checklist, details.task.checklistItems.length);
    expect(preview.criteria, details.acceptanceCriteria.length);
    expect(preview.labels, details.labels.length);
  });

  for (final locale in ['pl', 'en']) {
    for (final dark in [false, true]) {
      testWidgets('copy scope remains readable at 200%: $locale/$dark', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(420, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final source = visualTaskDetails(TaskDetailVisualMode.editable);
        final preview = TaskTemplateCopyPreviewData.fromDetails(source);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark
                ? MaterialTheme.crm().dark()
                : MaterialTheme.crm().light(),
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
              ),
              child: child!,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TaskTemplateCopyPreview(data: preview),
                ),
              ),
            ),
          ),
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(TaskTemplateCopyPreview)),
        )!;
        expect(find.text(l10n.taskTemplateCopyHeading), findsOneWidget);
        expect(find.text(l10n.taskTemplateCopyExcluded), findsOneWidget);
        expect(find.text(l10n.taskTemplateCopySavedVersion), findsOneWidget);
        expect(find.text(source.task.title), findsNothing);
        expect(
          find.byKey(const ValueKey('task_template_copy_counts')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
