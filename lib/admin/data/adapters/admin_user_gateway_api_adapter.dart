import 'package:dartz/dartz.dart';
import 'package:devplanner/admin/data/adapters/admin_user_api_transport.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/domain/ports/admin_user_gateway.dart';
import 'package:devplanner/foundation/error/error.dart';

/// Infrastrukturany adapter kontraktu backendu 3A.
///
/// Nie przechowuje tokenów i nie wykonuje HTTP samodzielnie; obowiązek cookies,
/// CSRF oraz ewentualnego BFF należy do [AdminUserApiTransport].
final class AdminUserGatewayApiAdapter implements AdminUserGateway {
  AdminUserGatewayApiAdapter({required this.transport});

  final AdminUserApiTransport transport;

  static const _usersPath = '/api/v1/admin/users';

  @override
  Future<Either<ApiError, AdminUserPage>> list(AdminUserQuery query) =>
      _request(
        AdminUserApiRequest(
          method: AdminUserApiMethod.get,
          path: _usersPath,
          query: _listQuery(query),
        ),
        (body) {
          final map = _map(body);
          final items = _list(map['items']).map(_userFromWire).toList();
          return AdminUserPage(
            users: items,
            nextCursor: _nullableString(map['nextCursor']),
          );
        },
      );

  @override
  Future<Either<ApiError, AdminUser>> create(AdminUserCreateCommand command) =>
      _request(
        AdminUserApiRequest(
          method: AdminUserApiMethod.post,
          path: _usersPath,
          body: {
            'login': command.login,
            'email': command.email,
            'displayName': command.displayName,
          },
        ),
        _userFromWire,
        successStatusCodes: const {201},
      );

  @override
  Future<Either<ApiError, AdminUser>> update(AdminUserUpdateCommand command) =>
      _request(
        AdminUserApiRequest(
          method: AdminUserApiMethod.patch,
          path: '$_usersPath/${command.userId}',
          body: _updateBody(command),
        ),
        _userFromWire,
      );

  @override
  Future<Either<ApiError, AdminUserRolesResult>> setRoles(
    AdminUserRoleCommand command,
  ) => _request(
    AdminUserApiRequest(
      method: AdminUserApiMethod.put,
      path: '$_usersPath/${command.userId}/roles',
      body: {'roleCodes': command.roles.toList()..sort()},
    ),
    (body) {
      final map = _map(body);
      return AdminUserRolesResult(
        userId: _requiredString(map, 'userId'),
        roleCodes: _stringSet(map['roleCodes']),
      );
    },
  );

  @override
  Future<Either<ApiError, AdminUserLifecycleResult>> lifecycle(
    AdminUserLifecycleCommand command,
  ) {
    final action = switch (command.action) {
      AdminUserLifecycleAction.deactivate => 'deactivate',
      AdminUserLifecycleAction.reactivate => 'reactivate',
    };
    return _request(
      AdminUserApiRequest(
        method: AdminUserApiMethod.post,
        path: '$_usersPath/${command.userId}/$action',
      ),
      (body) {
        final map = _map(body);
        return AdminUserLifecycleResult(
          user: _userFromWire(map['user']),
          changed: _requiredBool(map, 'changed'),
        );
      },
    );
  }

  Future<Either<ApiError, T>> _request<T>(
    AdminUserApiRequest request,
    T Function(Object? body) decode, {
    Set<int> successStatusCodes = const {200},
  }) async {
    try {
      final response = await transport.send(request);
      if (!successStatusCodes.contains(response.statusCode)) {
        return Left(_errorFromResponse(response));
      }
      try {
        return Right(decode(response.body));
      } on FormatException {
        return Left(
          ApiError.parsing(
            fallbackMessage: 'Odpowiedź administracji użytkownikami ma nieprawidłowy format.',
          ),
        );
      }
    } catch (_) {
      return const Left(
        ApiError(
          type: ApiErrorType.connection,
          message:
              'Nie można połączyć się z usługą administracji użytkownikami.',
        ),
      );
    }
  }

  static ApiError _errorFromResponse(AdminUserApiResponse response) {
    final body = response.body;
    final map = body is Map ? Map<String, Object?>.from(body) : null;
    final fields = map?['fields'];
    final message =
        _nullableString(map?['message']) ??
        _fallbackMessage(response.statusCode);
    return ApiError(
      type: _errorType(response.statusCode, fields),
      message: message,
      statusCode: response.statusCode,
      apiCode: _nullableString(map?['code']),
      traceId: _nullableString(map?['traceId']),
    );
  }

