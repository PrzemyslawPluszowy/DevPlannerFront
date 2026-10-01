import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_error_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'diagnostics and actions remain usable at 200% in a narrow view',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var refreshed = false;
      final fields = {
        for (var index = 0; index < 14; index++)
          'field_$index': [
            'invalid value $index ${List<String>.filled(12, 'detail').join(' ')}',
          ],
      };
      final traceId = 'trace-${List<String>.filled(45, 'long-id').join('-')}';
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(420, 600),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: TasksErrorBanner(
                  message:
                      'Nie udało się utworzyć zadania. ${List<String>.filled(18, 'Szczegóły odpowiedzi serwera.').join(' ')}',
                  apiError: ApiError(
                    type: ApiErrorType.validation,
                    message:
                        'validation failed ${List<String>.filled(20, 'server response detail').join(' ')}',
                    apiCode: 'tasks.validation',
                    contractCode: 'task.validation',
                    backendCode: 429,
                    statusCode: 422,
                    traceId: traceId,
                    retryAfterUtc: DateTime.utc(2026, 10, 1, 12),
                    fields: fields,
                  ),
                  onRefresh: () => refreshed = true,
                  onRetry: () {},
                  onDismiss: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));
      expect(find.text('Ponów'), findsOneWidget);
      expect(find.text('Odśwież'), findsOneWidget);
      expect(find.textContaining('field_13: invalid value 13'), findsOneWidget);
      expect(find.textContaining('429'), findsOneWidget);
      expect(find.textContaining(traceId), findsOneWidget);
      await tester.ensureVisible(find.text('Odśwież'));
      expect(tester.getSemantics(find.text('Odśwież')), isNotNull);
      await tester.tap(find.text('Odśwież'));
      expect(refreshed, isTrue);
    },
  );
}
