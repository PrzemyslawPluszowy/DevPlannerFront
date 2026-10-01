import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_time_zones_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TimeZoneMenuLayout extends StatelessWidget {
  const TimeZoneMenuLayout({
    required this.state,
    required this.currentId,
    required this.onSearch,
    required this.onRetry,
    required this.onSelect,
    super.key,
  });

  final TaskRecurrenceTimeZonesState state;
  final String currentId;
  final ValueChanged<String> onSearch;
  final VoidCallback onRetry;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final panelHeight = (viewportHeight - 112).clamp(120.0, 404.0);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: panelHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TimeZoneSearchField(onChanged: onSearch),
          const Divider(height: 1),
          if (state case TaskRecurrenceTimeZonesReady(
            currentIdIsUnlisted: true,
          ))
            _UnlistedCurrentTimeZoneRow(
              value: currentId,
              onTap: () => onSelect(currentId),
            ),
          Flexible(
            child: _TimeZoneResults(
              state: state,
              currentId: currentId,
              onRetry: onRetry,
              onSelect: onSelect,
            ),
          ),
        ],
      ),
    );
  }
}

final class _TimeZoneSearchField extends StatefulWidget {
  const _TimeZoneSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<_TimeZoneSearchField> createState() => _TimeZoneSearchFieldState();
}

class _TimeZoneSearchFieldState extends State<_TimeZoneSearchField> {
  late final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        autofocus: true,
        onChanged: widget.onChanged,
        style: tasks.controlText,
        decoration: InputDecoration(
          isDense: true,
          hintText: context.l10n.taskRecurrenceTimeZoneSearch,
          prefixIcon: const Icon(Symbols.search_rounded, size: 16),
          prefixIconConstraints: const BoxConstraints.tightFor(width: 32),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            borderSide: BorderSide(color: tasks.canvasBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            borderSide: BorderSide(color: tasks.canvasBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            borderSide: BorderSide(color: tasks.selectionAccent, width: 1.5),
          ),
        ),
      ),
    );
  }
}

final class _TimeZoneResults extends StatelessWidget {
  const _TimeZoneResults({
    required this.state,
    required this.currentId,
    required this.onRetry,
    required this.onSelect,
  });

  final TaskRecurrenceTimeZonesState state;
  final String currentId;
  final VoidCallback onRetry;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => switch (state) {
    TaskRecurrenceTimeZonesLoading() => const Center(
      child: SizedBox.square(
        dimension: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
    TaskRecurrenceTimeZonesFailure(:final error, :final canRetry) =>
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TimeZoneLoadError(error: error),
            TextButton.icon(
              onPressed: canRetry ? onRetry : null,
              icon: const Icon(Symbols.refresh_rounded, size: 16),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    TaskRecurrenceTimeZonesReady(:final visibleZones) =>
      visibleZones.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  context.l10n.taskRecurrenceTimeZoneNoResults,
                  style: context.tasksTheme.metaText,
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: visibleZones.length,
              itemBuilder: (context, index) => _TimeZoneResultRow(
                id: visibleZones[index],
                selected: visibleZones[index] == currentId,
                onTap: () => onSelect(visibleZones[index]),
              ),
            ),
  };
}

final class _TimeZoneLoadError extends StatelessWidget {
  const _TimeZoneLoadError({required this.error});

  final ApiError error;

  @override
  Widget build(BuildContext context) {
    final visibleError =
        error.apiCode == 'task_recurrence_time_zones_load_failed'
        ? ApiError(
            type: error.type,
            message: context.l10n.taskRecurrenceTimeZoneLoadFailed,
            statusCode: error.statusCode,
            backendCode: error.backendCode,
            apiCode: error.apiCode,
            contractCode: error.contractCode,
            fields: error.fields,
            traceId: error.traceId,
            retryAfterUtc: error.retryAfterUtc,
          )
        : error;
    return TaskDetailsModalError(error: visibleError);
  }
}

final class _TimeZoneResultRow extends StatelessWidget {
  const _TimeZoneResultRow({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: id,
      child: InkWell(
        onTap: onTap,
        hoverColor: tasks.rowHover,
        focusColor: tasks.rowSelected,
        child: ColoredBox(
          color: selected ? tasks.rowSelected : Colors.transparent,
          child: SizedBox(
            height: tasks.contextRowHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tasks.dataText,
                    ),
                  ),
                  if (selected)
                    Icon(
                      Symbols.check_rounded,
                      size: 16,
                      color: tasks.selectionAccent,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _UnlistedCurrentTimeZoneRow extends StatelessWidget {
  const _UnlistedCurrentTimeZoneRow({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final description = context.l10n.taskRecurrenceTimeZoneCurrentUnlisted;
    return Semantics(
      button: true,
      selected: true,
      label: '$value, $description',
      child: InkWell(
        onTap: onTap,
        hoverColor: tasks.rowHover,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: tasks.rowSelected,
            border: Border(bottom: BorderSide(color: tasks.canvasBorder)),
          ),
          child: Row(
            children: [
              const Icon(Symbols.info_rounded, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: tasks.dataStrongText),
                    Text(description, style: tasks.metaText),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
