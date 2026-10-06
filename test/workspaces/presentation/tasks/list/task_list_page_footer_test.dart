import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_page_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in ['pl', 'en']) {
    testWidgets('page footer exposes pending, full error and retry $locale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(380, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var calls = 0;
      Widget app({bool loading = false, ApiError? error}) => MaterialApp(
        locale: Locale(locale),
        theme: locale == 'pl'
            ? MaterialTheme.crm().dark()
            : MaterialTheme.crm().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskListPageFooter(
            isLoading: loading,
            isBlocked: false,
            error: error,
            onLoadMore: () => calls++,
          ),
        ),
      );
      await tester.pumpWidget(app(loading: true));
      final pending = tester.widget<TextButton>(find.byType(TextButton));
      expect(pending.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpWidget(
        app(
          error: const ApiError(
            type: ApiErrorType.conflict,
            message: 'tasks.list.page_changed',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          locale == 'pl' ? 'Zadania zmieniły się' : 'Tasks changed',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(locale == 'pl' ? 'Ponów próbę' : 'Retry'));
      expect(calls, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        app(
          error: const ApiError(
            type: ApiErrorType.forbidden,
            message: 'Brak dostępu',
          ),
        ),
      );
      expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed,
        isNull,
      );
      expect(find.text('Brak dostępu'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
