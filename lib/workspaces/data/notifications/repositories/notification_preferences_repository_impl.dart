import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/notifications/api/notifications_api.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart'
    as transport;
import 'package:ready_next/workspaces/domain/notifications/models/notification_preferences.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_preferences_repository.dart';

/// Adapter transportu dla ustawień globalnego dostarczania i Storage.
final class NotificationPreferencesRepositoryImpl extends ApiRepository
    implements NotificationPreferencesRepository {
  /// Tworzy adapter na prywatnym kliencie powiadomień Workspaces.
  NotificationPreferencesRepositoryImpl(NotificationsApi api) : _api = api;

  final NotificationsApi _api;

  @override
  Future<Either<ApiError, NotificationDeliveryPreferences>>
  getDeliveryPreferences() => guardApiCall(
    () async => _toDeliveryPreferences(await _api.getDeliveryPreferences()),
    fallbackMessage: 'Nie udało się pobrać preferencji dostarczania.',
    parsingMessage: 'Backend zwrócił nieprawidłowe preferencje dostarczania.',
  );

  @override
  Future<Either<ApiError, NotificationDeliveryPreferences>>
  updateDeliveryPreferences(
    UpdateNotificationDeliveryPreferencesCommand command,
  ) => guardApiCall(
    () async => _toDeliveryPreferences(
      await _api.updateDeliveryPreferences(_toDeliveryPayload(command)),
    ),
    fallbackMessage: 'Nie udało się zapisać preferencji dostarczania.',
    parsingMessage: 'Backend zwrócił nieprawidłowe preferencje dostarczania.',
  );

  @override
  Future<Either<ApiError, StorageNotificationPreference>>
  getStoragePreference() => guardApiCall(
    () async => _toStoragePreference(await _api.getStoragePreference()),
    fallbackMessage: 'Nie udało się pobrać preferencji powiadomień plików.',
    parsingMessage: 'Backend zwrócił nieprawidłową preferencję plików.',
  );

  @override
  Future<Either<ApiError, StorageNotificationPreference>>
  updateStoragePreference(StorageNotificationMode mode) => guardApiCall(
    () async => _toStoragePreference(
      await _api.updateStoragePreference(
        UpdateStorageNotificationPreferencePayload(mode: _toStorageMode(mode)),
      ),
    ),
    fallbackMessage: 'Nie udało się zapisać preferencji powiadomień plików.',
    parsingMessage: 'Backend zwrócił nieprawidłową preferencję plików.',
  );

  NotificationDeliveryPreferences _toDeliveryPreferences(
    NotificationDeliveryPreferenceResponse response,
  ) => NotificationDeliveryPreferences(
    coreUserId: response.coreUserId,
    modes: {
      NotificationDeliveryCategory.invitation: _toEmailMode(
        response.invitation.emailMode,
      ),
      NotificationDeliveryCategory.membership: _toEmailMode(
        response.membership.emailMode,
      ),
      NotificationDeliveryCategory.workspace: _toEmailMode(
        response.workspace.emailMode,
      ),
      NotificationDeliveryCategory.project: _toEmailMode(
        response.project.emailMode,
      ),
      NotificationDeliveryCategory.task: _toEmailMode(response.task.emailMode),
      NotificationDeliveryCategory.comment: _toEmailMode(
        response.comment.emailMode,
      ),
      NotificationDeliveryCategory.chat: _toEmailMode(response.chat.emailMode),
      NotificationDeliveryCategory.storage: _toEmailMode(
        response.storage.emailMode,
      ),
      NotificationDeliveryCategory.system: _toEmailMode(
        response.system.emailMode,
      ),
    },
    updatedAtUtc: response.updatedAtUtc,
  );

  UpdateNotificationDeliveryPreferencePayload _toDeliveryPayload(
    UpdateNotificationDeliveryPreferencesCommand command,
  ) => UpdateNotificationDeliveryPreferencePayload(
    invitation: _toTransportEmailMode(command.invitation),
    membership: _toTransportEmailMode(command.membership),
    workspace: _toTransportEmailMode(command.workspace),
    project: _toTransportEmailMode(command.project),
    task: _toTransportEmailMode(command.task),
    comment: _toTransportEmailMode(command.comment),
    chat: _toTransportEmailMode(command.chat),
    storage: _toTransportEmailMode(command.storage),
    system: _toTransportEmailMode(command.system),
  );

  StorageNotificationPreference _toStoragePreference(
    StorageNotificationPreferenceResponse response,
  ) => StorageNotificationPreference(
    coreUserId: response.coreUserId,
    mode: _fromStorageMode(response.mode),
    isDefault: response.isDefault,
    updatedAtUtc: response.updatedAtUtc,
  );

  NotificationEmailDeliveryMode _toEmailMode(
    transport.NotificationEmailDeliveryMode value,
  ) => switch (value) {
    transport.NotificationEmailDeliveryMode.none =>
      NotificationEmailDeliveryMode.none,
    transport.NotificationEmailDeliveryMode.immediate =>
      NotificationEmailDeliveryMode.immediate,
    transport.NotificationEmailDeliveryMode.dailyDigest =>
      NotificationEmailDeliveryMode.dailyDigest,
    transport.NotificationEmailDeliveryMode.digest =>
      NotificationEmailDeliveryMode.digest,
  };

  transport.NotificationEmailDeliveryMode? _toTransportEmailMode(
    NotificationEmailDeliveryMode? value,
  ) => switch (value) {
    null => null,
    NotificationEmailDeliveryMode.none =>
      transport.NotificationEmailDeliveryMode.none,
    NotificationEmailDeliveryMode.immediate =>
      transport.NotificationEmailDeliveryMode.immediate,
    NotificationEmailDeliveryMode.dailyDigest =>
      transport.NotificationEmailDeliveryMode.dailyDigest,
    NotificationEmailDeliveryMode.digest =>
      transport.NotificationEmailDeliveryMode.digest,
  };

  StorageNotificationMode _fromStorageMode(
    transport.StorageNotificationPreferenceMode value,
  ) => switch (value) {
    transport.StorageNotificationPreferenceMode.immediate =>
      StorageNotificationMode.immediate,
    transport.StorageNotificationPreferenceMode.digest =>
      StorageNotificationMode.digest,
    transport.StorageNotificationPreferenceMode.mentionsOnly =>
      StorageNotificationMode.mentionsOnly,
    transport.StorageNotificationPreferenceMode.disabled =>
      StorageNotificationMode.disabled,
  };

  transport.StorageNotificationPreferenceMode _toStorageMode(
    StorageNotificationMode value,
  ) => switch (value) {
    StorageNotificationMode.immediate =>
      transport.StorageNotificationPreferenceMode.immediate,
    StorageNotificationMode.digest =>
      transport.StorageNotificationPreferenceMode.digest,
    StorageNotificationMode.mentionsOnly =>
      transport.StorageNotificationPreferenceMode.mentionsOnly,
    StorageNotificationMode.disabled =>
      transport.StorageNotificationPreferenceMode.disabled,
  };
}
