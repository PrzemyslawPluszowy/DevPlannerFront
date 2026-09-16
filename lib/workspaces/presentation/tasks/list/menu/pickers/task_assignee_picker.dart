import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/workspace_context_menu.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';

/// Wyświetla zakotwiczone menu edycji przypisania osób do zadania.
Future<void> showTaskAssigneeEditor(
  BuildContext context, {
  required List<TaskAssigneeResponse> assignees,
  required Map<String, ProjectMemberProfile> profiles,
  required Future<bool> Function(List<String> coreUserIds) onSave,
  RelativeRect? menuPosition,
  AssigneeMenuAction? initialAction,
  EligibleProfilesPageLoader? searchEligibleProfiles,
}) async {
  final position = menuPosition ?? _menuPositionFor(context);
  final action =
      initialAction ??
      await _showAssigneeActionContext(
        context: context,
        position: position,
      );
  if (action == null) return;
  if (action == AssigneeMenuAction.clear) {
    await onSave(const []);
    return;
  }
  if (!context.mounted) return;
  final candidates = profiles.values.toList(
    growable: false,
  )..sort((left, right) => _profileLabel(left).compareTo(_profileLabel(right)));
  if (candidates.isEmpty && searchEligibleProfiles == null) return;
  final currentIds = assignees
      .map((item) => item.coreUserId)
      .toList(growable: false);
  final primaryId =
      assignees.where((item) => item.isPrimary).firstOrNull?.coreUserId ??
      currentIds.firstOrNull;
  final selectedId = await _showAssigneeSearchContext(
    context,
    position: position,
    candidates: candidates,
    selectedIds: currentIds,
    primaryId: primaryId,
    selectionMode: action,
    searchEligibleProfiles: searchEligibleProfiles,
  );
  if (selectedId == null) return;
  if (selectedId == '__clear_owner__') {
    await onSave(currentIds.where((id) => id != primaryId).toList());
    return;
  }
  if (action == AssigneeMenuAction.setOwner) {
    await onSave([selectedId, ...currentIds.where((id) => id != selectedId)]);
    return;
  }
  final ids = [...currentIds];
  ids.contains(selectedId) ? ids.remove(selectedId) : ids.add(selectedId);
  if (primaryId != null && ids.remove(primaryId)) ids.insert(0, primaryId);
  await onSave(ids);
}

Future<AssigneeMenuAction?> _showAssigneeActionContext({
  required BuildContext context,
  required RelativeRect position,
}) => WorkspaceContextMenu.select<AssigneeMenuAction>(
  context,
  position: position,
  items: const [
    PopupMenuItem(
      value: AssigneeMenuAction.setOwner,
      height: 32,
      padding: .symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(Symbols.person_rounded, size: 16),
          SizedBox(width: 8),
          Text('Ustaw właściciela'),
        ],
      ),
    ),
    PopupMenuItem(
      value: AssigneeMenuAction.toggleCollaborator,
      height: 32,
      padding: .symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(Symbols.group_add, size: 16),
          SizedBox(width: 8),
          Text('Współpracownicy'),
        ],
      ),
    ),
    PopupMenuItem(
      value: AssigneeMenuAction.clear,
      height: 32,
      padding: .symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(Symbols.person_remove, size: 16),
          SizedBox(width: 8),
          Text('Usuń przypisanie'),
        ],
      ),
    ),
  ],
);

Future<String?> _showAssigneeSearchContext(
  BuildContext context, {
  required RelativeRect position,
  required List<ProjectMemberProfile> candidates,
  required List<String> selectedIds,
  required String? primaryId,
  required AssigneeMenuAction selectionMode,
  EligibleProfilesPageLoader? searchEligibleProfiles,
}) => WorkspaceContextMenu.select<String>(
  context,
  position: position,
  items: [
    _AssigneeSearchMenu(
      candidates: candidates,
      selectedIds: selectedIds,
      primaryId: primaryId,
      selectionMode: selectionMode,
      searchEligibleProfiles: searchEligibleProfiles,
    ),
  ],
);

class _AssigneeSearchMenu extends PopupMenuEntry<String> {
  const _AssigneeSearchMenu({
    required this.candidates,
    required this.selectedIds,
    required this.primaryId,
    required this.selectionMode,
    this.searchEligibleProfiles,
  });

  final List<ProjectMemberProfile> candidates;
  final List<String> selectedIds;
  final String? primaryId;
  final AssigneeMenuAction selectionMode;
  final EligibleProfilesPageLoader? searchEligibleProfiles;

  @override
  double get height => 308;

  @override
  bool represents(String? value) => false;

  @override
  State<_AssigneeSearchMenu> createState() => _AssigneeSearchMenuState();
}

