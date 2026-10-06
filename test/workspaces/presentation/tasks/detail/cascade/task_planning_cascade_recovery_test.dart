import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_properties_planning.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../test_support/task_detail_visual_fixture.dart';

final class _TasksRepository extends Mock implements TasksRepository {}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

final class _UpdatePayload extends Fake implements UpdateProjectTaskPayload {}

final class _ScheduleRepository implements TaskScheduleRepository {
  _ScheduleRepository({this.firstSchedule = false});
  final bool firstSchedule;
  final pendingApply = Completer<Either<ApiError, ScheduleCascadeResponse>>();
  int applyCount = 0;
  late final preview = ScheduleCascadeResponse(
    dateShifts: [
      TaskDateShiftResponse(
        taskId: visualTaskId,
        title: 'Planowane zadanie',
        currentStartAtUtc: firstSchedule ? null : DateTime.utc(2026, 9, 28),
        currentDueAtUtc: firstSchedule ? null : DateTime.utc(2026, 10, 8),
        proposedStartAtUtc: DateTime.utc(2026, 9, 28),
        proposedDueAtUtc: DateTime.utc(2026, 10, 8),
        shiftWorkingDays: 0,
        isOnCriticalPath: false,
        expectedVersion: 1,
      ),
    ],
    criticalPathTaskIds: const [],
    totalProjectWorkingDays: 1,
    taskFloats: const [],
  );

  @override
  Future<Either<ApiError, ScheduleCascadeResponse>> previewCascade({
    required String workspaceId,
    required String projectId,
    required PreviewScheduleCascadePayload payload,
  }) async => Right(preview);

  @override
  Future<Either<ApiError, ScheduleCascadeResponse>> applyCascade({
    required String workspaceId,
    required String projectId,
    required ApplyScheduleCascadePayload payload,
  }) {
    applyCount++;
    return pendingApply.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() => registerFallbackValue(_UpdatePayload()));
  for (final mode in ['unchanged', 'success', 'recovery']) {
    final failFirstEstimate = mode == 'recovery';
    final estimateChanged = mode != 'unchanged';
    testWidgets(
      'cascade preserves estimate intent before close; $mode',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final initial = visualTaskDetails(TaskDetailVisualMode.editable);
        final tasks = _TasksRepository();
        final cubit = TaskDetailsCubit(
          repository: tasks,
          acceptanceCriteriaRepository: _AcceptanceRepository(),
          checklistRepository: _ChecklistRepository(),
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          taskId: visualTaskId,
        );
        cubit.emit(TaskDetailsReady(initial));
        addTearDown(cubit.close);
        final repository = _ScheduleRepository(
          firstSchedule: failFirstEstimate,
        );
        var loadCount = 0;
        var estimateSaves = 0;
        when(
          () => tasks.getTask(
            workspaceId: visualWorkspaceId,
            projectId: visualProjectId,
            taskId: visualTaskId,
          ),
        ).thenAnswer((_) async {
          loadCount++;
          return Right(
            initial.copyWith(
              task: initial.task.copyWith(
                startAtUtc: DateTime.utc(2026, 9, 29),
                dueAtUtc: DateTime.utc(2026, 10, 9),
                version: 20 + loadCount,
                estimatedMinutes: estimateChanged
                    ? initial.task.estimatedMinutes
                    : 900,
              ),
            ),
          );
        });
        when(
          () => tasks.updateTask(
            workspaceId: visualWorkspaceId,
            projectId: visualProjectId,
            taskId: visualTaskId,
            payload: any(named: 'payload'),
          ),
        ).thenAnswer((invocation) async {
          final payload =
              invocation.namedArguments[#payload] as UpdateProjectTaskPayload;
          expect(payload.expectedVersion, 20 + loadCount);
          expect(payload.startAtUtc, DateTime.utc(2026, 9, 29));
          expect(payload.dueAtUtc, DateTime.utc(2026, 10, 9));
          expect(payload.estimatedMinutes, 600);
          estimateSaves++;
          if (failFirstEstimate && estimateSaves == 1) {
            return const Left(
              ApiError(
                type: ApiErrorType.connection,
                message: 'Estimate save failed.',
              ),
            );
          }
          final currentTask = (cubit.state as TaskDetailsReady).details.task;
          final updated = currentTask.copyWith(
            estimatedMinutes: 600,
            version: currentTask.version + 1,
          );
          return Right(
            TaskMutationResponse(
              taskId: visualTaskId,
              taskVersion: updated.version,
              taskUpdatedAtUtc: DateTime.utc(2026, 10, 6),
              data: updated,
            ),
          );
        });
        await tester.pumpWidget(
          MaterialApp(
            theme: MaterialTheme.crm().dark(),
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) =>
                RepositoryProvider<TaskScheduleRepository>.value(
                  value: repository,
                  child: BlocProvider<TaskDetailsCubit>.value(
                    value: cubit,
                    child: child,
                  ),
                ),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => EditPlanningDialog(task: initial.task),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        if (estimateChanged) {
          await tester.enterText(find.byType(TextField), '600');
        } else {
          await tester.tap(find.byType(TextField));
        }
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.textContaining('Obecnie:'), findsOneWidget);
        expect(find.textContaining('Po zmianie:'), findsOneWidget);
        if (failFirstEstimate) {
          expect(find.textContaining('Brak daty – Brak daty'), findsOneWidget);
        }
        await tester.tap(find.text('Zastosuj kaskadę'));
        await tester.pump();
        expect(
          tester.widget<TextField>(find.byType(TextField)).enabled,
          isFalse,
        );
        expect(
          tester
              .widgetList<DateField>(find.byType(DateField))
              .every((field) => !field.enabled),
          isTrue,
        );
        expect(estimateSaves, 0);
        repository.pendingApply.complete(Right(repository.preview));
        await tester.pumpAndSettle();
        expect(estimateSaves, estimateChanged ? 1 : 0);
        if (!estimateChanged) {
          expect(
            (cubit.state as TaskDetailsReady).details.task.estimatedMinutes,
            900,
          );
        }
        if (failFirstEstimate) {
          expect(find.byType(EditPlanningDialog), findsOneWidget);
          expect(
            tester.widget<TextField>(find.byType(TextField)).controller!.text,
            '600',
          );
          expect(
            tester
                .widgetList<DateField>(find.byType(DateField))
                .every((field) => !field.enabled),
            isTrue,
          );
          expect(
            find.textContaining('Terminy zostały zapisane'),
            findsOneWidget,
          );
          await tester.tap(find.text('Zapisz'));
          await tester.pumpAndSettle();
          expect(estimateSaves, 2);
          expect(loadCount, 2);
        }
        expect(repository.applyCount, 1);
        expect(find.byType(EditPlanningDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
