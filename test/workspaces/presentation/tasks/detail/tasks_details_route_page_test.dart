import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/tasks_details_route_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksMock extends Mock implements TasksRepository {}

final class _AcceptanceMock extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _AttachmentMock extends Mock implements TaskAttachmentRepository {}

final class _ChecklistMock extends Mock implements TaskChecklistRepository {}

final class _CollaborationMock extends Mock
    implements TaskCollaborationRepository {}

final class _HistoryMock extends Mock implements TaskHistoryRepository {}

final class _MetadataMock extends Mock implements TaskMetadataRepository {}

final class _RecurrenceMock extends Mock implements TaskRecurrenceRepository {}

final class _ScheduleMock extends Mock implements TaskScheduleRepository {}

final class _TemplateMock extends Mock implements TaskTemplateRepository {}

final class _TimeTrackingMock extends Mock
    implements TaskTimeTrackingRepository {}

final class _MilestoneMock extends Mock implements MilestoneRepository {}

final class _StorageMock extends Mock implements StorageRepository {}

final class _AttachmentUploadMock extends Mock
    implements TaskAttachmentUploadTransport {}

const _workspaceId = '550e8400-e29b-41d4-a716-446655440000';
const _projectId = '550e8400-e29b-41d4-a716-446655440001';
const _taskId = '550e8400-e29b-41d4-a716-446655440002';

TasksDetailsComposition _composition(TasksRepository tasks) =>
    TasksDetailsComposition(
      tasksRepository: tasks,
      acceptanceCriteriaRepository: _AcceptanceMock(),
      attachmentRepository: _AttachmentMock(),
      checklistRepository: _ChecklistMock(),
      collaborationRepository: _CollaborationMock(),
      historyRepository: _HistoryMock(),
      metadataRepository: _MetadataMock(),
      recurrenceRepository: _RecurrenceMock(),
      scheduleRepository: _ScheduleMock(),
      templateRepository: _TemplateMock(),
      timeTrackingRepository: _TimeTrackingMock(),
      milestoneRepository: _MilestoneMock(),
      storageRepository: _StorageMock(),
      attachmentUploadTransport: _AttachmentUploadMock(),
    );

Widget _localized(Widget child) => MaterialApp(
  locale: const Locale('pl'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  testWidgets('desktop details route composes typed UI and starts loading', (
    tester,
  ) async {
    final tasks = _TasksMock();
    final pending = Completer<void>();
    when(
      () => tasks.getTask(
        workspaceId: _workspaceId,
        projectId: _projectId,
        taskId: _taskId,
      ),
    ).thenAnswer((_) async {
      await pending.future;
      return const Left(
        ApiError(type: ApiErrorType.canceled, message: 'test'),
      );
    });

    await tester.pumpWidget(
      _localized(
        TasksDetailsRoutePage(
          composition: _composition(tasks),
          workspaceId: _workspaceId,
          projectId: _projectId,
          taskId: _taskId,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(
      () => tasks.getTask(
        workspaceId: _workspaceId,
        projectId: _projectId,
        taskId: _taskId,
      ),
    ).called(1);
    pending.complete();
  });

  testWidgets('router rejects invalid task identifiers without composing API', (
    tester,
  ) async {
    final auth = AuthComposition.unavailable();
    auth.session.setSignedIn(
      const AuthUser(userId: 'u-1', login: 'user', displayName: 'User'),
    );
    final router = DevPlannerRouter(
      auth: auth,
      initialLocation:
          '/workspaces/not-a-uuid/projects/$_projectId/tasks/$_taskId',
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router.config,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsNWidgets(2));
  });

  test('BFF transport cannot compose task details', () {
    final composition = TasksDetailsComposition.fromTransport(
      DevPlannerHttpTransport(dio: Dio(), isWeb: true),
    );
    expect(composition, isNull);
  });
}
