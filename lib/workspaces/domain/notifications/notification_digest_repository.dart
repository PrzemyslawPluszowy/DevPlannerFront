// Repository stays a port instead of a global function to keep dependency
// injection and error contracts explicit at the presentation boundary.
// ignore_for_file: one_member_abstracts

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_digest.dart';

/// Port read-only snapshotu digestu powiadomień użytkownika.
abstract interface class NotificationDigestRepository {
  /// Pobiera digest-only grupy, zachowując kontrolowany limit backendu.
  Future<Either<ApiError, NotificationDigest>> getDigest({int? limit});
}
