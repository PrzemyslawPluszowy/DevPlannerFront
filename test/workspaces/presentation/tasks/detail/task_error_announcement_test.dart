import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_failure_view.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final office in [false, true]) {
    testWidgets(
      'preview announces failure, keeping retry separate (office=$office)',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          var retries = 0;
          await tester.pumpWidget(
            _app(
              StoragePreviewFailureView(
                message: 'Access revoked',
                title: office ? 'Document session failed' : null,
                error: _error,
                onRetry: () async {
                  retries++;
                },
              ),
            ),
          );
          final alert = find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && widget.properties.liveRegion == true,
          );
          expect(alert, findsOneWidget);
          expect(
            tester
                .getSemantics(alert.last)
                .getSemanticsData()
                .flagsCollection
                .isLiveRegion,
            isTrue,
          );
          expect(
            tester.getSemantics(alert).getSemanticsData().value,
            contains('Access revoked'),
          );
          expect(find.textContaining('error-trace'), findsOneWidget);
          expect(
            tester
                .getSemantics(find.text('Retry'))
                .getSemanticsData()
                .flagsCollection
                .isButton,
            isTrue,
          );
          await tester.tap(find.text('Retry'));
          expect(retries, 1);
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets(
    'task announces updated error without merging diagnostic controls',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          _app(const TaskDetailsModalError(error: _error)),
        );
        final alert = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.liveRegion == true &&
              widget.container,
        );
        expect(alert, findsOneWidget);
        expect(
          tester
              .getSemantics(alert)
              .getSemanticsData()
              .flagsCollection
              .isLiveRegion,
          isTrue,
        );
        expect(
          tester.getSemantics(alert).getSemanticsData().value,
          contains('Access revoked'),
        );
        expect(find.textContaining('error-trace'), findsNothing);
        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();
        expect(find.textContaining('error-trace'), findsOneWidget);
        await tester.pumpWidget(
          _app(
            const TaskDetailsModalError(
              error: ApiError(
                type: ApiErrorType.validation,
                message: 'Choose another date',
              ),
            ),
          ),
        );
        expect(alert, findsOneWidget);
        expect(find.text('Access revoked'), findsNothing);
        expect(find.text('Choose another date'), findsOneWidget);
        expect(
          tester.getSemantics(alert).getSemanticsData().value,
          contains('Choose another date'),
        );
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}

const _error = ApiError(
  type: ApiErrorType.forbidden,
  message: 'Access revoked',
  traceId: 'error-trace',
);

Widget _app(Widget child) => MaterialApp(
  theme: MaterialTheme.crm().light(),
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
