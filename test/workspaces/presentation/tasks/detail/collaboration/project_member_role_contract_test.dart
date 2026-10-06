import 'package:devplanner/workspaces/data/projects/responses/project_member_profile_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'full project response enum wire matches all 32 server combinations',
    () {
      const roles = {
        ProjectRole.owner: 'Owner',
        ProjectRole.admin: 'Admin',
        ProjectRole.member: 'Member',
        ProjectRole.observer: 'Observer',
      };
      const statuses = {
        ProjectStatus.planned: 'Planned',
        ProjectStatus.active: 'Active',
        ProjectStatus.onHold: 'OnHold',
        ProjectStatus.completed: 'Completed',
      };
      const visibility = {
        ProjectVisibility.shared: 'Shared',
        ProjectVisibility.private: 'Private',
      };
      expect(roles.keys.toSet(), ProjectRole.values.toSet());
      expect(statuses.keys.toSet(), ProjectStatus.values.toSet());
      expect(visibility.keys.toSet(), ProjectVisibility.values.toSet());
      for (final role in roles.entries) {
        for (final status in statuses.entries) {
          for (final scope in visibility.entries) {
            final response = ProjectResponse.fromJson({
              'id': 'project',
              'workspaceId': 'workspace',
              'name': 'QA',
              'createdByUserId': 'synthetic',
              'createdAtUtc': '2026-10-06T00:00:00Z',
              'updatedAtUtc': '2026-10-06T00:00:00Z',
              'myRole': role.value,
              'status': status.value,
              'visibility': scope.value,
              'capabilities': {'canManage': true},
            });
            expect(response.myRole, role.key);
            expect(response.status, status.key);
            expect(response.visibility, scope.key);
            expect(response.capabilities!.canManage, isTrue);
            final json = response.toJson();
            expect(json['myRole'], role.value);
            expect(json['status'], status.value);
            expect(json['visibility'], scope.value);
          }
        }
      }
    },
  );

  test(
    'każda rola profilu zachowuje dokładną wartość przewodową w obu kierunkach',
    () {
      const values = {
        ProjectRole.owner: 'Owner',
        ProjectRole.admin: 'Admin',
        ProjectRole.member: 'Member',
        ProjectRole.observer: 'Observer',
      };
      expect(values.keys.toSet(), ProjectRole.values.toSet());
      for (final entry in values.entries) {
        final profile = ProjectMemberProfileResponse.fromJson({
          'userId': 'test-user',
          'role': entry.value,
        });
        expect(profile.role, entry.key);
        expect(profile.toJson()['role'], entry.value);
      }
      expect(
        () => ProjectMemberProfileResponse.fromJson({
          'userId': 'test-user',
          'role': 'owner',
        }),
        throwsArgumentError,
      );
      expect(
        () => ProjectMemberProfileResponse.fromJson({
          'userId': 'test-user',
          'role': 'unknown',
        }),
        throwsArgumentError,
      );
    },
  );
}
