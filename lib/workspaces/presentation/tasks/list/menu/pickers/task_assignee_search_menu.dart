import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_assignee_profile_presentation.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_search_failure.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_search_rows.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_search_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zawartość wyszukiwania osób z lokalną paginacją i debounce.
///
/// Jest zwykłym widgetem renderowanym we wspólnej powierzchni menu
/// (`AppContextMenu.showCustom`), a wybór zwraca przez [onSelected].
class TaskAssigneeSearchMenu extends StatefulWidget {
  const TaskAssigneeSearchMenu({
    required this.candidates,
    required this.selectedIds,
    required this.primaryId,
    required this.selectionMode,
    required this.onSelected,
    super.key,
    this.searchEligibleProfiles,
  });

  final List<ProjectMemberProfile> candidates;
  final List<String> selectedIds;
  final String? primaryId;
  final AssigneeMenuAction selectionMode;
  final EligibleProfilesPageLoader? searchEligibleProfiles;

  /// Wywoływane z identyfikatorem wybranej osoby albo znacznikiem wyczyszczenia.
  final ValueChanged<String> onSelected;

  static String profileLabel(
    BuildContext context,
    ProjectMemberProfile profile,
  ) => TaskAssigneeProfilePresentation.label(context, profile);

  @override
  State<TaskAssigneeSearchMenu> createState() => _TaskAssigneeSearchMenuState();
}

