import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/chat_theme.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_action_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final brightness in Brightness.values) {
    for (final width in [320.0, 1280.0]) {
      testWidgets('bounded opaque action sheet $brightness width $width', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 720);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final theme = ThemeData(brightness: brightness);
        final chat = DevPlannerChatTheme.of(theme.textTheme, theme.colorScheme);
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () => DevPlannerModalHost.showSideSheet<void>(
                  context,
                  builder: (_) => const ChatActionSideSheet(
                    key: ValueKey('sheet'),
                    child: Text('Message preview'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byKey(const ValueKey('sheet'))).width,
          width < 480 ? width : 480,
        );
        final material = tester.widget<Material>(
          find
              .descendant(
                of: find.byKey(const ValueKey('sheet')),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(material.color, chat.panelSurface);
        expect(material.color!.a, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
