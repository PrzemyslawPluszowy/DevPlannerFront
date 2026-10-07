import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_list.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Members extends Mock implements ChatMembersRepository {}

class _Management extends Mock
    implements ChatConversationManagementRepository {}

class _Observer extends NavigatorObserver {
  _Observer(this.events);
  final List<String> events;
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    events.add('pop');
  }
}

void main() {
  for (final closeWhilePending in [false, true]) {
    testWidgets(
      'Napisz closes originating layers; cancel during pending=$closeWhilePending',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final members = _Members();
        final management = _Management();
        final events = <String>[];
        final controller = DevPlannerPanelsController();
        addTearDown(controller.dispose);
        final direct = ChatConversation(
          id: 'direct',
          type: 'direct',
          scopeKind: 'global',
          scopeKey: 'direct',
          version: 1,
          createdAtUtc: DateTime.utc(2026),
          postingPermission: 'Everyone',
          isArchived: false,
        );
        registerFallbackValue(
          const ChatConversationCreateCommand(
            kind: ChatConversationKind.direct,
            scope: ChatConversationScope.global,
            scopeKey: 'direct',
            userIds: ['peer'],
          ),
        );
        when(() => members.listMembers('group')).thenAnswer(
          (_) async => Right([
            ChatMember(
              userId: 'me',
              role: ChatMemberRole.member,
              joinedAtUtc: DateTime.utc(2026),
              displayName: 'Me',
            ),
            ChatMember(
              userId: 'peer',
              role: ChatMemberRole.member,
              joinedAtUtc: DateTime.utc(2026),
              displayName: 'QA peer',
              login: 'qa.peer',
            ),
          ]),
        );
        final pending = Completer<Either<ApiError, ChatConversation>>();
        when(() => management.createConversation(any()))
            .thenAnswer((_) => pending.future);
        await tester.pumpWidget(
          MaterialApp(
            theme: MaterialTheme.crm().dark(),
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            navigatorObservers: [_Observer(events)],
            home: DevPlannerPanelsScope(
              controller: controller,
              openConversation: (id) => events.add('open:$id'),
              child: Scaffold(
                body: _Launcher(members: members, management: management),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Members'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('QA peer'));
        await tester.pumpAndSettle();
        expect(find.text('Konto: qa.peer'), findsOneWidget);
        expect(find.textContaining('Wiadomość wyślesz'), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('chat-person-write')));
        await tester.pump();
        expect(
          tester
              .widget<FilledButton>(
                find.byKey(const ValueKey('chat-person-write')),
              )
              .onPressed,
          isNull,
        );
        expect(events, isEmpty);
        if (closeWhilePending) {
          await tester.tap(find.widgetWithText(TextButton, 'Zamknij'));
          await tester
              .pump(); // State remains mounted during reverse transition.
        }
        pending.complete(Right(direct));
        await tester.pumpAndSettle();
        expect(
          events,
          closeWhilePending ? ['pop'] : ['pop', 'pop', 'open:direct'],
        );
        expect(
          find.byType(ChatMembersList),
          closeWhilePending ? findsOneWidget : findsNothing,
        );
        expect(
          find.textContaining('QA group'),
          closeWhilePending ? findsOneWidget : findsNothing,
        );
        expect(find.text('Konto: qa.peer'), findsNothing);
        verify(() => management.createConversation(any())).called(1);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _Launcher extends StatelessWidget {
  const _Launcher({required this.members, required this.management});
  final ChatMembersRepository members;
  final ChatConversationManagementRepository management;
  void _open(BuildContext context) {
    unawaited(
      ChatMembersSheet.show(
        context,
        membersRepository: members,
        conversationManagement: management,
        currentUserId: 'me',
        conversation: ChatConversation(
          id: 'group',
          type: 'group',
          scopeKind: 'global',
          scopeKey: 'group',
          name: 'QA group',
          version: 1,
          createdAtUtc: DateTime.utc(2026),
          postingPermission: 'Everyone',
          isArchived: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: () => _open(context), child: const Text('Members'));
}
