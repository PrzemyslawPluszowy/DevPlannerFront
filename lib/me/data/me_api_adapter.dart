import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/me/data/me_api_transport.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:devplanner/me/domain/ports/me_gateway.dart';
import 'package:equatable/equatable.dart';

/// Błąd domenowy zwracany podczas operacji na profilu lub sesjach użytkownika.
class MeApiException extends Equatable implements Exception {
  const MeApiException({
    required this.message,
    this.code,
    this.traceId,
    this.statusCode,
    this.fields,
  });

  /// Komunikat błędu.
  final String message;

  /// Kod błędu z backendu (np. `INVALID_CREDENTIALS`).
  final String? code;

  /// Identyfikator diagnostyczny żądania (traceId).
  final String? traceId;

  /// Kod statusu odpowiedzi HTTP.
  final int? statusCode;

  /// Opcjonalna mapa błędów dla poszczególnych pól formularza.
  final Map<String, dynamic>? fields;

  @override
  List<Object?> get props => [message, code, traceId, statusCode, fields];

  @override
  String toString() =>
      'MeApiException(statusCode: $statusCode, code: $code, message: $message, traceId: $traceId)';
}

/// Adapter API mapujący operacje profilu, hasła i sesji na backend DevPlanner.
final class MeApiAdapter implements MeGateway {
  MeApiAdapter({required this.transport});

  final MeApiTransport transport;

  static const _mePath = '/api/v1/me';
  static const _changePasswordPath = '/api/v1/auth/change-password';
  static const _sessionsPath = '/api/v1/me/sessions';
  static const _avatarPath = '/api/v1/me/avatar';

  @override
  Future<UserProfile> getProfile() async {
    final response = await _send(
      const MeApiRequest(
        method: MeApiMethod.get,
        path: _mePath,
      ),
      successStatusCodes: const {200},
    );

    final map = _asMap(response.body);
    return _profileFromWire(map);
  }

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? avatarFileId,
  }) async {
    final body = <String, Object?>{};
    if (displayName != null) body['displayName'] = displayName;
    if (avatarFileId != null) body['avatarFileId'] = avatarFileId;

    final response = await _send(
      MeApiRequest(
        method: MeApiMethod.patch,
        path: _mePath,
        body: body,
      ),
      successStatusCodes: const {200},
    );

    final map = _asMap(response.body);
    return _profileFromWire(map);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _send(
      MeApiRequest(
        method: MeApiMethod.post,
        path: _changePasswordPath,
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      ),
      successStatusCodes: const {200, 204},
    );
  }

  @override
  Future<List<UserSessionItem>> getSessions() async {
    final response = await _send(
      const MeApiRequest(
        method: MeApiMethod.get,
        path: _sessionsPath,
      ),
      successStatusCodes: const {200},
    );

    final list = _asList(response.body);
    return list.map((item) => _sessionFromWire(_asMap(item))).toList();
  }

  @override
  Future<void> revokeSession(String sessionId) async {
    await _send(
      MeApiRequest(
        method: MeApiMethod.delete,
        path: '$_sessionsPath/$sessionId',
      ),
      successStatusCodes: const {200, 204},
    );
  }

  @override
  Future<void> uploadAvatar(Uint8List bytes, String filename) async {
    await _send(
      MeApiRequest(
        method: MeApiMethod.post,
        path: _avatarPath,
        rawBytes: bytes,
        filename: filename,
        contentType: 'image/jpeg',
      ),
      successStatusCodes: const {200, 201, 204},
    );
  }

  @override
  Future<void> deleteAvatar() async {
    await _send(
      const MeApiRequest(
        method: MeApiMethod.delete,
        path: _avatarPath,
      ),
      successStatusCodes: const {200, 204},
    );
  }

  Future<MeApiResponse> _send(
    MeApiRequest request, {
    required Set<int> successStatusCodes,
  }) async {
    final MeApiResponse response;
    try {
      response = await transport.send(request);
    } catch (e) {
      throw MeApiException(
        message: 'Nie udało się połączyć z usługą profilu użytkownika: $e',
        code: 'CONNECTION_ERROR',
      );
    }

    if (!successStatusCodes.contains(response.statusCode)) {
      throw _errorFromResponse(response);
    }

    return response;
  }

  static MeApiException _errorFromResponse(MeApiResponse response) {
    final body = response.body;
    Map<String, dynamic>? map;
    if (body is Map) {
      map = Map<String, dynamic>.from(body);
    } else if (body is String && body.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map) {
          map = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        // Ignorujemy błąd parsowania błędu
      }
    }

    final code = map?['code'] as String?;
    final traceId = map?['traceId'] as String?;
    final fields = map?['fields'] is Map
        ? Map<String, dynamic>.from(map!['fields'] as Map)
        : null;
    final message = map?['message'] as String? ??
        _fallbackMessageForStatus(response.statusCode);

    return MeApiException(
      message: message,
      code: code,
      traceId: traceId,
      statusCode: response.statusCode,
      fields: fields,
    );
  }

  static String _fallbackMessageForStatus(int statusCode) => switch (statusCode) {
        400 => 'Nieprawidłowe żądanie.',
        401 => 'Sesja wygasła. Zaloguj się ponownie.',
        403 => 'Brak uprawnień do wykonania tej operacji.',
        404 => 'Nie znaleziono żądanego zasobu.',
        409 => 'Operacja jest w konflikcie z bieżącym stanem danych.',
        _ when statusCode >= 500 =>
          'Serwer napotkał wewnętrzny błąd. Spróbuj ponownie później.',
        _ => 'Wystąpił błąd podczas komunikacji z serwerem ($statusCode).',
      };

  static UserProfile _profileFromWire(Map<String, dynamic> map) {
    return UserProfile(
      userId: _string(map, 'userId'),
      login: _string(map, 'login'),
      email: _string(map, 'email'),
      displayName: _string(map, 'displayName'),
      avatarFileId: map['avatarFileId'] as String?,
      roles: _stringSet(map['roles']),
      permissions: _stringSet(map['permissions']),
    );
  }

  static UserSessionItem _sessionFromWire(Map<String, dynamic> map) {
    return UserSessionItem(
      id: _string(map, 'id'),
      deviceName: map['deviceName'] as String?,
      platform: map['platform'] as String?,
      createdAtUtc: DateTime.parse(_string(map, 'createdAtUtc')).toUtc(),
      lastSeenAtUtc: DateTime.parse(_string(map, 'lastSeenAtUtc')).toUtc(),
      isCurrent: map['isCurrent'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.trim().isNotEmpty) {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    }
    throw const FormatException('Oczekiwano obiektu JSON.');
  }

  static List<dynamic> _asList(Object? value) {
    if (value is List) return value;
    if (value is String && value.trim().isNotEmpty) {
      final decoded = jsonDecode(value);
      if (decoded is List) return decoded;
    }
    throw const FormatException('Oczekiwano tablicy JSON.');
  }

  static String _string(Map<String, dynamic> map, String key) {
    final val = map[key];
    if (val is String && val.isNotEmpty) return val;
    throw FormatException('Pole "$key" jest wymagane i musi być niepustym ciągiem znaków.');
  }

  static Set<String> _stringSet(Object? value) {
    if (value is! List) return const <String>{};
    return value.map((e) => e.toString()).toSet();
  }
}
