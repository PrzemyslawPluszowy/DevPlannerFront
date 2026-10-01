import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pokazuje typowany błąd wyszukiwania i jawne ponowienie.
final class TasksGlobalSearchFailure extends StatefulWidget {
  /// Tworzy zwarty panel błędu dla wyników wyszukiwania.
  const TasksGlobalSearchFailure({
    required this.error,
    required this.retryWaitSeconds,
    required this.onRetry,
    super.key,
  });

  final ApiError error;

  final int retryWaitSeconds;

  /// Ponawia bieżące zapytanie lub stronę wyników.
  final VoidCallback onRetry;

  @override
  State<TasksGlobalSearchFailure> createState() =>
      _TasksGlobalSearchFailureState();
}

final class _TasksGlobalSearchFailureState
    extends State<TasksGlobalSearchFailure> {
  bool _showDiagnostics = false;

  void _toggleDiagnostics() {
    setState(() => _showDiagnostics = !_showDiagnostics);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final error = widget.error;
    final coolingDown = widget.retryWaitSeconds > 0;
    final message = error.message.trim();
    final showDetails = _hasMetadata(error) || message.length > 140;
    final heading = coolingDown
        ? context.l10n.tasksGlobalSearchRateLimitedTitle
        : context.l10n.tasksGlobalSearchFailure;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(tasks.controlGap),
      padding: EdgeInsets.all(tasks.controlGap),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: .28),
        border: Border.all(color: colors.error.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(tasks.controlRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Symbols.error_outline_rounded,
                size: 18,
                color: colors.error,
              ),
              SizedBox(width: tasks.controlGap),
              Expanded(
                child: Semantics(
                  container: true,
                  liveRegion: true,
                  label: message.isEmpty ? heading : '$heading. $message',
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        heading,
                        style: tasks.controlText.copyWith(color: colors.error),
                      ),
                      if (message.isNotEmpty)
                        Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tasks.metaText.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: tasks.tightGap,
            children: [
              TextButton(
                onPressed: coolingDown ? null : widget.onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: colors.primary,
                  disabledForegroundColor: colors.onSurfaceVariant,
                  padding: EdgeInsets.symmetric(horizontal: tasks.controlGap),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                  ),
                ),
                child: Text(context.l10n.tasksGlobalSearchRetry),
              ),
              if (showDetails)
                TextButton.icon(
                  onPressed: _toggleDiagnostics,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurfaceVariant,
                    padding: EdgeInsets.symmetric(horizontal: tasks.controlGap),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(tasks.controlRadius),
                    ),
                  ),
                  icon: Icon(
                    _showDiagnostics
                        ? Symbols.expand_less_rounded
                        : Symbols.info_rounded,
                    size: 16,
                  ),
                  label: Text(
                    _showDiagnostics
                        ? context.l10n.tasksGlobalSearchHideDiagnostics
                        : context.l10n.tasksGlobalSearchShowDiagnostics,
                  ),
                ),
            ],
          ),
          if (coolingDown)
            Padding(
              padding: EdgeInsets.only(left: 18 + tasks.controlGap),
              child: Text(
                context.l10n.tasksGlobalSearchRetryAfter(
                  widget.retryWaitSeconds,
                ),
                style: tasks.metaText.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
          if (showDetails && _showDiagnostics) ...[
            SizedBox(height: tasks.tightGap),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Padding(
                padding: EdgeInsets.only(left: 18 + tasks.controlGap),
                child: SingleChildScrollView(
                  key: const ValueKey('tasks-global-search-diagnostics'),
                  primary: false,
                  child: _TasksGlobalSearchDiagnosticDetails(error: error),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _hasMetadata(ApiError error) =>
      error.apiCode != null ||
      error.contractCode != null ||
      error.backendCode != null ||
      error.statusCode != null ||
      error.traceId != null ||
      error.fields.isNotEmpty;
}

final class _TasksGlobalSearchDiagnosticDetails extends StatelessWidget {
  const _TasksGlobalSearchDiagnosticDetails({required this.error});

  final ApiError error;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final message = error.message.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: tasks.tightGap),
            child: SelectableText(
              message,
              style: tasks.metaText.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        Wrap(
          spacing: tasks.controlGap,
          runSpacing: tasks.tightGap,
          children: [
            if (error.apiCode case final code?)
              _TasksSearchErrorMetadata(
                label: context.l10n.taskDetailsErrorCode,
                value: code,
              ),
            if (error.contractCode case final code?)
              _TasksSearchErrorMetadata(
                label: context.l10n.taskDetailsErrorContractCode,
                value: code,
              ),
            if (error.backendCode case final code?)
              _TasksSearchErrorMetadata(
                label: context.l10n.taskDetailsErrorBackendCode,
                value: '$code',
              ),
            if (error.statusCode case final status?)
              _TasksSearchErrorMetadata(
                label: context.l10n.taskDetailsErrorHttpStatus,
                value: '$status',
              ),
            if (error.traceId case final trace?)
              _TasksSearchErrorMetadata(
                label: context.l10n.taskDetailsErrorTraceId,
                value: trace,
              ),
            for (final entry in error.fields.entries)
              _TasksSearchErrorMetadata(
                label: entry.key,
                value: entry.value.join(' · '),
              ),
          ],
        ),
      ],
    );
  }
}

final class _TasksSearchErrorMetadata extends StatelessWidget {
  const _TasksSearchErrorMetadata({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SelectableText.rich(
    TextSpan(
      style: context.tasksTheme.metaText.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
      children: [
        TextSpan(text: '${label.trim()}: '),
        TextSpan(
          text: value,
          style: context.tasksTheme.metaText.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

/// Renders one keyboard-selectable global task result.
final class TasksGlobalSearchResultRow extends StatelessWidget {
  /// Creates a task result row.
  const TasksGlobalSearchResultRow({
    required this.item,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// The typed server result represented by this row.
  final GlobalTaskSearchItemResponse item;

  /// Whether keyboard navigation currently selects this row.
  final bool selected;

  /// Opens the task using the caller's navigation intent.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: '${item.key} ${item.title}, ${item.projectName}',
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          padding: EdgeInsets.symmetric(horizontal: tasks.sectionGap),
          color: selected ? tasks.rowSelected : Colors.transparent,
          child: Row(
            children: [
              Icon(
                TaskStatusVisualHelper.icon(item.status),
                size: 17,
                color: TaskStatusVisualHelper.color(item.status),
              ),
              SizedBox(width: tasks.controlGap),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: item.title,
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tasks.dataText.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item.key} · ${item.projectName} · ${item.workspaceName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tasks.metaText.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: tasks.controlGap),
              Icon(
                TaskPriorityVisualHelper.icon(item.priority),
                size: 16,
                color: TaskPriorityVisualHelper.color(item.priority),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
