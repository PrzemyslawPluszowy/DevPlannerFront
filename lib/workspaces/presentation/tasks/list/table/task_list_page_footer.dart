import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:flutter/material.dart';

/// Lokalny odczyt kolejnej strony nie zastępuje załadowanych danych spinnerem.
final class TaskListPageFooter extends StatelessWidget {
  const TaskListPageFooter({
    required this.isLoading,
    required this.isBlocked,
    required this.onLoadMore,
    this.error,
    super.key,
  });

  final bool isLoading;
  final bool isBlocked;
  final ApiError? error;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final text = switch (error?.message) {
      'tasks.list.page_changed' => context.l10n.tasksListPageChanged,
      'tasks.list.page_failed' => context.l10n.tasksListPageFailed,
      _ => error?.message,
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed:
                    isLoading ||
                        isBlocked ||
                        !TaskListLoadingMixin.canRetryPage(error)
                    ? null
                    : onLoadMore,
                icon: SizedBox.square(
                  dimension: 16,
                  child: isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Icon(Icons.expand_more, size: 16),
                ),
                label: Text(
                  isLoading
                      ? context.l10n.tasksListPageLoading
                      : error == null
                      ? context.l10n.tasksListLoadMore
                      : context.l10n.retry,
                ),
              ),
              if (text != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    text,
                    style: context.tasksTheme.metaText.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
