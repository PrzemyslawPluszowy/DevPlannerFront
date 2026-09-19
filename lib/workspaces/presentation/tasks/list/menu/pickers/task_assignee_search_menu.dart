import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Samodzielne menu wyszukiwania osób z lokalną paginacją i debounce.
class TaskAssigneeSearchMenu extends PopupMenuEntry<String> {
  const TaskAssigneeSearchMenu({
    required this.candidates,
    required this.selectedIds,
    required this.primaryId,
    required this.selectionMode,
    super.key,
    this.searchEligibleProfiles,
  });

  final List<ProjectMemberProfile> candidates;
  final List<String> selectedIds;
  final String? primaryId;
  final AssigneeMenuAction selectionMode;
  final EligibleProfilesPageLoader? searchEligibleProfiles;

  static String profileLabel(ProjectMemberProfile profile) {
    final name = profile.displayName?.trim();
    return name?.isNotEmpty == true ? name! : 'Nieznany użytkownik';
  }

  @override
  double get height => 308;

  @override
  bool represents(String? value) => false;

  @override
  State<TaskAssigneeSearchMenu> createState() => _TaskAssigneeSearchMenuState();
}

class _TaskAssigneeSearchMenuState extends State<TaskAssigneeSearchMenu> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  var _request = 0;
  late final ValueNotifier<_AssigneeSearchUiState> _ui = ValueNotifier(
    _AssigneeSearchUiState(visible: widget.candidates),
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadNextPageIfNeeded);
    if (widget.searchEligibleProfiles != null) unawaited(_loadFirstPage());
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
      ValueListenableBuilder<_AssigneeSearchUiState>(
        valueListenable: _ui,
        builder: (context, ui, _) => SizedBox(
          width: 252,
          height: 294,
          child: Column(
            children: [
              _buildSearchField(context, ui),
              const Divider(height: 1),
              if (widget.selectionMode == AssigneeMenuAction.setOwner &&
                  widget.primaryId != null)
                _ClearTaskOwnerAction(onTap: _clearOwner),
              Expanded(child: _buildProfiles(context, ui)),
            ],
          ),
        ),
      );

  Widget _buildSearchField(BuildContext context, _AssigneeSearchUiState ui) =>
      Padding(
        padding: const .fromLTRB(6, 6, 6, 4),
        child: TextField(
          controller: _controller,
          autofocus: true,
          style: context.text.labelMedium,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const .symmetric(horizontal: 8, vertical: 7),
            hintText: 'Szukaj osób…',
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

  Widget _buildProfiles(BuildContext context, _AssigneeSearchUiState ui) {
    if (ui.visible.isEmpty) {
      return const Center(child: Text('Nie znaleziono osób'));
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const .symmetric(vertical: 2),
      itemCount: ui.visible.length + (ui.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == ui.visible.length) {
          return const _TaskAssigneeLoadingRow();
        }
        final profile = ui.visible[index];
        return _TaskAssigneeSearchResultRow(
          profile: profile,
          selected: widget.selectionMode == AssigneeMenuAction.setOwner
              ? profile.userId == widget.primaryId
              : widget.selectedIds.contains(profile.userId),
        );
      },
    );
  }

  void _clearOwner() => Navigator.of(context).pop('__clear_owner__');

  void _onQueryChanged(String raw) {
    _debounce?.cancel();
    final request = ++_request;
    final query = raw.trim();
    final local = query.isEmpty
        ? widget.candidates
        : widget.candidates
              .where(
                (profile) =>
                    TaskAssigneeSearchMenu.profileLabel(profile)
                        .toLowerCase()
                        .contains(query.toLowerCase()),
              )
              .toList(growable: false);
    _ui.value = _AssigneeSearchUiState(
      visible: local,
      query: query,
      isSearching: query.length >= 2 && widget.searchEligibleProfiles != null,
    );
    if (query.length < 2 || widget.searchEligibleProfiles == null) return;
    _debounce = Timer(const Duration(milliseconds: 220), () async {
      final remote = await widget.searchEligibleProfiles!(query: query);
      if (!mounted || request != _request) return;
      _ui.value = _AssigneeSearchUiState(
        visible: remote.items,
        query: query,
        nextCursor: remote.nextCursor,
      );
    });
  }

  Future<void> _loadFirstPage() async {
    final loader = widget.searchEligibleProfiles;
    if (loader == null) return;
    final request = ++_request;
    _ui.value = _ui.value.copyWith(isSearching: true, isLoadingMore: false);
    final page = await loader();
    if (!mounted || request != _request) return;
    _ui.value = _AssigneeSearchUiState(
      visible: page.items,
      nextCursor: page.nextCursor,
    );
  }

  void _loadNextPageIfNeeded() {
    final state = _ui.value;
    if (!_scrollController.hasClients ||
        _scrollController.position.extentAfter > 80 ||
        state.isLoadingMore ||
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
    final page = await loader(
      query: current.query.isEmpty ? null : current.query,
      cursor: cursor,
    );
    if (!mounted || request != _request) return;
    final latest = _ui.value;
    final knownIds = latest.visible.map((profile) => profile.userId).toSet();
    _ui.value = _AssigneeSearchUiState(
      visible: [
        ...latest.visible,
        ...page.items.where((profile) => knownIds.add(profile.userId)),
      ],
      query: latest.query,
      nextCursor: page.nextCursor,
    );
  }
}

final class _AssigneeSearchUiState {
  const _AssigneeSearchUiState({
    required this.visible,
    this.query = '',
    this.nextCursor,
    this.isSearching = false,
    this.isLoadingMore = false,
  });

  final List<ProjectMemberProfile> visible;
  final String query;
  final String? nextCursor;
  final bool isSearching;
  final bool isLoadingMore;

  _AssigneeSearchUiState copyWith({bool? isSearching, bool? isLoadingMore}) =>
      _AssigneeSearchUiState(
        visible: visible,
        query: query,
        nextCursor: nextCursor,
        isSearching: isSearching ?? this.isSearching,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class _ClearTaskOwnerAction extends StatelessWidget {
  const _ClearTaskOwnerAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        child: Container(
          height: 28,
          padding: const .symmetric(horizontal: 10),
          color: context.colors.error.withValues(alpha: 0.05),
          child: Row(
            children: [
              Icon(
                Symbols.person_off_rounded,
                size: 14,
                color: context.colors.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Usuń właściciela',
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      const Divider(height: 1),
    ],
  );
}

class _TaskAssigneeSearchResultRow extends StatelessWidget {
  const _TaskAssigneeSearchResultRow({
    required this.profile,
    required this.selected,
  });

  final ProjectMemberProfile profile;
  final bool selected;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    minTileHeight: 34,
    visualDensity: VisualDensity.compact,
    contentPadding: const .symmetric(horizontal: 8),
    leading: Icon(
      Symbols.person_outline_rounded,
      size: 17,
      color: context.colors.onSurfaceVariant,
    ),
    title: Text(
      TaskAssigneeSearchMenu.profileLabel(profile),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.text.labelMedium,
    ),
    trailing: Icon(
      selected ? Symbols.check_circle_rounded : Symbols.add_rounded,
      color: selected
          ? context.colors.primary
          : context.colors.onSurfaceVariant,
      size: 16,
    ),
    onTap: () => Navigator.of(context).pop(profile.userId),
  );
}

class _TaskAssigneeLoadingRow extends StatelessWidget {
  const _TaskAssigneeLoadingRow();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: .symmetric(vertical: 10),
    child: Center(
      child: SizedBox.square(
        dimension: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}
