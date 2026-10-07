import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/chat_thread_message_list.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements ChatMessageActionsRepository {}

void main() {
  for (final selected in [false, true]) {
    testWidgets('thread fallback without secondary; selected=$selected', (
      tester,
    ) async {
      final message = ChatMessage(
        id: 'message',
        conversationId: 'chat',
        authorUserId: 'peer',
        clientMessageId: 'client',
        text: 'Thread QA',
        payloadHash: 'hash',
        version: 1,
        createdAtUtc: DateTime.utc(2026),
        isDeleted: false,
        deliveryState: ChatMessageDeliveryState.sent,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ChatThreadMessageList(
              state: ChatThreadReady(messages: [message]),
              rootMessage: message,
              currentUserId: 'me',
              hasTextSelection: selected,
              onSelectionChanged: (_) {},
            ),
          ),
        ),
      );
      // Fallback używa Material Symbols; dostępny przycisk menu jest jedyny.
      final button = find.descendant(
        of: find.byType(ChatMessageBubble),
        matching: find.byType(IconButton),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byType(ChatMessageBubble)));
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text('Kopiuj wiadomość'), findsOneWidget);
      expect(
        find.text('Kopiuj zaznaczenie'),
        selected ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  }
  for (final selection in [false, true]) {
    for (final own in [false, true]) {
      testWidgets(
        'menu selected=$selection own=$own exposes available actions',
        (tester) async {
          final cubit = ChatMessageSecondaryActionsCubit(
            repository: _Repository(),
          );
          addTearDown(cubit.close);
          await tester.pumpWidget(
            MaterialApp(
              theme: MaterialTheme.crm().dark(),
              locale: const Locale('pl'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: BlocProvider.value(
                value: cubit,
                child: Scaffold(
                  body: Center(
                    child: ChatMessageActionMenu(
                      message: ChatMessage(
                        id: 'message',
                        conversationId: 'chat',
                        authorUserId: own ? 'me' : 'peer',
                        clientMessageId: 'client',
                        text: 'QA message',
                        payloadHash: 'hash',
                        version: 1,
                        createdAtUtc: DateTime.utc(2026),
                        isDeleted: false,
                        deliveryState: ChatMessageDeliveryState.sent,
                      ),
                      isOwnMessage: own,
                      canModerate: false,
                      isPinned: false,
                      isBookmarked: false,
                      currentUserId: 'me',
                      hasTextSelection: selection,
                      onEdit: (_) {},
                      onDelete: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.byType(IconButton));
          await tester.pumpAndSettle();
          expect(find.text('Kopiuj wiadomość'), findsOneWidget);
          expect(
            find.text('Kopiuj zaznaczenie'),
            selection ? findsOneWidget : findsNothing,
          );
          expect(find.text('Edytuj'), own ? findsOneWidget : findsNothing);
          expect(find.text('Usuń'), own ? findsOneWidget : findsNothing);
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pumpAndSettle();
          expect(find.text('Kopiuj wiadomość'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
