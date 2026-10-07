import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tab exposes reaction actions before keyboard activation', (
    tester,
  ) async {
    var reactions = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().dark(),
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              ChatMessageBubble(
                message: ChatMessage(
                  id: 'message',
                  conversationId: 'chat',
                  authorUserId: 'peer',
                  clientMessageId: 'client',
                  text: 'QA message',
                  payloadHash: 'hash',
                  version: 1,
                  createdAtUtc: DateTime.utc(2026),
                  isDeleted: false,
                  deliveryState: ChatMessageDeliveryState.sent,
                ),
                isOwn: false,
                maxWidth: 400,
                onPickReaction: (_) => reactions++,
                menu: TextButton(onPressed: () {}, child: const Text('Menu')),
              ),
              TextButton(onPressed: () {}, child: const Text('Outside')),
            ],
          ),
        ),
      ),
    );
    final overlay = find.descendant(
      of: find.byType(ChatMessageBubble),
      matching: find.byType(AnimatedOpacity),
    );
    expect(tester.widget<AnimatedOpacity>(overlay).opacity, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedOpacity>(overlay).opacity, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(reactions, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedOpacity>(overlay).opacity, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedOpacity>(overlay).opacity, 0);
    expect(tester.takeException(), isNull);
  });
}
