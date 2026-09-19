import 'package:devplanner/admin/data/admin_data.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminUserGatewayApiAdapter', () {
    test('maps exact cursor page and LocalAdminUserResponse fields', () async {
      final transport = _RecordingTransport(
        const AdminUserApiResponse(
          statusCode: 200,
          body: {
            'items': [_userJson],
            'nextCursor': 'next-opaque-cursor',
          },
        ),
      );
      final gateway = AdminUserGatewayApiAdapter(transport: transport);

      final result = await gateway.list(
        const AdminUserQuery(
          cursor: 'current-opaque-cursor',
          search: 'Ada',
          status: AdminUserStatus.active,
          emailConfirmed: true,
          roleCode: 'SystemAdmin',
          limit: 25,
        ),
      );

      final page = result.getOrElse(
        () => throw StateError('Expected a mapped page.'),
      );
      expect(transport.requests.single.method, AdminUserApiMethod.get);
      expect(transport.requests.single.path, '/api/v1/admin/users');
      expect(transport.requests.single.query, {
        'cursor': 'current-opaque-cursor',
        'search': 'Ada',
        'status': 'Active',
        'emailConfirmed': 'true',
        'roleCode': 'SystemAdmin',
        'limit': '25',
      });
      expect(page.nextCursor, 'next-opaque-cursor');
      expect(
        page.users.single,
        AdminUser(
          userId: '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
          login: 'ada',
          email: 'ada@example.test',
          displayName: 'Ada Lovelace',
          status: AdminUserStatus.active,
          emailVerified: true,
          roles: const {'SystemAdmin', 'User'},
          createdAtUtc: DateTime.utc(2026, 9, 16, 10),
          updatedAtUtc: DateTime.utc(2026, 9, 16, 11),
        ),
      );
    });

    test(
      'serializes create, partial update, roles and lifecycle requests',
      () async {
        final transport = _QueueTransport([
          const AdminUserApiResponse(statusCode: 201, body: _userJson),
          const AdminUserApiResponse(statusCode: 200, body: _userJson),
          const AdminUserApiResponse(
            statusCode: 200,
            body: {
              'userId': '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
              'roleCodes': ['User', 'SystemAdmin'],
            },
          ),
          const AdminUserApiResponse(
            statusCode: 200,
            body: {
              'user': _userJson,
              'changed': false,
            },
          ),
        ]);
        final gateway = AdminUserGatewayApiAdapter(transport: transport);

        await gateway.create(
          const AdminUserCreateCommand(
            login: 'ada',
            email: 'ada@example.test',
            displayName: 'Ada Lovelace',
          ),
        );
        await gateway.update(
          const AdminUserUpdateCommand(
            userId: '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
            mustChangePassword: true,
          ),
        );
        final roles = await gateway.setRoles(
          const AdminUserRoleCommand(
            userId: '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
            roles: {'User', 'SystemAdmin'},
          ),
        );
        final lifecycle = await gateway.lifecycle(
          const AdminUserLifecycleCommand(
            userId: '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
            action: AdminUserLifecycleAction.reactivate,
          ),
        );

        expect(transport.requests.map((request) => request.path), [
          '/api/v1/admin/users',
          '/api/v1/admin/users/01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
          '/api/v1/admin/users/01a45f2e-c5e9-4f0d-b0b3-688bf1234567/roles',
          '/api/v1/admin/users/01a45f2e-c5e9-4f0d-b0b3-688bf1234567/reactivate',
        ]);
        expect(transport.requests[0].body, {
          'login': 'ada',
          'email': 'ada@example.test',
          'displayName': 'Ada Lovelace',
        });
        expect(transport.requests[1].body, {'mustChangePassword': true});
        expect(transport.requests[2].body, {
          'roleCodes': ['SystemAdmin', 'User'],
        });
        expect(
          roles.getOrElse(() => throw StateError('Expected roles.')).roleCodes,
          {'SystemAdmin', 'User'},
        );
        expect(
          lifecycle
              .getOrElse(() => throw StateError('Expected lifecycle.'))
              .changed,
          isFalse,
        );
      },
    );

    test(
      'maps ApiErrorResponse to a typed error without a network call',
      () async {
        final gateway = AdminUserGatewayApiAdapter(
          transport: _RecordingTransport(
            const AdminUserApiResponse(
              statusCode: 409,
              body: {
                'code': 'local_user.last_system_admin',
                'message': 'Nie można dezaktywować ostatniego administratora.',
                'fields': null,
                'traceId': '00-abc',
              },
            ),
          ),
        );

        final result = await gateway.lifecycle(
          const AdminUserLifecycleCommand(
            userId: '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
            action: AdminUserLifecycleAction.deactivate,
          ),
        );

        final error = result.fold(
          (error) => error,
          (_) => throw StateError('Expected error.'),
        );
        expect(error.type, ApiErrorType.conflict);
        expect(error.apiCode, 'local_user.last_system_admin');
        expect(error.traceId, '00-abc');
        expect(
          error.message,
          'Nie można dezaktywować ostatniego administratora.',
        );
      },
    );
  });

  test('composition keeps API adapter and session affordances explicit', () {
    final gateway = AdminUserGatewayApiAdapter(
      transport: _RecordingTransport(
        const AdminUserApiResponse(statusCode: 200),
      ),
    );
    final composition = AdminUsersComposition(
      gateway: gateway,
      currentUserId: '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
      permissions: const {'users.read', 'users.manage'},
    );

    expect(composition.gateway, same(gateway));
    expect(composition.currentUserId, '01a45f2e-c5e9-4f0d-b0b3-688bf1234567');
    expect(composition.canReadUsers, isTrue);
    expect(composition.canManageUsers, isTrue);
  });
}

const Map<String, Object?> _userJson = {
  'userId': '01a45f2e-c5e9-4f0d-b0b3-688bf1234567',
  'login': 'ada',
  'email': 'ada@example.test',
  'displayName': 'Ada Lovelace',
  'status': 'Active',
  'emailConfirmed': true,
  'mustChangePassword': false,
  'roles': ['SystemAdmin', 'User'],
  'createdAtUtc': '2026-09-16T10:00:00.000Z',
  'updatedAtUtc': '2026-09-16T11:00:00.000Z',
  'deactivatedAtUtc': null,
};

final class _RecordingTransport implements AdminUserApiTransport {
  _RecordingTransport(this.response);

  final AdminUserApiResponse response;
  final List<AdminUserApiRequest> requests = <AdminUserApiRequest>[];

  @override
  Future<AdminUserApiResponse> send(AdminUserApiRequest request) async {
    requests.add(request);
    return response;
  }
}

final class _QueueTransport implements AdminUserApiTransport {
  _QueueTransport(this._responses);

  final List<AdminUserApiResponse> _responses;
  final List<AdminUserApiRequest> requests = <AdminUserApiRequest>[];

  @override
  Future<AdminUserApiResponse> send(AdminUserApiRequest request) async {
    requests.add(request);
    return _responses.removeAt(0);
  }
}
