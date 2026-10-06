import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/collaboration/cubit/task_member_profiles_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

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
  late final Set<String> _initial;
  final TextEditingController _search = TextEditingController();

  bool get _changed =>
      _selected.value.length != _initial.length ||
      !_selected.value.containsAll(_initial);

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
    _initial = Set.unmodifiable(
      widget.task.assignees.map((assignee) => assignee.userId),
    );
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
    builder: (context, _) =>
        BlocBuilder<TaskMemberProfilesCubit, TaskMemberProfilesState>(
          bloc: _profilesCubit,
          builder: (context, profilesState) => WorkspaceCreationModalWrapper(
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
            onSubmit:
                _saving.value ||
                    !_changed ||
                    profilesState is! TaskMemberProfilesReady
                ? null
                : _save,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TaskDetailsDialogMutationError(),
                TextField(
                  controller: _search,
                  enabled:
                      !_saving.value &&
                      profilesState is TaskMemberProfilesReady,
                  onChanged: _profilesCubit.search,
                  decoration: InputDecoration(
                    labelText: context.l10n.tasksAssigneeSearchPeople,
                    prefixIcon: const Icon(Symbols.search_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profilesState is TaskMemberProfilesReady
                      ? context.l10n.taskAssigneesSelectionSummary(
                          _selected.value.length,
                          _selected.value
                              .difference(profilesState.visibleUserIds)
                              .length,
                        )
                      : context.l10n.taskAssigneesSelectionSummary(
                          _selected.value.length,
                          0,
                        ),
                  style: context.tasksTheme.metaText,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: (MediaQuery.sizeOf(context).height * .45).clamp(
                    120.0,
                    420.0,
                  ),
                  child: BlocBuilder<TaskMemberProfilesCubit, TaskMemberProfilesState>(
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
                      TaskMemberProfilesReady(
                        :final profiles,
                        :final totalCount,
                      ) =>
                        profiles.isEmpty
                            ? Center(
                                child: Text(
                                  totalCount == 0
                                      ? context.l10n.taskDetailsNoProjectMembers
                                      : context
                                            .l10n
                                            .taskAssigneesNoSearchResults,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: profiles.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 4),
                                itemBuilder: (context, index) {
                                  final profile = profiles[index];
                                  final displayName = profile.displayName
                                      ?.trim();
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
                                      _selected.value = Set.unmodifiable(
                                        selectedIds,
                                      );
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
                                      child:
                                          profile.avatarUrl?.isNotEmpty == true
                                          ? null
                                          : Text(
                                              label.characters.first
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color:
                                                    context.tasksTheme.onAccent,
                                              ),
                                            ),
                                    ),
                                    title: Text(label),
                                    subtitle: Text(switch (profile.role) {
                                      ProjectRole.owner =>
                                        context
                                            .l10n
                                            .projectSettingsMemberRoleOwner,
                                      ProjectRole.admin =>
                                        context
                                            .l10n
                                            .projectSettingsMemberRoleAdmin,
                                      ProjectRole.member =>
                                        context
                                            .l10n
                                            .projectSettingsMemberRoleMember,
                                      ProjectRole.observer =>
                                        context
                                            .l10n
                                            .projectSettingsMemberRoleObserver,
                                    }),
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  );
                                },
                              ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
  );

  Future<void> _save() async {
    if (_saving.value ||
        !_changed ||
        _profilesCubit.state is! TaskMemberProfilesReady) {
      return;
    }
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
    _search.dispose();
    _selected.dispose();
    _saving.dispose();
    unawaited(_profilesCubit.close());
    super.dispose();
  }
}
