import 'dart:convert';

import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('replay decodes every persisted numeric enum ordinal and preserves new text values', () {
    const values = {
      'Type': ['Direct', 'Group', 'Channel', 'Broadcast', 'Discussion'],
      'ConversationType': [
        'Direct',
        'Group',
        'Channel',
        'Broadcast',
        'Discussion',
      ],
      'ScopeKind': ['Global', 'Workspace', 'Project', 'Resource'],
      'Preference': ['All', 'MentionsOnly', 'Muted', 'HighOnly'],
      'Status': ['Sending', 'Sent', 'Delivered', 'Read', 'Failed'],
      'ScanStatus': ['Pending', 'Clean', 'Infected', 'Skipped'],
      'ProcessingStatus': ['None', 'Queued', 'Processing', 'Ready', 'Failed'],
    };
    final mapper = ChatRealtimeEventMapper();
    for (final entry in values.entries) {
      final normalizedKey =
          '${entry.key[0].toLowerCase()}${entry.key.substring(1)}';
      for (var ordinal = 0; ordinal < entry.value.length; ordinal++) {
        final page = mapper.decodeReplay({
          'items': [
            {
              'eventType': 'chat.message.delivered',
              'payloadJson': jsonEncode({entry.key: ordinal}),
            },
          ],
        });
        expect(page.events.single.payload[normalizedKey], entry.value[ordinal]);
        final live = mapper.normalizeLiveEnvelope({
          'PayloadJson': jsonEncode({entry.key: entry.value[ordinal]}),
        })!;
        expect(live[normalizedKey], entry.value[ordinal]);
      }
      final unknown = mapper.normalizeLiveEnvelope({entry.key: 999})!;
      expect(unknown[normalizedKey], 999);
    }
  });
}
