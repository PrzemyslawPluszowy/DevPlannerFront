import 'package:devplanner/workspaces/data/workspaces/payloads/workspace_payloads.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('workspace local directory contracts', () {
    test('maps the backend local directory response without legacy identity', () {
      final user = LocalUserDirectoryResponse.fromJson({
        'userId': '11111111-1111-1111-1111-111111111111',
        'login': 'misiek440',
        'displayName': 'Misiek Nowak',
        'email': 'misiek@example.test',
        'emailVerified': true,
        'avatarFileId': '22222222-2222-2222-2222-222222222222',
      });

      expect(user.userId, '11111111-1111-1111-1111-111111111111');
      expect(user.login, 'misiek440');
      expect(user.displayName, 'Misiek Nowak');
      expect(user.emailVerified, isTrue);
      expect(user.toJson().keys, {
        'userId',
        'login',
        'displayName',
        'email',
        'emailVerified',
        'avatarFileId',
      });
    });

    test('serializes invitation request with the backend UUID field', () {
      final payload = CreateWorkspaceInvitationPayload.fromJson({
        'userId': '11111111-1111-1111-1111-111111111111',
        'role': 'Member',
        'message': 'Dołącz do zespołu',
      });

      expect(payload.userId, '11111111-1111-1111-1111-111111111111');
      expect(payload.toJson(), {
        'userId': '11111111-1111-1111-1111-111111111111',
        'role': 'Member',
        'message': 'Dołącz do zespołu',
      });
    });

    test('maps invitation and membership responses to the same user UUID', () {
      final invitation = WorkspaceInvitationResponse.fromJson({
        'id': '33333333-3333-3333-3333-333333333333',
        'workspaceId': '44444444-4444-4444-4444-444444444444',
        'userId': '11111111-1111-1111-1111-111111111111',
        'role': 'Member',
        'status': 'Pending',
        'login': 'misiek440',
        'displayName': 'Misiek Nowak',
        'email': 'misiek@example.test',
        'message': null,
        'createdAtUtc': '2026-01-01T10:00:00Z',
        'expiresAtUtc': '2026-01-08T10:00:00Z',
        'respondedAtUtc': null,
      });
      final member = WorkspaceMemberResponse.fromJson({
        'id': '55555555-5555-5555-5555-555555555555',
        'userId': invitation.userId,
        'role': 'Member',
        'createdAtUtc': '2026-01-01T10:00:00Z',
        'updatedAtUtc': '2026-01-01T10:00:00Z',
      });

      expect(invitation.userId, member.userId);
      expect(invitation.status.name, 'pending');
      expect(member.toJson().keys, {
        'id',
        'userId',
        'role',
        'createdAtUtc',
        'updatedAtUtc',
      });
    });
  });
}
