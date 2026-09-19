import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/notifications/api/notifications_api.dart';
import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_digest.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_digest_repository.dart';

/// Adapter read-only snapshotu digestu, bez ujawniania DTO Retrofit UI.
final class NotificationDigestRepositoryImpl extends ApiRepository
    implements NotificationDigestRepository {
  /// Tworzy adapter na prywatnym kliencie powiadomień Workspaces.
  NotificationDigestRepositoryImpl(NotificationsApi api) : _api = api;

  final NotificationsApi _api;

  @override
  Future<Either<ApiError, NotificationDigest>> getDigest({int? limit}) =>
      guardApiCall(
        () async => _toDigest(await _api.digest(limit: limit)),
        fallbackMessage: 'Nie udało się pobrać digestu powiadomień.',
        parsingMessage: 'Backend zwrócił nieprawidłowy digest powiadomień.',
      );

  NotificationDigest _toDigest(NotificationDigestResponse response) =>
      NotificationDigest(
        generatedAtUtc: response.generatedAtUtc,
        groups: response.groups.map(_toGroup).toList(growable: false),
      );

  NotificationDigestGroup _toGroup(NotificationGroupResponse response) =>
      NotificationDigestGroup(
        groupKey: response.groupKey,
        count: response.count,
        unreadCount: response.unreadCount,
        latest: NotificationDigestItem(
          id: response.latest.id,
          title: response.latest.title,
          body: response.latest.body,
          createdAtUtc: response.latest.createdAtUtc,
          deepLink: response.latest.deepLink,
        ),
        preview: response.preview,
      );
}
