import 'dart:math' as math;

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_geometry.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_result_widgets.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Panel wyszukiwania z ponawianiem, paginacją i obsługą klawiatury.
final class TasksGlobalSearchDialog extends StatefulWidget {
  const TasksGlobalSearchDialog({required this.onOpenTask, super.key});

  final ValueChanged<GlobalTaskSearchItemResponse> onOpenTask;

  @override
  State<TasksGlobalSearchDialog> createState() =>
      _TasksGlobalSearchDialogState();
}

final class _TasksGlobalSearchDialogState
    extends State<TasksGlobalSearchDialog> {
  final TextEditingController _query = TextEditingController();
  final ScrollController _results = ScrollController();
  final FocusNode _queryFocus = FocusNode();
  final FocusNode _resultsFocus = FocusNode();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _query.text = context.read<TasksGlobalSearchCubit>().state.query;
  }

  @override
  void dispose() {
    _queryFocus.dispose();
    _resultsFocus.dispose();
    _query.dispose();
    _results.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final cubit = context.read<TasksGlobalSearchCubit>();
    final count = cubit.state.items.length;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).maybePop();
      return KeyEventResult.handled;
    }
    if (!_queryFocus.hasFocus && !_resultsFocus.hasFocus) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _openSelected(cubit.state);
      return KeyEventResult.handled;
    }
    if (count == 0) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _selectIndex((_selectedIndex + 1).clamp(0, count - 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _selectIndex((_selectedIndex - 1).clamp(0, count - 1));
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index);
    if (!_results.hasClients) return;
    final tasks = context.tasksTheme;
    final extent = TasksGlobalSearchGeometry.rowExtent(
      textScaler: MediaQuery.textScalerOf(context),
      titleStyle: tasks.dataText,
      metaStyle: tasks.metaText,
    );
    final target = index * extent;
    _results.jumpTo(
      target.clamp(0, _results.position.maxScrollExtent),
    );
  }

  void _openSelected(TasksGlobalSearchState state) {
    if (state.items.isEmpty) return;
    final index = _selectedIndex.clamp(0, state.items.length - 1);
    widget.onOpenTask(state.items[index]);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      child: SizedBox(
        width: math.min(680.0, size.width - 48),
        height: math.min(660.0, size.height - 48),
        child: Focus(
          canRequestFocus: false,
          onKeyEvent: _handleKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TasksGlobalSearchHeader(onClose: Navigator.of(context).pop),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  tasks.sectionGap,
                  0,
                  tasks.sectionGap,
                  tasks.controlGap,
                ),
                child: TextField(
                  controller: _query,
                  focusNode: _queryFocus,
                  autofocus: true,
                  maxLength: 160,
                  textInputAction: TextInputAction.search,
                  onChanged: _onQueryChanged,
                  onSubmitted: (_) => _openSelected(
                    context.read<TasksGlobalSearchCubit>().state,
                  ),
                  decoration: InputDecoration(
                    hintText: context.l10n.tasksGlobalSearchHint,
                    prefixIcon: const Icon(Symbols.search_rounded, size: 18),
                    suffixIcon: _query.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: context.l10n.tasksGlobalSearchClear,
                            onPressed: _clearQuery,
                            icon: const Icon(Symbols.close_rounded, size: 17),
                          ),
                  ),
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<TasksGlobalSearchCubit, TasksGlobalSearchState>(
                      builder: (context, state) => _TasksGlobalSearchResults(
                        state: state,
                        selectedIndex: _selectedIndex,
                        scrollController: _results,
                        resultsFocus: _resultsFocus,
                        onSelect: widget.onOpenTask,
                        onRetry: context.read<TasksGlobalSearchCubit>().retry,
                        onLoadMore: context
                            .read<TasksGlobalSearchCubit>()
                            .loadMore,
                      ),
                    ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  tasks.sectionGap,
                  tasks.controlGap,
                  tasks.sectionGap,
                  tasks.sectionGap,
                ),
                child: Row(
                  children: [
                    Icon(
                      Symbols.keyboard_arrow_up_rounded,
                      size: 15,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Symbols.keyboard_arrow_down_rounded,
                      size: 15,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        context.l10n.tasksGlobalSearchKeyboardHint,
                        style: tasks.metaText.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearQuery() {
    _query.clear();
    _onQueryChanged('');
    _queryFocus.requestFocus();
  }

  void _onQueryChanged(String query) {
    _selectedIndex = 0;
    context.read<TasksGlobalSearchCubit>().updateQuery(query);
    setState(() {});
  }
}

final class _TasksGlobalSearchHeader extends StatelessWidget {
  const _TasksGlobalSearchHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        tasks.sectionGap,
        tasks.sectionGap,
        tasks.controlGap,
        tasks.controlGap,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.tasksGlobalSearchTitle,
              style: tasks.projectTitleText.copyWith(color: colors.onSurface),
            ),
          ),
          IconButton(
            tooltip: context.l10n.tasksGlobalSearchClose,
            onPressed: onClose,
            icon: const Icon(Symbols.close_rounded, size: 18),
            style: IconButton.styleFrom(
              minimumSize: const Size(32, 32),
              maximumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
              foregroundColor: colors.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tasks.controlRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _TasksGlobalSearchResults extends StatelessWidget {
  const _TasksGlobalSearchResults({
    required this.state,
    required this.selectedIndex,
    required this.scrollController,
    required this.resultsFocus,
    required this.onSelect,
    required this.onRetry,
    required this.onLoadMore,
  });

  final TasksGlobalSearchState state;
  final int selectedIndex;
  final ScrollController scrollController;
  final FocusNode resultsFocus;
  final ValueChanged<GlobalTaskSearchItemResponse> onSelect;
  final VoidCallback onRetry;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    if (state.failure == null &&
        state.query.length < TasksGlobalSearchCubit.minimumQueryLength) {
      return Center(child: Text(context.l10n.tasksGlobalSearchTypeMore));
    }
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state.items.isEmpty && state.failure == null) {
      return Center(child: Text(context.l10n.tasksGlobalSearchNoResults));
    }
    final rowExtent = TasksGlobalSearchGeometry.rowExtent(
      textScaler: MediaQuery.textScalerOf(context),
      titleStyle: tasks.dataText,
      metaStyle: tasks.metaText,
    );
    final failure = state.failure;
    final loadMore = state.nextCursor != null && failure == null;
    if (failure != null && state.items.isEmpty) {
      return SingleChildScrollView(
        child: TasksGlobalSearchFailure(
          error: failure,
          retryWaitSeconds: state.retryWaitSeconds,
          onRetry: onRetry,
        ),
      );
    }
    return Column(
      children: [
        if (failure != null)
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: TasksGlobalSearchFailure(
                error: failure,
                retryWaitSeconds: state.retryWaitSeconds,
                onRetry: onRetry,
              ),
            ),
          ),
        Expanded(
          flex: 3,
          child: Focus(
            focusNode: resultsFocus,
            canRequestFocus: false,
            child: ListView.builder(
              controller: scrollController,
              itemExtent: rowExtent,
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return TasksGlobalSearchResultRow(
                  item: state.items[index],
                  selected: index == selectedIndex,
                  onTap: () => onSelect(state.items[index]),
                );
              },
            ),
          ),
        ),
        if (loadMore)
          Padding(
            padding: EdgeInsets.all(tasks.controlGap),
            child: OutlinedButton(
              onPressed: state.isLoadingMore || state.retryWaitSeconds > 0
                  ? null
                  : onLoadMore,
              child: state.isLoadingMore
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.l10n.tasksGlobalSearchLoadMore),
            ),
          ),
      ],
    );
  }
}
