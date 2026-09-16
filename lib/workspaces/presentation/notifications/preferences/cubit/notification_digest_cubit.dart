import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_digest.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_digest_repository.dart';

/// Właściciel read-only snapshotu digestu bez mutacji inboxa.
final class NotificationDigestCubit extends Cubit<NotificationDigestState> {
  NotificationDigestCubit(this._repository)
    : super(const NotificationDigestLoading());

  final NotificationDigestRepository _repository;
  int _requestGeneration = 0;

  /// Pobiera bieżący digest; limit pozostaje kontrolowany przez port/backend.
  Future<void> load({int? limit}) async {
    final requestGeneration = ++_requestGeneration;
    emit(const NotificationDigestLoading());
    final result = await _repository.getDigest(limit: limit);
    if (isClosed || requestGeneration != _requestGeneration) return;
    result.fold(
      (error) => emit(NotificationDigestFailure(error)),
      (digest) => digest.groups.isEmpty
          ? emit(NotificationDigestEmpty(digest))
          : emit(NotificationDigestReady(digest)),
    );
  }
}

/// Stan wyłącznie do odczytu digestu użytkownika.
sealed class NotificationDigestState {
  const NotificationDigestState();
}

final class NotificationDigestLoading extends NotificationDigestState {
  const NotificationDigestLoading();
}

final class NotificationDigestFailure extends NotificationDigestState {
  const NotificationDigestFailure(this.error);

  final ApiError error;
}

final class NotificationDigestEmpty extends NotificationDigestState {
  const NotificationDigestEmpty(this.digest);

  final NotificationDigest digest;
}

final class NotificationDigestReady extends NotificationDigestState {
  const NotificationDigestReady(this.digest);

  final NotificationDigest digest;
}
