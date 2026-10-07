import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_due_date_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_interaction.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/bulk/task_list_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TasksRepository {
  int writes = 0;
  Completer<Either<ApiError, TaskSelectionTokenResponse>>? tokenPending;
  Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>? pending;

  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) async => Right(
    ProjectTaskGroupedListResponse(
      totalCount: 1,
      groupBy: TaskSavedViewGroupBy.status,
      groups: [
        ProjectTaskListGroupResponse(
          key: 'status:Todo',
          displayName: 'Todo',
          color: '#2563EB',
          position: 0,
          totalCount: 1,
          items: [
            ProjectTaskListItemResponse(
              id: 'task-1',
              number: 1,
              key: 'TASK-1',
              title: 'QA task',
              status: ProjectTaskStatus.todo,
              priority: TaskPriority.normal,
              assignees: const [],
              checklistCompletedCount: 0,
              checklistTotalCount: 0,
              updatedAtUtc: DateTime.utc(2026),
              version: 1,
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Future<Either<ApiError, BulkUpdateTaskSelectionResponse>>
  bulkUpdateTaskSelection({
    required String workspaceId,
    required String projectId,
    required BulkUpdateTaskSelectionPayload payload,
  }) {
    writes++;
    return pending?.future ??
        Future.value(
          const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Rejected test write',
            ),
          ),
        );
  }

  @override
  Future<Either<ApiError, TaskSelectionTokenResponse>>
  createTaskSelectionToken({
    required String workspaceId,
    required String projectId,
    required CreateTaskSelectionTokenPayload payload,
  }) =>
      tokenPending?.future ??
      Future.value(
        Right(
          TaskSelectionTokenResponse(
            token: 'qa-token',
            totalCount: 1,
            expiresAtUtc: DateTime.now().add(const Duration(hours: 1)),
          ),
        ),
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(
  ProjectTasksListCubit cubit, {
  Map<String, ProjectMemberProfile> profiles = const {},
}) => MaterialApp(
  locale: const Locale('en'),
  theme: MaterialTheme.crm().dark(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: TaskListBulkBar(
      listCubit: cubit,
      listState: cubit.state,
      memberProfiles: profiles,
    ),
  ),
);

VoidCallback _activate(WidgetTester tester) => tester
    .widget<TasksBulkButton>(
      find.byKey(const ValueKey('bulk_due_today'), skipOffstage: false),
    )
    .onTap!;

Future<ProjectTasksListCubit> _cubit({_Repository? repository}) async {
  final cubit = ProjectTasksListCubit(
    repository: repository ?? _Repository(),
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    calendarTimeZoneId: 'Europe/Warsaw',
  );
  addTearDown(cubit.close);
  await cubit.load();
  cubit.toggleSelection('task-1');
  return cubit;
}

void main() {
  testWidgets(
    'queued activations and profile rebuild keep one dialog; cancel releases it',
    (tester) async {
      final cubit = await _cubit();
      await tester.pumpWidget(_app(cubit));
      final activate = _activate(tester);
      activate();
      activate();
      await tester.pumpAndSettle();
      expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);

      await tester.pumpWidget(_app(cubit, profiles: {}));
      _activate(tester)();
      await tester.pumpAndSettle();
      expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(TasksBulkDueDateDialog), findsNothing);

      _activate(tester)();
      await tester.pumpAndSettle();
      expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('picker remains single flight through the pending write', (
    tester,
  ) async {
    final repository = _Repository();
    final cubit = await _cubit(repository: repository);
    final pending =
        Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
    repository.pending = pending;
    await tester.pumpWidget(_app(cubit));
    final activate = _activate(tester);
    activate();
    activate();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear due dates in this scope'));
    await tester.pumpAndSettle();
    expect(repository.writes, 1);
    activate();
    await tester.pumpAndSettle();
    expect(find.byType(TasksBulkDueDateDialog), findsNothing);
    pending.complete(
      const Left(
        ApiError(type: ApiErrorType.validation, message: 'Rejected test write'),
      ),
    );
    await tester.pumpAndSettle();
    _activate(tester)();
    await tester.pumpAndSettle();
    expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repository.writes, 1);
  });

  for (final changedSource in [false, true]) {
    testWidgets(
      'old picker cannot write after ${changedSource ? 'source replacement' : 'query change'}',
      (tester) async {
        final repository = _Repository();
        final cubit = await _cubit(repository: repository);
        await tester.pumpWidget(_app(cubit));
        _activate(tester)();
        await tester.pumpAndSettle();
        if (changedSource) {
          await tester.pumpWidget(_app(await _cubit()));
        } else {
          await cubit.load(status: ProjectTaskStatus.todo);
        }
        await tester.tap(find.text('Clear due dates in this scope'));
        await tester.pumpAndSettle();
        expect(repository.writes, 0);
        _activate(tester)();
        await tester.pumpAndSettle();
        expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      },
    );
  }

  for (final duringPrepare in [true, false]) {
    testWidgets(
      'entire-result stops after source replacement during ${duringPrepare ? 'prepare' : 'confirmation'}',
      (tester) async {
        final repository = _Repository();
        final cubit = await _cubit(repository: repository);
        final token = Completer<Either<ApiError, TaskSelectionTokenResponse>>();
        if (duringPrepare) repository.tokenPending = token;
        await tester.pumpWidget(_app(cubit));
        final menu = tester.widget<TasksBulkMenu<String>>(
          find.byKey(const ValueKey('bulk_entire_result')),
        );
        menu.onSelected('due_today');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Clear due dates in this scope'));
        await tester.pumpAndSettle();
        await tester.pumpWidget(_app(await _cubit()));
        if (duringPrepare) {
          token.complete(
            Right(
              TaskSelectionTokenResponse(
                token: 'qa-token',
                totalCount: 1,
                expiresAtUtc: DateTime.now().add(const Duration(hours: 1)),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('Save'), findsNothing);
        } else {
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();
        }
        expect(repository.writes, 0);
        _activate(tester)();
        await tester.pumpAndSettle();
        expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      },
    );
  }

  testWidgets(
    'nested calendar rejects queued activation and can reopen after Escape',
    (tester) async {
      final cubit = await _cubit();
      await tester.pumpWidget(_app(cubit));
      _activate(tester)();
      await tester.pumpAndSettle();
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      button.onPressed!();
      button.onPressed!();
      await tester.pumpAndSettle();
      expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(CompactWebDatePickerPanel), findsNothing);
      expect(find.byType(TasksBulkDueDateDialog), findsOneWidget);
      button.onPressed!();
      await tester.pumpAndSettle();
      expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'failed interaction propagates error and allows a new operation',
    () async {
      final interaction = TasksBulkInteraction();
      await expectLater(
        interaction.run(() async => throw StateError('failed')),
        throwsStateError,
      );
      var calls = 0;
      await interaction.run(() async => calls++);
      expect(calls, 1);
    },
  );
}
