import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_toolbar.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/task_detail_visual_fixture.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Acceptance extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _Checklist extends Mock implements TaskChecklistRepository {}

final class _Payload extends Fake implements UpdateProjectTaskPayload {}

Widget _app(Widget home, {TaskDetailsCubit? cubit, String locale = 'pl'}) =>
    MaterialApp(
      theme: MaterialTheme.crm().dark(),
      locale: Locale(locale),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        quill.FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => cubit == null
          ? child!
          : BlocProvider.value(value: cubit, child: child),
      home: Scaffold(body: home),
    );

void main() {
  setUpAll(() => registerFallbackValue(_Payload()));
  for (final locale in ['pl', 'en']) {
    testWidgets('description toolbar locale $locale stays scoped', (
      tester,
    ) async {
      final controller = quill.QuillController.basic();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _app(TaskDescriptionToolbar(controller: controller), locale: locale),
      );
      await tester.pumpAndSettle();
      for (final label
          in locale == 'pl'
              ? [
                  'Cofnij',
                  'Ponów',
                  'Pogrubienie',
                  'Kursywa',
                  'Podkreślenie',
                  'Przekreślenie',
                  'Indeks dolny',
                  'Indeks górny',
                  'Kolor tekstu',
                  'Kolor tła',
                  'Usuń formatowanie',
                  'Styl nagłówka',
                  'Lista numerowana',
                  'Lista punktowana',
                  'Lista kontrolna',
                  'Cytat',
                  'Zwiększ wcięcie',
                  'Zmniejsz wcięcie',
                  'Wstaw link',
                ]
              : ['Undo', 'Redo', 'Bold', 'Italic', 'Insert link']) {
        expect(find.byTooltip(label), findsOneWidget);
      }
      final context = tester.element(find.byType(TaskDescriptionToolbar));
      expect(quill.FlutterQuillLocalizations.of(context)!.bold, 'Bold');
    });
  }
  testWidgets('same mounted preview refreshes Delta and plain-text fallback', (
    tester,
  ) async {
    final original = visualTaskDetails(TaskDetailVisualMode.editable).task
        .copyWith(description: '', descriptionDeltaJson: null);
    final task = ValueNotifier(original);
    addTearDown(task.dispose);
    await tester.pumpWidget(
      _app(
        ValueListenableBuilder<ProjectTaskResponse>(
          valueListenable: task,
          builder: (_, current, _) => TaskDescriptionPreview(task: current),
        ),
      ),
    );
    expect(find.byType(quill.QuillEditor), findsNothing);
    task.value = original.copyWith(
      description: 'nowy opis',
      descriptionDeltaJson: jsonEncode([
        {
          'insert': 'nowy opis',
          'attributes': {'bold': true},
        },
        {'insert': '\n'},
      ]),
    );
    await tester.pumpAndSettle();
    final controller = tester
        .widget<quill.QuillEditor>(find.byType(quill.QuillEditor))
        .controller;
    expect(controller.document.toPlainText(), 'nowy opis\n');
    expect(controller.document.toDelta().toJson().first['attributes'], {
      'bold': true,
    });
    task.value = original.copyWith(
      description: 'zdalny opis',
      descriptionDeltaJson: null,
    );
    await tester.pumpAndSettle();
    expect(controller.document.toPlainText(), 'zdalny opis\n');
    task.value = original;
    await tester.pumpAndSettle();
    expect(find.byType(quill.QuillEditor), findsNothing);
  });

  testWidgets(
    'Ready mutation refreshes preview; save locks input and failed save retains editable draft',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final initial = visualTaskDetails(TaskDetailVisualMode.editable);
      final tasks = _Tasks();
      final cubit = TaskDetailsCubit(
        repository: tasks,
        acceptanceCriteriaRepository: _Acceptance(),
        checklistRepository: _Checklist(),
        workspaceId: visualWorkspaceId,
        projectId: visualProjectId,
        taskId: visualTaskId,
      );
      cubit.emit(TaskDetailsReady(initial));
      addTearDown(cubit.close);
      var pending =
          Completer<
            Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>
          >();
      UpdateProjectTaskPayload? captured;
      when(
        () => tasks.updateTask(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          taskId: visualTaskId,
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((invocation) {
        captured =
            invocation.namedArguments[#payload] as UpdateProjectTaskPayload;
        return pending.future;
      });
      await tester.pumpWidget(
        _app(
          BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
            builder: (_, state) => TaskDescriptionSection(
              task: (state as TaskDetailsReady).details.task,
              isSaving: state.isSaving,
            ),
          ),
          cubit: cubit,
        ),
      );
      await tester.tap(find.byTooltip('Edytuj opis'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Cofnij'), findsOneWidget);
      expect(find.byTooltip('Pogrubienie'), findsOneWidget);
      expect(find.byTooltip('Wstaw link'), findsOneWidget);
      expect(find.byTooltip('Bold'), findsNothing);
      final editor = tester
          .widgetList<quill.QuillEditor>(find.byType(quill.QuillEditor))
          .last;
      editor.controller.replaceText(
        0,
        editor.controller.document.length - 1,
        'szkic QA',
        const TextSelection.collapsed(offset: 8),
      );
      await tester.pumpAndSettle();
      final delta = jsonEncode(editor.controller.document.toDelta().toJson());
      await tester.tap(find.text('Zapisz'));
      await tester.pump();
      expect(editor.controller.readOnly, isTrue);
      expect(editor.focusNode.hasFocus, isFalse);
      expect(
        find.ancestor(
          of: find.byType(quill.QuillSimpleToolbar),
          matching: find.byWidgetPredicate(
            (w) => w is AbsorbPointer && w.absorbing,
          ),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Pogrubienie'), warnIfMissed: false);
      await tester.pump();
      expect(jsonEncode(editor.controller.document.toDelta().toJson()), delta);
      pending.complete(
        const Left(
          ApiError(
            type: ApiErrorType.connection,
            message: 'Zapis nie powiódł się.',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(editor.controller.readOnly, isFalse);
      expect(editor.focusNode.hasFocus, isTrue);
      expect(editor.controller.document.toPlainText(), 'szkic QA\n');
      pending = Completer();
      await tester.tap(find.text('Zapisz'));
      await tester.pump();
      final updated = initial.task.copyWith(
        description: 'szkic QA\n',
        descriptionDeltaJson: delta,
        version: initial.task.version + 1,
      );
      pending.complete(
        Right(
          TaskMutationResponse(
            taskId: visualTaskId,
            taskVersion: updated.version,
            taskUpdatedAtUtc: DateTime.utc(2026, 10, 6),
            data: updated,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EditTaskDescriptionDialog), findsNothing);
      expect(captured?.description, 'szkic QA');
      expect(captured?.descriptionDeltaJson, delta);
      final preview = tester.widget<quill.QuillEditor>(
        find.byType(quill.QuillEditor),
      );
      expect(preview.controller.document.toPlainText(), 'szkic QA\n');
    },
  );
}
