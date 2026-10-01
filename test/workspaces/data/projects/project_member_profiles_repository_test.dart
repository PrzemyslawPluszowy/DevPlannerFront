import 'package:devplanner/workspaces/data/projects/api/projects_api.dart';
import 'package:devplanner/workspaces/data/projects/repositories/project_member_profiles_repository_impl.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_profile_response.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
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
