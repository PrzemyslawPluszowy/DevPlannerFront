import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/repositories/project_member_profiles_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_profile_response.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_people_request.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test(
    'rail people owner bypasses a warm repository cache on open and retry',
    () async {
      final api = _ProjectsApi();
      var online = true;
      when(
        () => api.listProjectMemberProfiles(
          'workspace',
          'project',
          null,
          limit: 100,
        ),
      ).thenAnswer(
        (_) async => CursorPageResponse(
          items: [
            ProjectMemberProfileResponse(
              userId: 'member',
              displayName: 'Jan Nowak',
              role: ProjectRole.member,
              isOnline: online,
            ),
          ],
        ),
      );
      final repository = ProjectMemberProfilesRepositoryImpl(api: api);
      final cached = await repository.listProfiles(
        workspaceId: 'workspace',
        projectId: 'project',
      );
      expect(cached.getOrElse(() => []).single.isOnline, true);
      online = false;
      final cubit = ProjectPeopleCubit(
        ProjectPeopleRequest(
          workspaceId: 'workspace',
          projectId: 'project',
          projectName: '',
          repository: repository,
        ),
      );
      addTearDown(cubit.close);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.presenceIsFresh, true);
      expect(cubit.state.members.single.isOnline, false);
      online = true;
      await cubit.refresh();
      expect(cubit.state.members.single.isOnline, true);
      verify(
        () => api.listProjectMemberProfiles(
          'workspace',
          'project',
          null,
          limit: 100,
        ),
      ).called(3);
    },
  );
  test(
    'profiles preserve global presence and every ProjectRole wire value',
    () {
      const roles = {
        'Owner': ProjectRole.owner,
        'Admin': ProjectRole.admin,
        'Member': ProjectRole.member,
        'Observer': ProjectRole.observer,
      };
      for (final entry in roles.entries) {
        for (final online in [true, false]) {
          final profile = ProjectMemberProfileResponse.fromJson({
            'userId': 'user',
            'role': entry.key,
            'isOnline': online,
          });
          expect(profile.role, entry.value);
          expect(profile.isOnline, online);
          expect(profile.toJson()['role'], entry.key);
          expect(profile.toJson()['isOnline'], online);
        }
      }
      expect(
        ProjectMemberProfileResponse.fromJson({
          'userId': 'user',
          'role': 'Member',
        }).isOnline,
        isNull,
      );
    },
  );
  test('listProfiles zachowuje pełny katalog przez cursorowe strony', () async {
    final api = _ProjectsApi();
    when(
      () => api.listProjectMemberProfiles(
        'workspace',
        'project',
        null,
        limit: 100,
      ),
    ).thenAnswer(
      (_) async => const CursorPageResponse(
        items: [
          ProjectMemberProfileResponse(
            userId: 'user-1',
            displayName: 'Anna',
            role: ProjectRole.member,
          ),
        ],
        nextCursor: 'cursor-1',
      ),
    );
    when(
      () => api.listProjectMemberProfiles(
        'workspace',
        'project',
        null,
        cursor: 'cursor-1',
        limit: 100,
      ),
    ).thenAnswer(
      (_) async => const CursorPageResponse(
        items: [
          ProjectMemberProfileResponse(
            userId: 'user-2',
            displayName: 'Bartek',
            role: ProjectRole.admin,
          ),
        ],
      ),
    );
    final repository = ProjectMemberProfilesRepositoryImpl(api: api);

    final result = await repository.listProfiles(
      workspaceId: 'workspace',
      projectId: 'project',
    );

    result.fold(
      (error) => fail('Nieoczekiwany błąd: $error'),
      (profiles) {
        expect(profiles.map((profile) => profile.userId), [
          'user-1',
          'user-2',
        ]);
        expect(profiles.map((profile) => profile.displayName), [
          'Anna',
          'Bartek',
        ]);
      },
    );
    verify(
      () => api.listProjectMemberProfiles(
        'workspace',
        'project',
        null,
        cursor: 'cursor-1',
        limit: 100,
      ),
    ).called(1);
  });
}

final class _ProjectsApi extends Mock implements ProjectsApi {}
