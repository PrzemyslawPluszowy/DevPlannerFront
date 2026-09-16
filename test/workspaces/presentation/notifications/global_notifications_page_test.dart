import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/global_notifications_page.dart';

class _OfflineNotificationsRepository implements NotificationsRepository {
  bool offline = false;

  @override
  Future<Either<ApiError, int>> unreadCount() async => const Right(1);

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => offline
      ? const Left(ApiError(type: ApiErrorType.connection, message: 'Offline.'))
      : Right(CursorPageResponse(items: [_notificationGroup]));

  @override
  Future<Either<ApiError, void>> archiveGroup(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, void>> markAllRead() async => const Right(null);

  @override
  Future<Either<ApiError, void>> markGroupRead(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  ) async => const Right(null);

  static final _notificationGroup = NotificationGroupResponse(
    groupKey: 'workspace:7',
    count: 1,
    unreadCount: 1,
    notificationIds: const ['notification-7'],
    latest: WorkspaceNotificationResponse(
      id: 'notification-7',
      sourceModule: 'workspaces',
      eventType: 'workspace.updated',
      entityType: 'workspace',
      entityId: '7',
      title: 'Aktualizacja',
      body: 'Treść powiadomienia.',
      eventId: 'event-7',
      contractVersion: 1,
      createdAtUtc: DateTime.utc(2026),
      isPinned: false,
      category: NotificationCategory.workspace,
      priority: NotificationPriority.normal,
    ),
  );
}

void main() {
  testWidgets('compact zachowuje inbox i pokazuje zwarty banner offline', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final repository = _OfflineNotificationsRepository();
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();
    repository.offline = true;
    await cubit.load();

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(
          locale: Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GlobalNotificationsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Nie udało się odświeżyć powiadomień: Offline.'),
      findsOneWidget,
    );
    expect(find.text('Aktualizacja'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
