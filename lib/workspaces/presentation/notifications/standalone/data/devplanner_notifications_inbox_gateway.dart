import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_gateway.dart';
import 'package:devplanner/workspaces/presentation/notifications/standalone/domain/notifications_inbox_models.dart';

/// Produkcyjny adapter skrzynki Notifications do transportu sesyjnego.
///
/// Ścieżki i pola odpowiadają `NotificationEndpoints` w Backend. Adapter nie
/// korzysta z odziedziczonego klienta Notifications ani z modułu legacy.
final class DevPlannerNotificationsInboxGateway
    implements StandaloneNotificationsInboxGateway {
  DevPlannerNotificationsInboxGateway(this._transport);

  final DevPlannerHttpTransport _transport;

  @override
  Future<Either<ApiError, StandaloneNotificationPage>> list({
    String? cursor,
    int limit = 30,
    bool unreadOnly = false,
    NotificationCategory? category,
  }) async {
    if (limit < 1 || limit > 100) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Limit powiadomień musi mieścić się w zakresie 1–100.',
        ),
      );
    }

    final query = <String, String>{
      'limit': '$limit',
      'isUnreadOnly': '$unreadOnly',
    };
    if (cursor case final value? when value.isNotEmpty) query['cursor'] = value;
    if (category case final value?) query['category'] = value.name;

    try {
      final response = await _transport.execute(
        DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.get,
          path: '/api/v1/notifications/',
          query: query,
        ),
      );
      if (!_isSuccess(response.statusCode)) {
        return Left(_errorFromResponse(response));
      }
      return Right(_pageFromResponse(response.body));
    } on DevPlannerHttpTransportException catch (error) {
      return Left(
        ApiError(type: ApiErrorType.connection, message: error.message),
      );
    } on FormatException catch (error) {
      return Left(ApiError.parsing(fallbackMessage: error.message));
    } catch (error) {
      return Left(
        ApiError.parsing(
          fallbackMessage: 'Nieprawidłowa odpowiedź powiadomień: $error',
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, int>> unreadCount() async {
    try {
      final response = await _transport.execute(
        const DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.get,
          path: '/api/v1/notifications/unread-count',
        ),
      );
      if (!_isSuccess(response.statusCode)) {
        return Left(_errorFromResponse(response));
      }
      final map = _map(response.body, 'Licznik powiadomień');
      final count = map['count'];
      if (count is! int || count < 0) {
        throw const FormatException('Brak poprawnego pola count.');
      }
      return Right(count);
    } on DevPlannerHttpTransportException catch (error) {
      return Left(
        ApiError(type: ApiErrorType.connection, message: error.message),
      );
    } on FormatException catch (error) {
      return Left(ApiError.parsing(fallbackMessage: error.message));
    } catch (error) {
      return Left(
        ApiError.parsing(
          fallbackMessage: 'Nieprawidłowy licznik powiadomień: $error',
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, Unit>> markRead(String notificationId) async {
    if (notificationId.trim().isEmpty) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Identyfikator powiadomienia jest wymagany.',
        ),
      );
    }

    try {
      final response = await _transport.execute(
        DevPlannerHttpRequest(
          method: DevPlannerHttpMethod.post,
          path: '/api/v1/notifications/${notificationId.trim()}/read',
        ),
      );
      if (!_isSuccess(response.statusCode)) {
        return Left(_errorFromResponse(response));
      }
      return const Right(unit);
    } on DevPlannerHttpTransportException catch (error) {
      return Left(
        ApiError(type: ApiErrorType.connection, message: error.message),
      );
    } catch (error) {
      return Left(
        ApiError.parsing(
          fallbackMessage: 'Nie udało się oznaczyć powiadomienia: $error',
        ),
      );
    }
  }

  static StandaloneNotificationPage _pageFromResponse(Object? body) {
    final map = _map(body, 'Strona powiadomień');
    final rawItems = map['items'];
    if (rawItems is! List) {
      throw const FormatException('Brak tablicy items.');
    }
    return StandaloneNotificationPage(
      items: rawItems.map(_itemFromJson).toList(growable: false),
      nextCursor: map['nextCursor'] as String?,
    );
  }

  static StandaloneNotificationItem _itemFromJson(Object? value) {
    final map = _map(value, 'Element powiadomienia');
    return StandaloneNotificationItem(
      id: _requiredString(map, 'id'),
      title: _requiredString(map, 'title'),
      body: _requiredString(map, 'body'),
      createdAtUtc: _requiredDate(map, 'createdAtUtc'),
      readAtUtc: _nullableDate(map, 'readAtUtc'),
      category: _category(map['category']),
      priority: _priority(map['priority']),
      deepLink: map['deepLink'] as String?,
      groupKey: map['groupKey'] as String?,
      eventType: _requiredString(map, 'eventType'),
    );
  }

  static Map<String, Object?> _map(Object? value, String label) {
    if (value is Map<String, Object?>) return value;
    if (value is Map) {
      return value.map<String, Object?>(
        (key, entry) => MapEntry('$key', entry),
      );
    }
    throw FormatException('$label nie jest obiektem JSON.');
  }

  static String _requiredString(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw FormatException('Brak poprawnego pola $key.');
  }

  static DateTime _requiredDate(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed.toUtc();
    }
    throw FormatException('Brak poprawnej daty $key.');
  }

  static DateTime? _nullableDate(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value == null) return null;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed.toUtc();
    }
    throw FormatException('Niepoprawna data $key.');
  }

  static NotificationCategory _category(Object? value) {
    final normalized = _enumValue(value, 'category');
    for (final item in NotificationCategory.values) {
      if (item.name.toLowerCase() == normalized) return item;
    }
    throw FormatException('Nieznana kategoria powiadomienia: $value.');
  }

  static NotificationPriority _priority(Object? value) {
    final normalized = _enumValue(value, 'priority');
    for (final item in NotificationPriority.values) {
      if (item.name.toLowerCase() == normalized) return item;
    }
    throw FormatException('Nieznany priorytet powiadomienia: $value.');
  }

  static String _enumValue(Object? value, String key) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim().toLowerCase();
    }
    throw FormatException('Brak poprawnego pola $key.');
  }

  static bool _isSuccess(int statusCode) =>
      statusCode >= 200 && statusCode < 300;

  static ApiError _errorFromResponse(DevPlannerHttpResponse response) {
    final body = response.body;
    final map = body is Map ? body : const <Object?, Object?>{};
    final message = map['message'];
    final code = map['code'];
    final traceId = map['traceId'];
    final type = switch (response.statusCode) {
      401 => ApiErrorType.unauthorized,
      403 => ApiErrorType.forbidden,
      404 => ApiErrorType.notFound,
      409 => ApiErrorType.conflict,
      422 => ApiErrorType.validation,
      final status when status >= 500 => ApiErrorType.server,
      _ => ApiErrorType.badResponse,
    };
    return ApiError(
      type: type,
      statusCode: response.statusCode,
      message: message is String && message.isNotEmpty
          ? message
          : 'Żądanie powiadomień zostało odrzucone.',
      apiCode: code is String ? code : null,
      traceId: traceId is String ? traceId : response.traceId,
    );
  }
}
