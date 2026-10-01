import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_chat_theme_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('context menu overlay captures task Chat theme in both modes', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final lightTheme = ThemeData(brightness: Brightness.light);
      final darkTheme = ThemeData(brightness: Brightness.dark);
      final baseTheme = brightness == Brightness.dark ? darkTheme : lightTheme;
      final expectedSurface = DevPlannerTasksTheme.of(
        baseTheme.textTheme,
        baseTheme.colorScheme,
      ).canvas;
      final capturedSurfaces = <Color>[];
      final capturedBrightness = <Brightness>[];
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey<Brightness>(brightness),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: Scaffold(
            body: TaskDetailChatThemeScope(
              child: Builder(
                builder: (context) => FilledButton(
                  onPressed: () => AppContextMenu.showCustom(
                    context,
                    globalPosition: AppContextMenu.positionFor(context),
                    contentBuilder: (menuContext, dismiss) {
                      capturedBrightness.add(
                        Theme.of(menuContext).brightness,
                      );
                      capturedSurfaces.add(
                        Theme.of(menuContext)
                            .extension<DevPlannerChatTheme>()!
                            .panelSurface,
                      );
                      return TextButton(
                        onPressed: dismiss,
                        child: const Text('Close overlay'),
                      );
                    },
                  ),
                  child: const Text('Open menu'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        Theme.of(tester.element(find.text('Open menu'))).brightness,
        brightness,
      );
      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();

      expect(find.text('Close overlay'), findsOneWidget);
      expect(capturedBrightness, contains(brightness));
      expect(capturedSurfaces, contains(expectedSurface));
      await tester.tap(find.text('Close overlay'));
      await tester.pumpAndSettle();
    }
  });
}
