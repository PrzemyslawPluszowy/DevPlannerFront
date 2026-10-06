import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_discard_confirmation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_content.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_route_references.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_route_tracker.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_tab_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Synchronizuje parametr `task` z rootowym navigatorem wspólnych modali.
///
/// Tablica pozostaje zamontowana pod dialogiem. Zmiany query obsługują
/// wyłącznie callbacki cyklu życia, poza renderowaniem.
final class TaskDetailModalNavigationHost extends StatefulWidget {
  const TaskDetailModalNavigationHost({
    required this.child,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    required this.detailsComposition,
    this.memberProfilesRepository,
    this.settingsComposition,
    super.key,
  });

  final Widget child;
  final String workspaceId;
  final String projectId;
  final String? taskId;
  final TasksDetailsComposition? detailsComposition;
  final ProjectSettingsComposition? settingsComposition;
  final ProjectMemberProfilesRepository? memberProfilesRepository;

  @override
  State<TaskDetailModalNavigationHost> createState() =>
      _TaskDetailModalNavigationHostState();
}

final class _TaskDetailModalNavigationHostState
    extends State<TaskDetailModalNavigationHost> {
  final TaskDetailModalRouteReferences _routes =
      TaskDetailModalRouteReferences();
  TaskDetailModalSnapshot? _activeSnapshot;
  DevPlannerGlobalChatComposition? _observedChatComposition;
  AuthSessionPort? _observedAuthSession;
  StorageRepository? _observedStorageRepository;
  ChatEmojiRecentCubit? _observedEmojiRecentCubit;
  String? _observedUserId;
  TaskDetailDraftRegistry? _activeDraftRegistry;
  ValueNotifier<TaskDetailsModalTab?>? _tabIntent;
  String? _activeLocation;
  int _syncGeneration = 0;
  int _modalGeneration = 0;
  bool _closePromptOpen = false;

  String? get _activeTaskId => _activeSnapshot?.taskId;
  String? get _activeWorkspaceId => _activeSnapshot?.workspaceId;
  String? get _activeProjectId => _activeSnapshot?.projectId;

  @override
  void initState() {
    super.initState();
    _scheduleSync();
  }

  @override
  void didUpdateWidget(covariant TaskDetailModalNavigationHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetTabChanged =
        TaskDetailModalTabIntent.fromUri(_currentUri) !=
        _activeSnapshot?.targetTab;
    if (_activeSnapshot?.taskId == widget.taskId &&
        _activeSnapshot?.workspaceId == widget.workspaceId &&
        _activeSnapshot?.projectId == widget.projectId &&
        identical(_activeSnapshot?.composition, widget.detailsComposition) &&
        identical(
          _activeSnapshot?.memberProfilesRepository,
          widget.memberProfilesRepository,
        ) &&
        widget.taskId != null) {
      _activeLocation = _currentUri.toString();
    }
    if (oldWidget.taskId != widget.taskId ||
        oldWidget.workspaceId != widget.workspaceId ||
        oldWidget.projectId != widget.projectId ||
        !identical(oldWidget.detailsComposition, widget.detailsComposition) ||
        !identical(oldWidget.settingsComposition, widget.settingsComposition) ||
        !identical(
          oldWidget.memberProfilesRepository,
          widget.memberProfilesRepository,
        ) ||
        targetTabChanged) {
      _scheduleSync();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final chat = Provider.of<DevPlannerGlobalChatComposition?>(context);
    final auth = Provider.of<AuthSessionPort?>(context);
    final storage = Provider.of<StorageRepository?>(context);
    final emoji = Provider.of<ChatEmojiRecentCubit?>(context);
    final userId = auth == null ? chat?.userId : auth.snapshot.user?.userId;
    final changed =
        !identical(chat, _observedChatComposition) ||
        !identical(auth, _observedAuthSession) ||
        !identical(storage, _observedStorageRepository) ||
        !identical(emoji, _observedEmojiRecentCubit) ||
        userId != _observedUserId;
    _observedChatComposition = chat;
    _observedAuthSession = auth;
    _observedStorageRepository = storage;
    _observedEmojiRecentCubit = emoji;
    _observedUserId = userId;
    if (changed && _activeTaskId != null) _scheduleSync();
  }

  @override
  void dispose() {
    _syncGeneration++;
    _modalGeneration++;
    _activeDraftRegistry?.dispose();
    _tabIntent?.dispose();
    _routes.dispose();
    super.dispose();
  }

  void _scheduleSync() {
    final generation = ++_syncGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _syncGeneration) return;
      _synchronizeModal();
    });
  }

  void _synchronizeModal() {
    final sessionChanged =
        _activeTaskId != null &&
        (!identical(_activeSnapshot?.authSession, _observedAuthSession) ||
            _activeSnapshot?.userId != _observedUserId);
    final desiredTaskId = sessionChanged ? null : widget.taskId;
    final currentLocation = _currentUri.toString();
    final desired = TaskDetailModalSnapshot(
      taskId: desiredTaskId,
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      composition: widget.detailsComposition,
      settingsComposition: widget.settingsComposition,
      memberProfilesRepository: widget.memberProfilesRepository,
      location: currentLocation,
      targetTab: TaskDetailModalTabIntent.fromUri(Uri.parse(currentLocation)),
      chatComposition: _observedChatComposition,
      authSession: _observedAuthSession,
      storageRepository: _observedStorageRepository,
      emojiRecentCubit: _observedEmojiRecentCubit,
      userId: _observedUserId,
    );
    if (desiredTaskId == null && _activeTaskId == null) return;
    if (desired.hasSameScope(_activeSnapshot)) {
      _activeLocation = currentLocation;
      final previousTab = _activeSnapshot?.targetTab;
      if (desired.targetTab != previousTab) {
        _tabIntent?.value = desired.targetTab ?? TaskDetailsModalTab.work;
      }
      _activeSnapshot = desired;
      return;
    }
    if (_activeTaskId != null &&
        !sessionChanged &&
        (_activeDraftRegistry?.hasUnsavedDrafts ?? false)) {
      unawaited(_confirmTransition(desired, _syncGeneration));
      return;
    }
    _applySnapshot(desired);
  }

  Future<void> _confirmTransition(
    TaskDetailModalSnapshot desired,
    int syncGeneration,
  ) async {
    if (_closePromptOpen) return;
    _closePromptOpen = true;
    final activeTaskId = _activeTaskId;
    final modalGeneration = _modalGeneration;
    final registry = _activeDraftRegistry;
    final shouldDiscard = await DevPlannerModalHost.showDialog<bool>(
      context,
      barrierDismissible: false,
      builder: (_) => TaskDetailModalRouteTracker(
        taskId: activeTaskId ?? '',
        generation: modalGeneration,
        onRouteMounted: _recordConfirmationRoute,
        child: const TaskDetailDraftDiscardConfirmation(),
      ),
    );
    if (!mounted) return;
    _routes.removeConfirmation();
    _closePromptOpen = false;
    if (syncGeneration != _syncGeneration ||
        modalGeneration != _modalGeneration ||
        activeTaskId != _activeTaskId ||
        !identical(registry, _activeDraftRegistry)) {
      _scheduleSync();
      return;
    }
    if (shouldDiscard == true) {
      _applySnapshot(desired);
      return;
    }
    final restoreLocation = _activeLocation;
    if (restoreLocation != null) {
      unawaited(GoRouter.of(context).replace(restoreLocation));
    }
  }

  void _applySnapshot(TaskDetailModalSnapshot desired) {
    _modalGeneration++;
    _routes.removeDialog();
    _activeDraftRegistry?.dispose();
    _activeDraftRegistry = null;
    _tabIntent?.dispose();
    _tabIntent = null;
    _activeSnapshot = null;
    _activeLocation = null;
    if (desired.taskId == null) return;

    final taskId = desired.taskId!;
    _activeSnapshot = desired;
    _activeLocation = desired.location;
    _tabIntent = ValueNotifier<TaskDetailsModalTab?>(
      desired.targetTab ?? TaskDetailsModalTab.work,
    );
    _activeDraftRegistry = TaskDetailDraftRegistry();
    final generation = _modalGeneration;
    _showTaskDialog(
      taskId: taskId,
      workspaceId: desired.workspaceId,
      projectId: desired.projectId,
      draftRegistry: _activeDraftRegistry!,
      snapshot: desired,
      tabIntent: _tabIntent!,
      generation: generation,
    );
  }

  void _showTaskDialog({
    required String taskId,
    required String workspaceId,
    required String projectId,
    required TaskDetailDraftRegistry draftRegistry,
    required TaskDetailModalSnapshot snapshot,
    required ValueListenable<TaskDetailsModalTab?> tabIntent,
    required int generation,
  }) {
    unawaited(
      DevPlannerModalHost.showDialog<void>(
        context,
        onDismissAttempt: () => _closeFromDialog(taskId, generation),
        builder: (_) {
          return TaskDetailModalRouteTracker(
            taskId: taskId,
            generation: generation,
            onRouteMounted: _recordDialogRoute,
            child: TaskDetailModalContent(
              snapshot: snapshot,
              tabIntent: tabIntent,
              draftRegistry: draftRegistry,
              onClose: () => _closeFromDialog(taskId, generation),
              onTabSelected: _handleTabSelected,
            ),
          );
        },
      ).then((_) {
        if (!mounted || generation != _modalGeneration) return;
        _routes.removeDialog();
        if (widget.taskId == taskId &&
            widget.workspaceId == workspaceId &&
            widget.projectId == projectId) {
          _closeFromDialog(taskId, generation);
        }
      }),
    );
  }

  void _closeFromDialog(String taskId, int generation) {
    if (!mounted ||
        generation != _modalGeneration ||
        widget.taskId != taskId ||
        widget.workspaceId != _activeWorkspaceId ||
        widget.projectId != _activeProjectId) {
      return;
    }
    unawaited(_requestExplicitClose(taskId, generation));
  }

  void _handleTabSelected(TaskDetailsModalTab tab) {
    if (!mounted || _activeTaskId == null) return;
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    final uri = _currentUri;
    final updated = TaskDetailModalTabIntent.withSelection(uri, tab);
    if (updated != uri) router.go(updated.toString());
  }

  Uri get _currentUri =>
      GoRouter.maybeOf(context)?.routerDelegate.currentConfiguration.uri ??
      Uri.base;

  Future<void> _requestExplicitClose(String taskId, int generation) async {
    if (_closePromptOpen || !mounted || generation != _modalGeneration) return;
    if (_activeDraftRegistry?.hasUnsavedDrafts ?? false) {
      _closePromptOpen = true;
      final shouldDiscard = await DevPlannerModalHost.showDialog<bool>(
        context,
        barrierDismissible: false,
        builder: (_) => TaskDetailModalRouteTracker(
          taskId: taskId,
          generation: generation,
          onRouteMounted: _recordConfirmationRoute,
          child: const TaskDetailDraftDiscardConfirmation(),
        ),
      );
      if (!mounted) return;
      _routes.removeConfirmation();
      _closePromptOpen = false;
      if (generation != _modalGeneration) {
        _scheduleSync();
        return;
      }
      if (widget.taskId != taskId ||
          widget.workspaceId != _activeWorkspaceId ||
          widget.projectId != _activeProjectId) {
        _scheduleSync();
        return;
      }
      if (shouldDiscard != true) {
        return;
      }
    }
    if (!mounted || generation != _modalGeneration) return;
    final uri = GoRouterState.of(context).uri;
    if (uri.queryParameters['taskReturn'] == '/me/tasks') {
      unawaited(GoRouter.of(context).replace('/me/tasks'));
      return;
    }
    final query = Map<String, List<String>>.of(uri.queryParametersAll)
      ..remove('task')
      ..remove('taskTab')
      ..remove('taskReturn');
    unawaited(
      GoRouter.of(context)
          .replace(uri.replace(queryParameters: query).toString()),
    );
  }

  void _recordDialogRoute(
    ModalRoute<dynamic>? route,
    String taskId,
    int generation,
  ) {
    _routes.captureDialog(
      route,
      accepted:
          mounted && generation == _modalGeneration && widget.taskId == taskId,
    );
  }

  void _recordConfirmationRoute(
    ModalRoute<dynamic>? route,
    String taskId,
    int generation,
  ) {
    _routes.captureConfirmation(
      route,
      accepted:
          mounted && generation == _modalGeneration && _activeTaskId == taskId,
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
