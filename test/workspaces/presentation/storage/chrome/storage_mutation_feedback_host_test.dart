import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_feedback_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Repository extends Mock implements StorageRepository {}

void main() {
  for (final variant in [
    (locale: const Locale('en'), dark: false),
    (locale: const Locale('pl'), dark: true),
  ]) {
    testWidgets(
      'shell error area remains bounded and actions accessible at 200% '
      '${variant.locale.languageCode} dark=${variant.dark}',
      (tester) => _verifyFeedbackLayout(
        tester,
        locale: variant.locale,
        dark: variant.dark,
      ),
    );
  }
}

Future<void> _verifyFeedbackLayout(
  WidgetTester tester, {
  required Locale locale,
  required bool dark,
}) async {
  tester.view.physicalSize = const Size(840, 1200);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final error = ApiError(
    type: ApiErrorType.badResponse,
    statusCode: 429,
    message: List.filled(
      5,
      'Serwer chwilowo wstrzymał kolejne żądania.',
    ).join(' '),
    apiCode: 'storage.rate_limited',
    contractCode: 'throttled_request',
    backendCode: 429,
    traceId: 'trace-long-feedback',
    retryAfterUtc: DateTime.now().toUtc().add(const Duration(minutes: 1)),
    fields: {
      for (var index = 0; index < 18; index++)
        'field-$index': [List.filled(5, 'wartość-walidacji').join(' ')],
    },
  );
  final feedback = ValueNotifier<StorageMutationError?>(
    StorageMutationError(
      message: error.message,
      code: error.apiCode,
      traceId: error.traceId,
      apiError: error,
      onRetry: () {},
    ),
  );
  final repository = _Repository();
  final browser = StorageBrowserCubit(
    repository: repository,
  );
  var refreshCount = 0;
  var dismissCount = 0;
  addTearDown(feedback.dispose);
  addTearDown(browser.close);
  final l10n = await AppLocalizations.delegate.load(locale);

  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? MaterialTheme.crm().dark() : MaterialTheme.crm().light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: BlocProvider.value(
          value: browser,
          child: Scaffold(
            body: Column(
              children: [
                StorageShellFeedbackArea(
                  availableHeight: 600,
                  errorListenable: feedback,
                  onRefresh: () => refreshCount++,
                  onDismiss: () => dismissCount++,
                ),
                const Expanded(
                  child: ColoredBox(
                    key: Key('shell-results-viewport'),
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final diagnostics = find.byType(ExpansionTile).first;
  await tester.ensureVisible(diagnostics);
  await tester.pumpAndSettle();
  await tester.tap(diagnostics);
  await tester.pumpAndSettle();

  expect(find.textContaining('storage.rate_limited'), findsWidgets);
  expect(find.textContaining('trace-long-feedback'), findsWidgets);
  expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(2));
  expect(
    tester.getSize(find.byKey(const Key('shell-results-viewport'))).height,
    greaterThan(200),
  );
  expect(find.bySemanticsLabel(error.message), findsOneWidget);

  final retry = find.widgetWithText(TextButton, l10n.tasksViewErrorRetry);
  await tester.ensureVisible(retry);
  await tester.pumpAndSettle();
  expect(tester.widget<TextButton>(retry).onPressed, isNull);
  expect(_insideViewport(tester.getRect(retry)), isTrue);

  final refresh = find.widgetWithText(TextButton, l10n.tasksViewErrorRefresh);
  await tester.ensureVisible(refresh);
  await tester.pumpAndSettle();
  expect(_insideViewport(tester.getRect(refresh)), isTrue);
  await tester.tap(refresh);
  expect(refreshCount, 1);

  final dismiss = find.byTooltip(l10n.tasksViewErrorDismissTooltip);
  await tester.ensureVisible(dismiss);
  await tester.pumpAndSettle();
  expect(_insideViewport(tester.getRect(dismiss)), isTrue);
  await tester.tap(dismiss);
  expect(dismissCount, 1);
  expect(tester.takeException(), isNull);
}

bool _insideViewport(Rect rect) =>
    rect.left >= 0 && rect.top >= 0 && rect.right <= 420 && rect.bottom <= 600;