  static Map<String, String> _listQuery(AdminUserQuery query) {
    final parameters = <String, String>{'limit': query.limit.toString()};
    if (query.cursor != null) parameters['cursor'] = query.cursor!;
    if (query.search != null) parameters['search'] = query.search!;
    if (query.status != null) {
      parameters['status'] = _statusToWire(query.status!);
    }
    if (query.emailConfirmed != null) {
      parameters['emailConfirmed'] = query.emailConfirmed.toString();
    }
    if (query.roleCode != null) parameters['roleCode'] = query.roleCode!;
    return parameters;
  }

  static Map<String, Object?> _updateBody(AdminUserUpdateCommand command) {
    final body = <String, Object?>{};
    if (command.login != null) body['login'] = command.login;
    if (command.email != null) body['email'] = command.email;
    if (command.displayName != null) body['displayName'] = command.displayName;
    if (command.mustChangePassword != null) {
      body['mustChangePassword'] = command.mustChangePassword;
    }
    return body;
  }

  static ApiErrorType _errorType(int statusCode, Object? fields) =>
      switch (statusCode) {
        400 when fields is Map && fields.isNotEmpty => ApiErrorType.validation,
        400 => ApiErrorType.badResponse,
        401 => ApiErrorType.unauthorized,
        403 => ApiErrorType.forbidden,
        404 => ApiErrorType.notFound,
        409 => ApiErrorType.conflict,
        422 => ApiErrorType.validation,
        final code when code >= 500 => ApiErrorType.server,
        _ => ApiErrorType.badResponse,
      };

  static String _fallbackMessage(int statusCode) => switch (statusCode) {
    400 => 'Nieprawidłowe dane administracji użytkownikami.',
    401 => 'Sesja wygasła. Zaloguj się ponownie.',
    403 => 'Brak uprawnień do wykonania tej operacji.',
    404 => 'Nie znaleziono konta użytkownika.',
    409 => 'Operacja jest w konflikcie z aktualnym stanem konta.',
    _ when statusCode >= 500 =>
      'Usługa administracji użytkownikami zwróciła błąd.',
    _ => 'Usługa administracji użytkownikami odrzuciła żądanie.',
  };

  static AdminUser _userFromWire(Object? body) {
    final map = _map(body);
    return AdminUser(
      userId: _requiredString(map, 'userId'),
      login: _requiredString(map, 'login'),
      email: _requiredString(map, 'email'),
      displayName: _requiredString(map, 'displayName'),
      status: _statusFromWire(_requiredString(map, 'status')),
      emailVerified: _requiredBool(map, 'emailConfirmed'),
      mustChangePassword: _requiredBool(map, 'mustChangePassword'),
      roles: _stringSet(map['roles']),
      createdAtUtc: _requiredDateTime(map, 'createdAtUtc'),
      updatedAtUtc: _requiredDateTime(map, 'updatedAtUtc'),
      deactivatedAtUtc: _nullableDateTime(map, 'deactivatedAtUtc'),
    );
  }

  static Map<String, Object?> _map(Object? value) {
    if (value is! Map) throw const FormatException('Expected JSON object.');
    return Map<String, Object?>.from(value);
  }

  static List<Object?> _list(Object? value) {
    if (value is! List) throw const FormatException('Expected JSON array.');
    return List<Object?>.from(value);
  }

  static String _requiredString(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('Expected non-empty $key.');
    }
    return value;
  }

  static String? _nullableString(Object? value) =>
      value is String ? value : null;

  static bool _requiredBool(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! bool) throw FormatException('Expected bool $key.');
    return value;
  }

  static Set<String> _stringSet(Object? value) => _list(value).map((item) {
    if (item is! String) throw const FormatException('Expected string array.');
    return item;
  }).toSet();

  static DateTime _requiredDateTime(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! String) throw FormatException('Expected ISO date $key.');
    return DateTime.tryParse(value)?.toUtc() ??
        (throw FormatException('Expected ISO date $key.'));
  }

  static DateTime? _nullableDateTime(Map<String, Object?> map, String key) {
    if (map[key] == null) return null;
    return _requiredDateTime(map, key);
  }

  static AdminUserStatus _statusFromWire(String status) => switch (status) {
    'PendingActivation' => AdminUserStatus.pendingActivation,
    'Active' => AdminUserStatus.active,
    'Locked' => AdminUserStatus.locked,
    'Deactivated' => AdminUserStatus.deactivated,
    _ => throw const FormatException('Unknown user status.'),
  };

  static String _statusToWire(AdminUserStatus status) => switch (status) {
    AdminUserStatus.pendingActivation => 'PendingActivation',
    AdminUserStatus.active => 'Active',
    AdminUserStatus.locked => 'Locked',
    AdminUserStatus.deactivated => 'Deactivated',
  };
}
