import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_conversation_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('conversation diagnostics retain retry at 200%; dark=$dark', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var retries = 0;
      final error = ApiError(
        type: ApiErrorType.server,
        message: List.filled(20, 'Conversation request failed').join(' '),
        statusCode: 503,
        apiCode: 'chat.resolve',
        contractCode: 'resolve_failed',
        traceId: 'conversation-trace',
        fields: {
          for (var i = 0; i < 30; i++) 'field-$i': ['Validation diagnostic'],
        },
      );
      Widget app({required bool enabled}) => MaterialApp(
        theme: dark ? MaterialTheme.crm().dark() : MaterialTheme.crm().light(),
        locale: Locale(dark ? 'pl' : 'en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: SizedBox(
            height: 300,
            child: TaskDetailConversationFeedback(
              error: error,
              onRetry: enabled ? () => retries++ : null,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app(enabled: true));
      await tester.pumpAndSettle();
      final retry = find.byKey(
        const ValueKey('task_conversation_resolve_retry'),
      );
      expect(retry.hitTestable(), findsOneWidget);
      await tester.tap(retry);
      expect(retries, 1);
      await tester.scrollUntilVisible(
        find.textContaining('conversation-trace'),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('conversation-trace'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(app(enabled: false));
      await tester.pumpAndSettle();
      expect(tester.widget<TextButton>(retry).onPressed, isNull);
      expect(retry.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
