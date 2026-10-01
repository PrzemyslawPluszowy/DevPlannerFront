import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/models/project_people_request.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const _members = [
  ProjectMemberProfile(
    userId: 'offline',
    displayName: 'Bartek QA',
    role: ProjectRole.member,
    isOnline: false,
  ),
  ProjectMemberProfile(
    userId: 'online',
    displayName: 'Anna QA',
    role: ProjectRole.member,
    isOnline: true,
  ),
  ProjectMemberProfile(
    userId: 'self',
    displayName: 'Konto QA',
    role: ProjectRole.admin,
    isOnline: true,
  ),
];

final class _Profiles extends Fake implements ProjectMemberProfilesRepository {
  Future<Either<ApiError, List<ProjectMemberProfile>>> Function()? load;
  Either<ApiError, List<ProjectMemberProfile>> result = const Right(_members);
  int calls = 0;
  int invalidations = 0;
  @override
  Future<Either<ApiError, List<ProjectMemberProfile>>> listProfiles({
    required String workspaceId,
    required String projectId,
    bool forceRefresh = false,
  }) async {
    calls++;
    expect(workspaceId, 'workspace');
    expect(projectId, 'project');
    expect(forceRefresh, isTrue);
    return load == null ? result : await load!();
  }

  @override
  void invalidate({required String workspaceId, required String projectId}) {
    invalidations++;
  }
}

ProjectPeopleRequest _request(_Profiles repository) => ProjectPeopleRequest(
  workspaceId: 'workspace',
  projectId: 'project',
  projectName: 'Projekt QA',
  repository: repository,
  ownerUserId: 'self',
);

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  testWidgets(
    'presence connection failure offers retry and clears after recovery',
    (tester) async {
      final repository = _Profiles();
      final cubit = ProjectPeopleCubit(_request(repository));
      final controller = DevPlannerPanelsController();
      final available = ValueNotifier(false);
      var retries = 0;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DevPlannerPanelsScope(
            controller: controller,
            openConversation: (_) {},
            presenceAvailability: available,
            retryPresence: () async {
              retries++;
              available.value = true;
            },
            child: ProjectPeoplePanel(cubit: cubit, onClose: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final warning = find.text(
        'Połączenie obecności jest niedostępne. Status Twojej sesji może być nieaktualny.',
      );
      expect(warning, findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pump();
      expect(retries, 1);
      expect(warning, findsNothing);
      expect(repository.calls, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await cubit.close();
      available.dispose();
      controller.dispose();
    },
  );

  test('sorts self and online first, filters names and exposes read errors as stale', () async {
    final repository = _Profiles();
    final cubit = ProjectPeopleCubit(_request(repository));
    await _flush();
    expect(cubit.state.members.map((member) => member.userId), [
      'self',
      'online',
      'offline',
    ]);
    expect(cubit.state.onlineCount, 2);
    cubit.search(' ANNA ');
    expect(cubit.state.visibleMembers.single.userId, 'online');
    repository.result = const Left(
      ApiError(type: ApiErrorType.connection, message: 'Brak połączenia'),
    );
    await cubit.refresh();
    expect(cubit.state.presenceIsFresh, isFalse);
    expect(cubit.state.members, hasLength(3));
    expect(cubit.state.error?.type, ApiErrorType.connection);
    repository.result = const Right(_members);
    await cubit.refresh();
    expect(cubit.state.presenceIsFresh, isTrue);
    expect(cubit.state.error, isNull);
    expect(cubit.state.query, ' ANNA ');
    await cubit.close();
  });

  test('revoked access removes people and cached profiles', () async {
    final repository = _Profiles();
    final cubit = ProjectPeopleCubit(
      _request(repository),
      refreshInterval: const Duration(milliseconds: 5),
    );
    await _flush();
    repository.result = const Left(
      ApiError(type: ApiErrorType.forbidden, message: 'Brak dostępu'),
    );
    await cubit.refresh();
    expect(cubit.state.members, isEmpty);
    expect(cubit.state.presenceIsFresh, isFalse);
    expect(repository.invalidations, 1);
    final calls = repository.calls;
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(repository.calls, calls);
    await cubit.close();
  });

  test(
    'does not overlap reads or publish a pending result after close',
    () async {
      final pending = Completer<Either<ApiError, List<ProjectMemberProfile>>>();
      final repository = _Profiles()..load = () => pending.future;
      final cubit = ProjectPeopleCubit(_request(repository));
      await cubit.refresh();
      expect(repository.calls, 1);
      await cubit.close();
      pending.complete(const Right(_members));
      await _flush();
      expect(cubit.state.members, isEmpty);
      expect(repository.calls, 1);
    },
  );

  testWidgets(
    'right people panel retains the route, filters statuses and clears on logout',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final repository = _Profiles();
      final session = AuthSessionController()
        ..setSignedIn(
          const AuthUser(userId: 'self', login: 'qa', displayName: 'Konto QA'),
        );
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
        ],
      );
      addTearDown(session.dispose);
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: DevPlannerGlobalPanelsHost(
            navigation: DevPlannerNavigation(router),
            authSession: session,
            child: Builder(
              builder: (context) => Column(
                children: [
                  TextButton(
                    onPressed: () => DevPlannerPanelsScope.openPeopleOf(
                      context,
                    )!(_request(repository)),
                    child: const Text('Osoby'),
                  ),
                  const Text('Treść listy'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Osoby'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectPeoplePanel), findsOneWidget);
      expect(
        tester.getSize(find.byType(ProjectPeoplePanel)).width,
        lessThan(500),
      );
      expect(find.text('Treść listy'), findsOneWidget);
      expect(find.text('Bartek QA'), findsOneWidget);
      expect(find.text('Offline'), findsOneWidget);
      expect(find.text('Online'), findsNWidgets(2));
      await tester.enterText(
        find.byKey(const ValueKey('project-people-search')),
        'Anna',
      );
      await tester.pump();
      expect(find.text('Anna QA'), findsOneWidget);
      expect(find.text('Bartek QA'), findsNothing);
      session.setSignedOut();
      await tester.pumpAndSettle();
      expect(find.byType(ProjectPeoplePanel), findsNothing);
      final calls = repository.calls;
      await tester.pump(const Duration(seconds: 30));
      expect(repository.calls, calls);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
