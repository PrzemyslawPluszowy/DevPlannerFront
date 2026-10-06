import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_action_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_detail_people_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_detail_person.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_labels.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_edit_assignees_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/project_settings_fixture.dart';
import '../../../../test_support/task_detail_visual_fixture.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Acceptance extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _Checklist extends Mock implements TaskChecklistRepository {}

final class _Profiles extends Mock implements ProjectMemberProfilesRepository {}

final class _Metadata extends Mock implements TaskMetadataRepository {}

TaskDetailsCubit _cubit(_Metadata metadata) {
  final cubit = TaskDetailsCubit(
    repository: _Tasks(),
    acceptanceCriteriaRepository: _Acceptance(),
    checklistRepository: _Checklist(),
    metadataRepository: metadata,
    workspaceId: visualWorkspaceId,
    projectId: visualProjectId,
    taskId: visualTaskId,
  );
  cubit.emit(
    TaskDetailsReady(visualTaskDetails(TaskDetailVisualMode.editable)),
  );
  return cubit;
}

Widget _app(Widget editor, TaskDetailsCubit cubit, {_Profiles? profiles}) =>
    MaterialApp(
      theme: MaterialTheme.crm().light(),
      locale: const Locale('pl'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (_, child) =>
          RepositoryProvider<ProjectMemberProfilesRepository>.value(
            value: profiles ?? _Profiles(),
            child: BlocProvider.value(value: cubit, child: child),
          ),
      home: Scaffold(body: editor),
    );
FilledButton _save(WidgetTester tester) =>
    tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Zapisz'));

void main() {
  testWidgets(
    'assignee role labels, prepared search and choices survive filtering',
    (tester) async {
      final metadata = _Metadata();
      final cubit = _cubit(metadata);
      addTearDown(cubit.close);
      final profiles = _Profiles();
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer(
        (_) async => Right([
          for (final role in ProjectRole.values)
            ProjectMemberProfile(
              userId: 'person-${role.name}',
              role: role,
              displayName: 'Osoba ${role.name}',
            ),
        ]),
      );
      final original = visualTaskDetails(TaskDetailVisualMode.editable).task
          .copyWith(assignees: const []);
      await tester.pumpWidget(
        _app(EditAssigneesDialog(task: original), cubit, profiles: profiles),
      );
      await tester.pumpAndSettle();
      for (final role in [
        'Właściciel',
        'Administrator',
        'Członek',
        'Obserwator',
      ]) {
        expect(find.text(role), findsOneWidget);
      }
      expect(_save(tester).onPressed, isNull);
      await tester.tap(find.text('Osoba owner'));
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNotNull);
      final searchPosition = tester.getTopLeft(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'observer');
      await tester.pumpAndSettle();
      expect(find.text('Osoba owner'), findsNothing);
      expect(tester.getTopLeft(find.byType(TextField)), searchPosition);
      await tester.tap(find.text('Osoba observer'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'none');
      await tester.pumpAndSettle();
      expect(
        find.text('Nie znaleziono osób. Zmień wyszukiwany tekst.'),
        findsOneWidget,
      );
      expect(_save(tester).onPressed, isNotNull);
      expect(tester.getTopLeft(find.byType(TextField)), searchPosition);
      expect(
        find.text('Zaznaczono: 2. Poza aktualnym filtrem: 2.'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
            .where((tile) => tile.value == true)
            .length,
        2,
      );
    },
  );
  testWidgets(
    'member loading and error never enable save; retry restores readystate',
    (tester) async {
      final metadata = _Metadata();
      final cubit = _cubit(metadata);
      addTearDown(cubit.close);
      final profiles = _Profiles();
      final pending = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer((_) => pending.future);
      await tester.pumpWidget(
        _app(
          EditAssigneesDialog(
            task: visualTaskDetails(TaskDetailVisualMode.editable).task,
          ),
          cubit,
          profiles: profiles,
        ),
      );
      await tester.pump();
      expect(_save(tester).onPressed, isNull);
      pending.complete(
        const Left(
          ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
        ),
      );
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNull);
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer((_) async => const Right([]));
      await tester.tap(find.text('Ponów próbę'));
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNull);
    },
  );
  testWidgets(
    'empty labels explain setup; unchanged selection blocked and existing labels removable',
    (tester) async {
      final metadata = _Metadata();
      final cubit = _cubit(metadata);
      addTearDown(cubit.close);
      when(
        () => metadata.listLabels(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer((_) async => const Right([]));
      await tester.pumpWidget(
        _app(const EditLabelsDialog(selected: []), cubit),
      );
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNull);
      expect(find.textContaining('Administrator projektu'), findsOneWidget);
      expect(find.text('Zarządzaj etykietami'), findsNothing);
      final label = TaskLabelResponse(
        id: 'label1',
        name: 'QA',
        color: '#2563EB',
        createdAtUtc: DateTime.utc(2026),
      );
      when(
        () => metadata.listLabels(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer((_) async => Right([label]));
      await tester.pumpWidget(
        _app(
          EditLabelsDialog(
            key: const ValueKey('with-label'),
            selected: [label],
          ),
          cubit,
        ),
      );
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNull);
      await tester.tap(find.text('QA'));
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNotNull);
      await tester.tap(find.text('QA'));
      await tester.pumpAndSettle();
      expect(_save(tester).onPressed, isNull);
    },
  );
  testWidgets(
    'settings action requires server capability; lookup failure is visible and retryable',
    (tester) async {
      final metadata = _Metadata();
      final cubit = _cubit(metadata);
      addTearDown(cubit.close);
      when(
        () => metadata.listLabels(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer((_) async => const Right([]));
      final project = ProjectSettingsFixture.defaultProject.copyWith(
        id: visualProjectId,
        workspaceId: visualWorkspaceId,
        myRole: ProjectRole.owner,
        capabilities: ProjectActionCapabilities.none,
      );
      final fixture = ProjectSettingsFixture(project: project);
      await tester.pumpWidget(
        _app(
          EditLabelsDialog(
            selected: const [],
            settingsComposition: fixture.composition,
          ),
          cubit,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Zarządzaj etykietami'), findsNothing);
      // Następny dialog sprawdza błąd odczytu uprawnień bez blokowania etykiet.
      when(
        () => fixture.projects.getProject(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.connection,
            message: 'Brak uprawnień z serwera',
          ),
        ),
      );
      await tester.pumpWidget(
        _app(
          EditLabelsDialog(
            key: const ValueKey('error'),
            selected: const [],
            settingsComposition: fixture.composition,
          ),
          cubit,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Zarządzaj etykietami'), findsNothing);
      expect(find.textContaining('Brak uprawnień z serwera'), findsWidgets);
      when(
        () => fixture.projects.getProject(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer(
        (_) async => Right(
          project.copyWith(
            capabilities: const ProjectActionCapabilities(canManage: true),
          ),
        ),
      );
      await tester.tap(find.text('Ponów próbę'));
      await tester.pumpAndSettle();
      expect(find.text('Zarządzaj etykietami'), findsOneWidget);
      expect(_save(tester).onPressed, isNull);
      await tester.tap(find.text('Zarządzaj etykietami'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectSettingsModal), findsOneWidget);
      final refreshedLabel = TaskLabelResponse(
        id: 'new-label',
        name: 'Nowa etykieta',
        color: '#2563EB',
        createdAtUtc: DateTime.utc(2026),
      );
      when(
        () => metadata.listLabels(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer((_) async => Right([refreshedLabel]));
      when(
        () => fixture.projects.getProject(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Nie masz już dostępu do ustawień.',
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(ProjectSettingsModal), findsNothing);
      expect(find.text('Nowa etykieta'), findsOneWidget);
      expect(find.text('Zarządzaj etykietami'), findsNothing);
      expect(
        find.textContaining('Nie masz już dostępu do ustawień.'),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'person catalog replaces missing included name; refresh error keeps cached name and no UUID',
    (tester) async {
      final cubit = _cubit(_Metadata());
      addTearDown(cubit.close);
      final profiles = _Profiles();
      final pending = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          forceRefresh: true,
        ),
      ).thenAnswer((_) => pending.future);
      const userId = '97801f51-ccbc-4b72-aab0-6a88b81d9368';
      final available = ValueNotifier(true);
      final panels = DevPlannerPanelsController();
      addTearDown(available.dispose);
      addTearDown(panels.dispose);
      await tester.pumpWidget(
        _app(
          DevPlannerPanelsScope(
            controller: panels,
            openConversation: (_) {},
            presenceAvailability: available,
            child: TaskDetailPeopleScope(
              child: Builder(
                builder: (context) => Column(
                  children: [
                    const TaskDetailPerson(userId: userId, showName: true),
                    TextButton(
                      onPressed: () =>
                          TaskDetailPeopleScope.maybeOf(context)!.refresh(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          cubit,
          profiles: profiles,
        ),
      );
      await tester.pump();
      expect(find.text(userId), findsNothing);
      expect(find.text('Członek projektu'), findsOneWidget);
      pending.complete(
        const Right([
          ProjectMemberProfile(
            userId: userId,
            role: ProjectRole.member,
            displayName: 'Jan Nowak',
            isOnline: true,
          ),
        ]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Jan Nowak'), findsOneWidget);
      expect(find.byTooltip('Online'), findsOneWidget);
      available.value = false;
      await tester.pump();
      expect(find.byTooltip('Online'), findsNothing);
      expect(find.byTooltip('Brak aktualnego statusu'), findsOneWidget);
      available.value = true;
      await tester.pump();
      expect(find.byTooltip('Online'), findsOneWidget);
      final refresh = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          forceRefresh: true,
        ),
      ).thenAnswer((_) => refresh.future);
      await tester.tap(find.text('Refresh'));
      await tester.pump();
      expect(find.text('Jan Nowak'), findsOneWidget);
      refresh.complete(
        const Left(ApiError(type: ApiErrorType.connection, message: 'offline')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Jan Nowak'), findsOneWidget);
      expect(find.text(userId), findsNothing);
      expect(find.text('Nie udało się odświeżyć danych osób.'), findsOneWidget);
      expect(find.text('Ponów próbę'), findsOneWidget);
      expect(find.byTooltip('Online'), findsNothing);
      expect(find.byTooltip('Brak aktualnego statusu'), findsOneWidget);
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          forceRefresh: true,
        ),
      ).thenAnswer(
        (_) async => const Right([
          ProjectMemberProfile(
            userId: userId,
            role: ProjectRole.member,
            displayName: 'Jan Nowak',
            isOnline: false,
          ),
        ]),
      );
      await tester.tap(find.text('Ponów próbę'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Offline'), findsOneWidget);
      when(
        () => profiles.listProfiles(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
          forceRefresh: true,
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(type: ApiErrorType.forbidden, message: 'revoke'),
        ),
      );
      await tester.tap(find.text('Refresh'));
      await tester.pumpAndSettle();
      expect(find.text('Jan Nowak'), findsNothing);
      expect(find.text('Członek projektu'), findsOneWidget);
      verify(
        () => profiles.invalidate(
          workspaceId: visualWorkspaceId,
          projectId: visualProjectId,
        ),
      ).called(1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