class _AssigneeSearchMenuState extends State<_AssigneeSearchMenu> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  var _request = 0;
  var _isSearching = false;
  var _isLoadingMore = false;
  String? _nextCursor;
  String _query = '';
  late List<ProjectMemberProfile> _visible;

  @override
  void initState() {
    super.initState();
    _visible = widget.candidates;
    _scrollController.addListener(_loadNextPageIfNeeded);
    if (widget.searchEligibleProfiles != null) unawaited(_loadFirstPage());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 252,
    height: 294,
    child: Column(
      children: [
        Padding(
          padding: const .fromLTRB(6, 6, 6, 4),
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: context.text.labelMedium,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const .symmetric(
                horizontal: 8,
                vertical: 7,
              ),
              hintText: 'Szukaj osób…',
              hintStyle: context.text.labelMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Symbols.search_rounded,
                size: 16,
                color: context.colors.onSurfaceVariant,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 30,
                height: 30,
              ),
              suffixIcon: _isSearching
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
        ),
        const Divider(height: 1),
        if (widget.selectionMode == AssigneeMenuAction.setOwner &&
            widget.primaryId != null) ...[
          InkWell(
            mouseCursor: SystemMouseCursors.click,
            onTap: () => Navigator.of(context).pop('__clear_owner__'),
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
        Expanded(
          child: _visible.isEmpty
              ? const Center(child: Text('Nie znaleziono osób'))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const .symmetric(vertical: 2),
                  itemCount: _visible.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _visible.length) {
                      return const Padding(
                        padding: .symmetric(vertical: 10),
                        child: Center(
                          child: SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final profile = _visible[index];
                    final selected =
                        widget.selectionMode == AssigneeMenuAction.setOwner
                        ? profile.coreUserId == widget.primaryId
                        : widget.selectedIds.contains(profile.coreUserId);
                    return ListTile(
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
                        _profileLabel(profile),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelMedium,
                      ),
                      trailing: Icon(
                        selected
                            ? Symbols.check_circle_rounded
                            : Symbols.add_rounded,
                        color: selected
                            ? context.colors.primary
                            : context.colors.onSurfaceVariant,
                        size: 16,
                      ),
                      onTap: () =>
                          Navigator.of(context).pop(profile.coreUserId),
                    );
                  },
                ),
        ),
      ],
    ),
  );

  void _onQueryChanged(String raw) {
    _debounce?.cancel();
    final request = ++_request;
    final query = raw.trim();
    final local = query.isEmpty
        ? widget.candidates
        : widget.candidates
              .where(
                (profile) => _profileLabel(profile).toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList(growable: false);
    setState(() {
      _visible = local;
      _query = query;
      _nextCursor = null;
      _isLoadingMore = false;
      _isSearching = query.length >= 2 && widget.searchEligibleProfiles != null;
    });
    if (query.length < 2 || widget.searchEligibleProfiles == null) return;
    _debounce = Timer(const Duration(milliseconds: 220), () async {
      final remote = await widget.searchEligibleProfiles!(query: query);
      if (!mounted || request != _request) return;
      setState(() {
        _visible = remote.items;
        _nextCursor = remote.nextCursor;
        _isSearching = false;
      });
    });
  }

  Future<void> _loadFirstPage() async {
    final loader = widget.searchEligibleProfiles;
    if (loader == null) return;
    final request = ++_request;
    setState(() {
      _isSearching = true;
      _isLoadingMore = false;
    });
    final page = await loader();
    if (!mounted || request != _request) return;
    setState(() {
      _visible = page.items;
      _nextCursor = page.nextCursor;
      _isSearching = false;
    });
  }

  void _loadNextPageIfNeeded() {
    if (!_scrollController.hasClients ||
        _scrollController.position.extentAfter > 80 ||
        _isLoadingMore ||
        _nextCursor == null ||
        widget.searchEligibleProfiles == null) {
      return;
    }
    unawaited(_loadNextPage());
  }

  Future<void> _loadNextPage() async {
    final cursor = _nextCursor;
    final loader = widget.searchEligibleProfiles;
    if (cursor == null || loader == null || _isLoadingMore) return;
    final request = _request;
    setState(() => _isLoadingMore = true);
    final page = await loader(
      query: _query.isEmpty ? null : _query,
      cursor: cursor,
    );
    if (!mounted || request != _request) return;
    setState(() {
      final knownIds = _visible.map((profile) => profile.coreUserId).toSet();
      _visible = [
        ..._visible,
        ...page.items.where((profile) => knownIds.add(profile.coreUserId)),
      ];
      _nextCursor = page.nextCursor;
      _isLoadingMore = false;
    });
  }
}

String _profileLabel(ProjectMemberProfile profile) {
  final name = profile.displayName?.trim();
  return name?.isNotEmpty == true ? name! : 'Nieznany użytkownik';
}

RelativeRect _menuPositionFor(BuildContext context) {
  final renderBox = context.findRenderObject() as RenderBox?;
  if (renderBox == null) return RelativeRect.fill;
  final translation = renderBox.getTransformTo(null).getTranslation();
  final size = renderBox.size;
  return RelativeRect.fromLTRB(
    translation.x,
    translation.y + size.height,
    translation.x + size.width,
    translation.y + size.height,
  );
}
