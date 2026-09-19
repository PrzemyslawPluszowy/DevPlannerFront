import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_error_messages.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_error_banner.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zamienia błąd widoku na trwały banner z akcjami naprawy.
///
/// Moduł Tasks ma dwa źródła błędów widoku — ustawienia Kanbana i ustawienia
/// Listy — więc banner pokazuje ten, który dotyczy widoku na ekranie, a gdy ten
/// jest czysty, ten drugi. Komunikat nie ginie po przełączeniu widoku.
class TasksErrorBannerHost extends StatelessWidget {
  const TasksErrorBannerHost({required this.boardActive, super.key});

  /// Czy na ekranie jest tablica Kanban; decyduje o kolejności komunikatów.
  final bool boardActive;

  @override
  Widget build(BuildContext context) {
    // Oba źródła są odczytywane w jednym przebiegu, żeby przełączenie widoku
    // nie gubiło błędu drugiego z nich.
    final board = _boardError(context);
    final preferences = _preferencesError(context);
    final ordered = boardActive
        ? [board, preferences]
        : [preferences, board];
    for (final candidate in ordered) {
      if (candidate != null) return candidate;
    }
    return const SizedBox.shrink();
  }

  Widget? _boardError(BuildContext context) {
    final cubit = context.watch<TasksBoardCubit?>();
    if (cubit == null) return null;
    final error = switch (cubit.state) {
      TasksBoardReady(:final error) => error,
      _ => null,
    };
    if (error == null) return null;
    return TasksErrorBanner(
      message: tasksViewErrorMessage(context, error),
      traceId: error.traceId,
      onRetry: error.canRetry
          ? () => unawaited(cubit.retryFailedOperation())
          : null,
      onRefresh: () => unawaited(cubit.load(force: true)),
      onDismiss: cubit.clearViewError,
    );
  }

  Widget? _preferencesError(BuildContext context) {
    final cubit = context.watch<TaskListPreferencesCubit?>();
    if (cubit == null) return null;
    final (error, canRetry, canDismiss) = switch (cubit.state) {
      // Nieudany odczyt ustawień niesie komunikat Backendu i zostawia samo
      // „Odśwież”: nie ma czego ponawiać, a ukrycie komunikatu bez naprawy
      // zostawiłoby Listę bez kolumn i sortowania.
      TaskListPreferencesError(:final message) => (
        TasksViewError(code: message, canRetry: false),
        false,
        false,
      ),
      TaskListPreferencesReady(:final saveFailure) => (
        saveFailure,
        saveFailure?.canRetry ?? false,
        true,
      ),
      _ => (null, false, false),
    };
    if (error == null) return null;
    return TasksErrorBanner(
      message: tasksViewErrorMessage(context, error),
      traceId: error.traceId,
      onRetry: canRetry ? () => unawaited(cubit.saveNow()) : null,
      onRefresh: () => unawaited(cubit.load()),
      onDismiss: canDismiss ? cubit.dismissSaveFailure : null,
    );
  }
}

/// Tłumaczy kod błędu na tekst: najpierw wspólne kody modułu Tasks, potem kody
/// Kanbana, a na końcu komunikat, który przyszedł gotowy z Backendu.
String tasksViewErrorMessage(BuildContext context, TasksViewError error) {
  final l10n = context.l10n;
  return tasksViewErrorText(l10n, error.code) ??
      tasksBoardMutationErrorText(l10n, error.code);
}
