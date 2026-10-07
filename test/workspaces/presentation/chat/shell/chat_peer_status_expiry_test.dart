import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_presence.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_client.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_user_status_changed.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_peer_status_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final switchUser in [false, true]) {
    testWidgets(
      'late REST cannot cancel realtime expiry (switch user: $switchUser)',
      (
        tester,
      ) async {
        final repository = _DelayedStatusRepository(switchUser ? 2 : 1);
        final realtime = _StatusRealtime();
        final presence = ChatConversationPresenceCubit(realtime: realtime);
        Widget app(String userId) =>
            RepositoryProvider<ChatPresenceRepository>.value(
              value: repository,
              child: BlocProvider.value(
                value: presence,
                child: MaterialApp(
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: Scaffold(body: ChatPeerStatusLine(userId: userId)),
                ),
              ),
            );
        await tester.pumpWidget(app(switchUser ? 'other' : 'peer'));
        final now = DateTime.now().toUtc();
        realtime.statuses.add(
          ChatUserStatusChanged(
            userId: 'peer',
            status: ChatUserStatus(
              userId: 'peer',
              isDnd: false,
              updatedAtUtc: now,
              text: 'New realtime status',
              expiresAtUtc: now.add(const Duration(seconds: 10)),
            ),
          ),
        );
        await tester.pump();
        if (switchUser) await tester.pumpWidget(app('peer'));
        expect(find.textContaining('New realtime status'), findsOneWidget);
        for (final pending in repository.pending) {
          pending.complete(const Right(null));
        }
        await tester.pump();
        expect(find.textContaining('New realtime status'), findsOneWidget);
        await tester.pump(const Duration(seconds: 11));
        await tester.pump();
        expect(find.textContaining('New realtime status'), findsNothing);
        expect(repository.reads, switchUser ? 3 : 2);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(() async {
          await presence.close();
          await realtime.statuses.close();
          await realtime.snapshots.close();
        });
      },
    );
  }
  for (final switchDuringRecovery in [false, true]) {
    testWidgets(
      'disconnect reloads custom status (switch user: $switchDuringRecovery)',
      (tester) async {
        final repository = _DelayedStatusRepository(1);
        final realtime = _StatusRealtime();
        final presence = ChatConversationPresenceCubit(realtime: realtime);
        Widget app(String userId) =>
            RepositoryProvider<ChatPresenceRepository>.value(
              value: repository,
              child: BlocProvider.value(
                value: presence,
                child: MaterialApp(
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: Scaffold(body: ChatPeerStatusLine(userId: userId)),
                ),
              ),
            );
        await tester.pumpWidget(app('peer'));
        final snapshot = ChatConversationPresenceSnapshot(
          conversationId: 'conversation',
          users: const [],
          changedAtUtc: DateTime.now().toUtc(),
        );
        realtime.snapshots.add(snapshot);
        await tester.pump();
        await tester.pump();
        realtime.statuses.add(
          ChatUserStatusChanged(
            userId: 'peer',
            status: ChatUserStatus(
              userId: 'peer',
              text: 'Status before disconnect',
              isDnd: false,
              updatedAtUtc: DateTime.now().toUtc(),
            ),
          ),
        );
        await tester.pump();
        await tester.pump();
        expect(find.textContaining('Status before disconnect'), findsOneWidget);
        realtime.snapshots.add(null);
        await tester.pump();
        await tester.pump();
        expect(find.textContaining('Status before disconnect'), findsNothing);
        repository.pending.single.complete(const Right(null));
        await tester.pump();
        if (switchDuringRecovery) {
          await tester.pumpWidget(app('other'));
          await tester.pump();
        }
        expect(repository.reads, 1);
        realtime.snapshots.add(snapshot);
        await tester.pump();
        await tester.pump();
        expect(repository.reads, 2);
        expect(find.textContaining('Status before disconnect'), findsNothing);
        realtime.snapshots.add(snapshot);
        await tester.pump();
        expect(repository.reads, 2);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(() async {
          await presence.close();
          await realtime.statuses.close();
          await realtime.snapshots.close();
        });
      },
    );
  }
}

final class _DelayedStatusRepository implements ChatPresenceRepository {
  _DelayedStatusRepository(this.delayedReads);
  final int delayedReads;
  final pending = <Completer<Either<ApiError, ChatUserStatus?>>>[];
  int reads = 0;
  @override
  Future<Either<ApiError, ChatUserStatus?>> getUserStatus(String userId) {
    reads++;
    if (reads > delayedReads) return Future.value(const Right(null));
    final request = Completer<Either<ApiError, ChatUserStatus?>>();
    pending.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _StatusRealtime implements ChatConversationRealtimeClient {
  final statuses = StreamController<ChatUserStatusChanged>.broadcast();
  final snapshots =
      StreamController<ChatConversationPresenceSnapshot?>.broadcast();
  @override
  Stream<ChatUserStatusChanged> get userStatusChanges => statuses.stream;
  @override
  Stream<ChatConversationPresenceSnapshot?> get presenceSnapshots =>
      snapshots.stream;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
