import 'package:devplanner/workspaces/presentation/tasks/detail/collaboration/cubit/task_member_profiles_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class EditAssigneesDialog extends StatefulWidget {
  const EditAssigneesDialog({required this.task, super.key});

  final ProjectTaskResponse task;

  @override
  State<EditAssigneesDialog> createState() => EditAssigneesDialogState();
}

class EditAssigneesDialogState extends State<EditAssigneesDialog> {
  TaskDetailDraftRegistration? _draft;
  late final TaskMemberProfilesCubit _profilesCubit;
  late final ValueNotifier<Set<String>> _selected;
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  late final Listenable _formChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditAssignees,
    );
  }

  void _refreshDraft() {
    final initial = widget.task.assignees.map((item) => item.userId).toSet();
    final selected = _selected.value;
    if (initial.length == selected.length && initial.containsAll(selected)) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void initState() {
    super.initState();
    _selected = ValueNotifier(
      Set.unmodifiable(
        widget.task.assignees.map((assignee) => assignee.userId),
      ),
    );
    _formChanges = Listenable.merge([_selected, _saving]);
    final cubit = context.read<TaskDetailsCubit>();
    _profilesCubit = TaskMemberProfilesCubit(
      repository: context.read<ProjectMemberProfilesRepository>(),
      workspaceId: cubit.workspaceId,
      projectId: cubit.projectId,
    );
    unawaited(_profilesCubit.load());
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _formChanges,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditAssignees,
      icon: Symbols.group_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 460,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: _saving.value ? null : _save,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TaskDetailsDialogMutationError(),
          BlocBuilder<TaskMemberProfilesCubit, TaskMemberProfilesState>(
            bloc: _profilesCubit,
            builder: (context, state) => switch (state) {
              TaskMemberProfilesLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              TaskMemberProfilesFailure(:final error) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TaskDetailsModalError(error: error),
                  TextButton.icon(
                    onPressed: () => unawaited(_profilesCubit.load()),
                    icon: const Icon(Symbols.refresh_rounded),
                    label: Text(context.l10n.retry),
                  ),
                ],
              ),
              TaskMemberProfilesReady(:final profiles) =>
                profiles.isEmpty
                    ? Text(context.l10n.taskDetailsNoProjectMembers)
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 420),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: profiles.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            final displayName = profile.displayName?.trim();
                            final label = displayName?.isNotEmpty == true
                                ? displayName!
                                : context.l10n.taskDetailsProjectMember;
                            final selected = _selected.value.contains(
                              profile.userId,
                            );
                            return CheckboxListTile(
                              value: selected,
                              enabled: !_saving.value,
                              onChanged: (value) {
                                final selectedIds = {..._selected.value};
                                value == true
                                    ? selectedIds.add(profile.userId)
                                    : selectedIds.remove(profile.userId);
                                _selected.value = Set.unmodifiable(selectedIds);
                                _refreshDraft();
                              },
                              secondary: CircleAvatar(
                                foregroundImage:
                                    profile.avatarUrl?.isNotEmpty == true
                                    ? NetworkImage(profile.avatarUrl!)
                                    : null,
                                backgroundColor:
                                    TaskCollaboratorAvatarPalette.colorFor(
                                      label,
                                    ),
                                child: profile.avatarUrl?.isNotEmpty == true
                                    ? null
                                    : Text(
                                        label.characters.first.toUpperCase(),
                                        style: TextStyle(
                                          color: context.tasksTheme.onAccent,
                                        ),
                                      ),
                              ),
                              title: Text(label),
                              subtitle: Text(profile.role.name),
                              controlAffinity: ListTileControlAffinity.trailing,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                      ),
            },
          ),
        ],
      ),
    ),
  );

  Future<void> _save() async {
    if (_saving.value) return;
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    final saved = await source.replaceAssignees(
      _selected.value.toList(growable: false),
    );
    if (!mounted) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.of(context).pop();
    } else {
      _saving.value = false;
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _selected.dispose();
    _saving.dispose();
    unawaited(_profilesCubit.close());
    super.dispose();
  }
}

/// Sekcja obserwowania zadania z kompaktowym stosem avatarów.
class TaskWatchersSection extends StatelessWidget {
  const TaskWatchersSection({
    required this.details,
    required this.isSaving,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 460;
      final action = TaskWatchToggleButton(
        details: details,
        isSaving: isSaving,
      );
      return Section(
        title: context.l10n.taskDetailsWatchers,
        action: compact ? null : action,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compact) Align(alignment: Alignment.centerLeft, child: action),
            TaskWatchersAvatars(details: details),
          ],
        ),
      );
    },
  );
}

final class TaskWatchToggleButton extends StatelessWidget {
  const TaskWatchToggleButton({
    required this.details,
    required this.isSaving,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: isSaving
        ? null
        : () => context.read<TaskDetailsCubit>().toggleWatching(),
    icon: Icon(
      details.isWatchedByMe
          ? Symbols.notifications_active
          : Symbols.notifications_none_rounded,
      size: 18,
    ),
    label: Text(
      details.isWatchedByMe
          ? context.l10n.taskDetailsStopWatching
          : context.l10n.taskDetailsWatch,
      softWrap: true,
    ),
  );
}

final class TaskWatchersAvatars extends StatelessWidget {
  const TaskWatchersAvatars({required this.details, super.key});

  final ProjectTaskDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    if (details.watchers.isEmpty) {
      return Text(
        context.l10n.taskDetailsNoWatchers,
        style: context.text.bodyMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      );
    }
    final visible = details.watchers.take(5);
    final remaining = details.watchers.length - visible.length;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final watcher in visible)
          WatcherAvatar(
            user: details.includedUsers
                .where((user) => user.userId == watcher.userId)
                .firstOrNull,
          ),
        if (remaining > 0) WatcherOverflow(count: remaining),
      ],
    );
  }
}

class WatcherAvatar extends StatelessWidget {
  const WatcherAvatar({required this.user, super.key});

  final UserReferenceResponse? user;

  @override
  Widget build(BuildContext context) {
    final label = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : user?.userId ?? '?';
    final initial = label.characters.first.toUpperCase();
    final avatarUrl = user?.avatarUrl?.trim();
    return Tooltip(
      message: label,
      child: CircleAvatar(
        radius: 17,
        foregroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        backgroundColor: TaskCollaboratorAvatarPalette.colorFor(label),
        child: Text(
          initial,
          style: context.tasksTheme.metaText.copyWith(
            height: 1,
            fontWeight: FontWeight.w700,
            color: context.tasksTheme.onAccent,
          ),
        ),
      ),
    );
  }
}

class WatcherOverflow extends StatelessWidget {
  const WatcherOverflow({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 17,
    backgroundColor: context.colors.surfaceContainerHighest,
    child: Text(
      context.l10n.taskDetailsWatchersMore(count),
      style: context.text.labelSmall?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

/// Deterministyczna paleta awatarów współpracowników bez stanu i I/O.
final class TaskCollaboratorAvatarPalette {
  const TaskCollaboratorAvatarPalette._();

  static Color colorFor(String value) {
    const palette = [
      Color(0xFF4F46E5),
      Color(0xFF0F766E),
      Color(0xFF92400E),
      Color(0xFFBE123C),
      Color(0xFF7C3AED),
    ];
    return palette[value.hashCode.abs() % palette.length];
  }
}
