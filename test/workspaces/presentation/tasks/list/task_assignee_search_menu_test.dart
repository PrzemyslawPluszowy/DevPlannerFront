import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_search_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _ProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

void main() {
  testWidgets('first page failure stays visible and retry loads profiles', (
    tester,
  ) async {
    final repository = _ProfilesRepository();
    const error = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Member access is unavailable.',
      contractCode: 'project_members_forbidden',
      traceId: 'assignee-trace',
    );
    var calls = 0;
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async {
      calls++;
      if (calls == 1) return const Left(error);
      return Right(_page([_profile('member-1', 'Ala')]));
    });
    await _pumpMenu(tester, _loader(repository));

    expect(find.text('Member access is unavailable.'), findsOneWidget);
    expect(find.textContaining('project_members_forbidden'), findsOneWidget);
    expect(find.textContaining('assignee-trace'), findsOneWidget);
    expect(find.text('No project members are available.'), findsNothing);
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));

    expect(find.text('Ala'), findsOneWidget);
    expect(find.text('Member access is unavailable.'), findsNothing);
    expect(calls, 2);
  });

  testWidgets('older query and pending response after close are ignored', (
    tester,
  ) async {
    final repository = _ProfilesRepository();
    final oldSearch = Completer<Either<ApiError, ProjectMemberProfilePage>>();
    final latestSearch =
        Completer<Either<ApiError, ProjectMemberProfilePage>>();
    final closedSearch =
        Completer<Either<ApiError, ProjectMemberProfilePage>>();
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async => Right(_page(const [])));
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        search: 'al',
      ),
    ).thenAnswer((_) => oldSearch.future);
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        search: 'ali',
      ),
    ).thenAnswer((_) => latestSearch.future);
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        search: 'closed',
      ),
    ).thenAnswer((_) => closedSearch.future);
    final loader = _loader(repository);
    await _pumpMenu(tester, loader);
    await tester.enterText(find.byType(TextField), 'al');
    await tester.pump(const Duration(milliseconds: 221));
    await tester.enterText(find.byType(TextField), 'ali');
    await tester.pump(const Duration(milliseconds: 221));
    latestSearch.complete(Right(_page([_profile('latest', 'Alice')])));
    await tester.pump();
    oldSearch.complete(Right(_page([_profile('old', 'Alina')])));
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Alina'), findsNothing);
    await tester.enterText(find.byType(TextField), 'closed');
    await tester.pump(const Duration(milliseconds: 221));
    await tester.pumpWidget(const SizedBox.shrink());
    closedSearch.complete(Right(_page([_profile('closed', 'Closed')])));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('next page failure keeps rows and retries the same cursor', (
    tester,
  ) async {
    final repository = _ProfilesRepository();
    const error = ApiError(
      type: ApiErrorType.server,
      message: 'More people could not be loaded.',
      contractCode: 'project_members_temporarily_unavailable',
    );
    var pageCalls = 0;
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => Right(
        _page([
          for (var index = 0; index < 12; index++)
            _profile('first-$index', 'Person $index'),
        ], nextCursor: 'cursor-2'),
      ),
    );
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        cursor: 'cursor-2',
      ),
    ).thenAnswer((_) async {
      pageCalls++;
      if (pageCalls == 1) return const Left(error);
      return Right(_page([_profile('next', 'Next person')]));
    });

    await _pumpMenu(tester, _loader(repository));
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));

    expect(find.text('More people could not be loaded.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, 900));
    await tester.pump();
    expect(find.text('Person 0'), findsOneWidget);
    expect(pageCalls, 1);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(pageCalls, 2);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pump();
    expect(find.text('Next person'), findsOneWidget);
  });

  testWidgets('picker entry opens search and saves selected profile', (
    tester,
  ) async {
    final repository = _ProfilesRepository();
    when(
      () => repository.listProfilesPage(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async => Right(_page([_profile('member-1', 'Ala')])));
    List<String>? savedIds;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: MaterialTheme.crm().light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => TaskAssigneePicker.show(
                context,
                assignees: const [],
                profiles: const {},
                onSave: (ids) async {
                  savedIds = ids;
                  return true;
                },
                initialAction: AssigneeMenuAction.setOwner,
                searchEligibleProfiles: _loader(repository),
              ),
              child: const Text('Open picker'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open picker'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));

    expect(find.text('Ala'), findsOneWidget);
    await tester.tap(find.text('Ala'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    expect(savedIds, ['member-1']);
  });
}

Future<void> _pumpMenu(
  WidgetTester tester,
  EligibleProfilesPageLoader loader,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: MaterialTheme.crm().light(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 340,
            child: TaskAssigneeSearchMenu(
              candidates: const [],
              selectedIds: const [],
              primaryId: null,
              selectionMode: AssigneeMenuAction.setOwner,
              searchEligibleProfiles: loader,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 10));
}

EligibleProfilesPageLoader _loader(
  ProjectMemberProfilesRepository repository,
) => EligibleProfilesPageLoader(
  repository: repository,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
);

ProjectMemberProfilePage _page(
  List<ProjectMemberProfile> profiles, {
  String? nextCursor,
}) => ProjectMemberProfilePage(items: profiles, nextCursor: nextCursor);

ProjectMemberProfile _profile(String id, String name) => ProjectMemberProfile(
  userId: id,
  role: ProjectRole.member,
  displayName: name,
);