class _TaskAssigneeSearchMenuState extends State<TaskAssigneeSearchMenu> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  var _request = 0;
  var _initialLoadStarted = false;
  late final ValueNotifier<TaskAssigneeSearchUiState> _ui = ValueNotifier(
    TaskAssigneeSearchUiState(
      visible: List.unmodifiable(widget.candidates),
      isSearching: widget.searchEligibleProfiles != null,
      hasLoaded: widget.searchEligibleProfiles == null,
    ),
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadNextPageIfNeeded);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialLoadStarted && widget.searchEligibleProfiles != null) {
      _initialLoadStarted = true;
      unawaited(_loadFirstPage());
    }
  }

  @override
  void didUpdateWidget(TaskAssigneeSearchMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLoader = oldWidget.searchEligibleProfiles;
    final loader = widget.searchEligibleProfiles;
    final sourceChanged = oldLoader == null
        ? loader != null
        : loader == null || !oldLoader.hasSameScopeAs(loader);
    if (sourceChanged) {
      _debounce?.cancel();
      final request = ++_request;
      _ui.value = TaskAssigneeSearchUiState(
        visible: List.unmodifiable(widget.candidates),
        query: _controller.text.trim(),
        isSearching: loader != null,
      );
      if (loader != null) unawaited(_loadFirstPage(request: request));
    } else if (_controller.text.isEmpty &&
        !identical(oldWidget.candidates, widget.candidates)) {
      _ui.value = _ui.value.copyWith(
        visible: List.unmodifiable(widget.candidates),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    _ui.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TaskAssigneeSearchUiState>(
        valueListenable: _ui,
        builder: (context, ui, _) => SizedBox(
          height: 294,
          child: Column(
            children: [
              _buildSearchField(context, ui),
              const Divider(height: 1),
              if (widget.selectionMode == AssigneeMenuAction.setOwner &&
                  widget.primaryId != null)
                TaskAssigneeClearPrimaryAction(onTap: _clearOwner),
              Expanded(child: _buildProfiles(context, ui)),
            ],
          ),
        ),
      );

  Widget _buildSearchField(
    BuildContext context,
    TaskAssigneeSearchUiState ui,
  ) => Padding(
    padding: const .fromLTRB(6, 6, 6, 4),
    child: TextField(
      controller: _controller,
      autofocus: true,
      style: context.text.labelMedium,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const .symmetric(horizontal: 8, vertical: 7),
        hintText: context.l10n.tasksAssigneeSearchPeople,
        prefixIcon: Icon(
          Symbols.search_rounded,
          size: 16,
          color: context.colors.onSurfaceVariant,
        ),
        prefixIconConstraints: const BoxConstraints.tightFor(
          width: 30,
          height: 30,
        ),
        suffixIcon: ui.isSearching
            ? const Padding(
                padding: .all(8),
                child: SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      onChanged: _onQueryChanged,
    ),
  );

  Widget _buildProfiles(BuildContext context, TaskAssigneeSearchUiState ui) =>
      Column(
        children: [
          if (ui.error case final error?)
            TaskAssigneeSearchFailure(error: error, onRetry: _retry),
          Expanded(
            child: ui.visible.isEmpty
                ? Center(
                    child: ui.isSearching || !ui.hasLoaded
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : ui.error != null
                        ? const SizedBox.shrink()
                        : Text(context.l10n.taskDetailsNoProjectMembers),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const .symmetric(vertical: 2),
                    itemCount: ui.visible.length + (ui.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == ui.visible.length) {
                        return const TaskAssigneeLoadingRow();
                      }
                      final profile = ui.visible[index];
                      return TaskAssigneeSearchResultRow(
                        profile: profile,
                        selected:
                            widget.selectionMode == AssigneeMenuAction.setOwner
                            ? profile.userId == widget.primaryId
                            : widget.selectedIds.contains(profile.userId),
                        onSelected: widget.onSelected,
                      );
                    },
                  ),
          ),
        ],
      );

  void _clearOwner() => widget.onSelected('__clear_owner__');

  void _onQueryChanged(String raw) {
    _debounce?.cancel();
    final request = ++_request;
    final query = raw.trim();
    final local = query.isEmpty
        ? List<ProjectMemberProfile>.of(widget.candidates)
        : widget.candidates
              .where(
                (profile) => TaskAssigneeSearchMenu.profileLabel(
                  context,
                  profile,
                ).toLowerCase().contains(query.toLowerCase()),
              )
              .toList(growable: false);
    final loader = widget.searchEligibleProfiles;
    _ui.value = TaskAssigneeSearchUiState(
      visible: List.unmodifiable(local),
      query: query,
      hasLoaded: loader == null || query.length < 2,
      isSearching: query.length >= 2 && loader != null,
    );
    if (query.length < 2 || loader == null) return;
    _debounce = Timer(
      const Duration(milliseconds: 220),
      () => unawaited(_searchPage(loader, query, request)),
    );
  }

  Future<void> _searchPage(
    EligibleProfilesPageLoader loader,
    String query,
    int request,
  ) async {
    final failureMessage = context.l10n.taskDetailsAssigneesLoadError;
    try {
      final result = await loader(query: query);
      if (!mounted || request != _request || !_isCurrentLoader(loader)) return;
      result.fold(
        (error) => _ui.value = _ui.value.copyWith(
          isSearching: false,
          hasLoaded: true,
          error: error,
          errorOnNextPage: false,
        ),
        (page) => _ui.value = TaskAssigneeSearchUiState(
          visible: List.unmodifiable(page.items),
          query: query,
          nextCursor: page.nextCursor,
          hasLoaded: true,
        ),
      );
    } on Object {
      if (!mounted || request != _request || !_isCurrentLoader(loader)) return;
      _setUnexpectedLoadFailure(failureMessage);
    }
  }

  Future<void> _loadFirstPage({int? request}) async {
    final loader = widget.searchEligibleProfiles;
    if (loader == null) return;
    final operation = request ?? ++_request;
    final failureMessage = context.l10n.taskDetailsAssigneesLoadError;
    _ui.value = _ui.value.copyWith(
      isSearching: true,
      isLoadingMore: false,
      clearError: true,
      errorOnNextPage: false,
    );
    try {
      final result = await loader();
      if (!mounted || operation != _request || !_isCurrentLoader(loader)) {
        return;
      }
      result.fold(
        (error) => _ui.value = _ui.value.copyWith(
          isSearching: false,
          hasLoaded: true,
          error: error,
          errorOnNextPage: false,
        ),
        (page) => _ui.value = TaskAssigneeSearchUiState(
          visible: List.unmodifiable(page.items),
          nextCursor: page.nextCursor,
          hasLoaded: true,
        ),
      );
    } on Object {
      if (!mounted || operation != _request || !_isCurrentLoader(loader)) {
        return;
      }
      _setUnexpectedLoadFailure(failureMessage);
    }
  }

  bool _isCurrentLoader(EligibleProfilesPageLoader loader) =>
      widget.searchEligibleProfiles?.hasSameScopeAs(loader) ?? false;

  void _setUnexpectedLoadFailure(String message) {
    _ui.value = _ui.value.copyWith(
      isSearching: false,
      isLoadingMore: false,
      hasLoaded: true,
      error: ApiError(
        type: ApiErrorType.unknown,
        message: message,
        contractCode: 'project_member_profiles_load_failed',
      ),
    );
  }

  void _retry() {
    final state = _ui.value;
    if (state.errorOnNextPage) {
      unawaited(_loadNextPage());
    } else if (state.query.length >= 2) {
      final request = ++_request;
      _ui.value = _ui.value.copyWith(isSearching: true, clearError: true);
      final loader = widget.searchEligibleProfiles;
      if (loader != null) unawaited(_searchPage(loader, state.query, request));
    } else {
      unawaited(_loadFirstPage());
    }
  }

  void _loadNextPageIfNeeded() {
    final state = _ui.value;
    if (!_scrollController.hasClients ||
        _scrollController.position.extentAfter > 80 ||
        state.isLoadingMore ||
        state.errorOnNextPage ||
        state.nextCursor == null ||
        widget.searchEligibleProfiles == null) {
      return;
    }
    unawaited(_loadNextPage());
  }

  Future<void> _loadNextPage() async {
    final current = _ui.value;
    final cursor = current.nextCursor;
    final loader = widget.searchEligibleProfiles;
    if (cursor == null || loader == null || current.isLoadingMore) return;
    final request = _request;
    _ui.value = current.copyWith(isLoadingMore: true);
    final failureMessage = context.l10n.taskDetailsAssigneesLoadError;
    try {
      final result = await loader(
        query: current.query.isEmpty ? null : current.query,
        cursor: cursor,
      );
      if (!mounted || request != _request || !_isCurrentLoader(loader)) return;
      result.fold(
        (error) => _ui.value = _ui.value.copyWith(
          isLoadingMore: false,
          error: error,
          errorOnNextPage: true,
        ),
        (page) {
          final latest = _ui.value;
          final knownIds = latest.visible
              .map((profile) => profile.userId)
              .toSet();
          _ui.value = latest.copyWith(
            visible: List.unmodifiable([
              ...latest.visible,
              ...page.items.where((profile) => knownIds.add(profile.userId)),
            ]),
            nextCursor: page.nextCursor,
            isLoadingMore: false,
            clearError: true,
            errorOnNextPage: false,
          );
        },
      );
    } on Object {
      if (!mounted || request != _request || !_isCurrentLoader(loader)) return;
      _setUnexpectedLoadFailure(failureMessage);
    }
  }
}
