import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_time_tracking.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

TaskTimeEntryResponse _entry({
  TaskTimeEntryApprovalStatus status = TaskTimeEntryApprovalStatus.approved,
  String? reviewerId = 'reviewer-uuid-123',
  DateTime? reviewedAt,
  bool includeReviewedAt = true,
  String? comment = 'Approved after checking the submitted work.',
  bool canReview = false,
}) => TaskTimeEntryResponse(
  id: 'time-entry-1',
  taskId: 'task-1',
  userId: 'author-uuid-1',
  kind: TaskTimeEntryKind.manual,
  startedAtUtc: DateTime.utc(2026, 10, 2, 10),
  stoppedAtUtc: DateTime.utc(2026, 10, 2, 10, 5),
  durationMinutes: 5,
  description: 'Manual review entry',
  isBillable: true,
  createdAtUtc: DateTime.utc(2026, 10, 2),
  approvalStatus: status,
  reviewedByUserId: reviewerId,
  reviewedAtUtc:
      reviewedAt ??
      (includeReviewedAt ? DateTime.utc(2026, 10, 2, 10, 15) : null),
  reviewComment: comment,
  version: 2,
  canReview: canReview,
);

void main() {
  const longComment =
      'Please correct the long work description and include the deployment '
      'reference before the next review. This text intentionally wraps across '
      'multiple lines at narrow widths.';

  for (final locale in ['pl', 'en']) {
    for (final status in [
      TaskTimeEntryApprovalStatus.approved,
      TaskTimeEntryApprovalStatus.rejected,
    ]) {
      testWidgets(
        'shows ${status.name} review details in $locale at narrow width and 200% text',
        (tester) async {
          final reviewer = locale == 'pl' ? 'Anna Nowak' : 'Alex Reviewer';
          await tester.pumpWidget(
            _app(
              locale: locale,
              textScale: 2,
              child: SizedBox(
                width: 360,
                child: ListView(
                  children: [
                    TimeEntryTile(
                      entry: _entry(status: status, comment: longComment),
                      isSaving: false,
                      nowUtc: DateTime.utc(2026, 10, 2, 11),
                      reviewerName: reviewer,
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.textContaining(reviewer), findsOneWidget);
          expect(find.text(longComment), findsOneWidget);
          expect(find.textContaining('reviewer-uuid-123'), findsNothing);
          final dateText = DateFormat.yMMMd(locale)
              .add_jm()
              .format(DateTime.utc(2026, 10, 2, 10, 15).toLocal());
          expect(find.text(dateText), findsOneWidget);
          expect(tester.takeException(), isNull);
          expect(
            find.byIcon(
              status == TaskTimeEntryApprovalStatus.approved
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
            ),
            findsOneWidget,
          );
        },
      );
    }
  }

  for (final locale in ['pl', 'en']) {
    testWidgets('uses neutral fallback labels in $locale', (tester) async {
      await tester.pumpWidget(
        _app(
          locale: locale,
          textScale: 1,
          child: TimeEntryTile(
            entry: _entry(
              includeReviewedAt: false,
              comment: null,
            ),
            isSaving: false,
            nowUtc: DateTime.utc(2026, 10, 2, 11),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(TimeEntryTile)),
      )!;
      expect(
        find.text(l10n.taskDetailsTimeReviewerUnavailable),
        findsOneWidget,
      );
      expect(
        find.text(l10n.taskDetailsTimeReviewDateUnavailable),
        findsOneWidget,
      );
      expect(find.textContaining('reviewer-uuid-123'), findsNothing);
    });
  }

  testWidgets('keeps submitted review controls available', (tester) async {
    await tester.pumpWidget(
      _app(
        locale: 'en',
        textScale: 1,
        child: TimeEntryTile(
          entry: _entry(
            status: TaskTimeEntryApprovalStatus.submitted,
            canReview: true,
            comment: null,
          ),
          isSaving: false,
          nowUtc: DateTime.utc(2026, 10, 2, 11),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Approve time entry'), findsOneWidget);
    expect(find.byTooltip('Reject time entry'), findsOneWidget);
    expect(find.textContaining('Reviewed by'), findsNothing);
  });

  testWidgets('shows structured profile error while keeping time row visible', (
    tester,
  ) async {
    final entry = TaskTimeEntryResponse(
      id: 'entry-1',
      taskId: 'task-1',
      userId: 'author-uuid',
      kind: TaskTimeEntryKind.manual,
      startedAtUtc: DateTime.utc(2026, 10, 2, 10),
      stoppedAtUtc: DateTime.utc(2026, 10, 2, 10, 5),
      durationMinutes: 5,
      description: 'Reviewed work',
      isBillable: true,
      createdAtUtc: DateTime.utc(2026, 10, 2),
      approvalStatus: TaskTimeEntryApprovalStatus.approved,
      reviewedByUserId: 'reviewer-uuid',
      reviewedAtUtc: DateTime.utc(2026, 10, 2, 10, 15),
      reviewComment: 'Reviewed',
      version: 2,
    );
    final state = TaskTimeTrackingReady(
      entries: [entry],
      reviewerLookupFailure: const ApiError(
        type: ApiErrorType.server,
        message: 'Profile service unavailable',
        statusCode: 429,
        traceId: 'reviewer-profile-trace',
      ),
      isReviewerLookupRetryBlocked: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: MaterialTheme.crm().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TaskDetailsModalTheme(
          child: Scaffold(
            body: TimeTrackingReady(state: state, isEditable: false),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile service unavailable'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            widget.textSpan?.toPlainText().contains('reviewer-profile-trace') ==
                true,
      ),
      findsOneWidget,
    );
    expect(find.text('Reviewed work'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    final retry = tester.widget<TextButton>(
      find.widgetWithText(
        TextButton,
        'Retry',
      ),
    );
    expect(retry.onPressed, isNull);
  });
}

Widget _app({
  required String locale,
  required double textScale,
  required Widget child,
}) => MaterialApp(
  locale: Locale(locale),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: child,
    ),
  ),
);
