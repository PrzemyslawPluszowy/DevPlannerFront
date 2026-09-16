part of 'task_details_page.dart';

class _EditAssigneesDialog extends StatefulWidget {
  const _EditAssigneesDialog({required this.task});

  final ProjectTaskResponse task;

  @override
  State<_EditAssigneesDialog> createState() => _EditAssigneesDialogState();
}

class _EditAssigneesDialogState extends State<_EditAssigneesDialog> {
  late final Future<List<ProjectMemberProfile>> _profiles;
  late final Set<String> _selected;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.task.assignees
        .map((assignee) => assignee.coreUserId)
        .toSet();
    final cubit = context.read<TaskDetailsCubit>();
    _profiles = context
        .read<ProjectMemberProfilesRepository>()
        .listProfiles(
          workspaceId: cubit.workspaceId,
          projectId: cubit.projectId,
        )
        .then(
          (result) => result.fold(
            (error) => throw Exception(error.message),
            (items) => items,
          ),
        );
  }

  @override
  Widget build(BuildContext context) => WorkspaceCreationModalWrapper(
    title: context.l10n.taskDetailsEditAssignees,
    icon: Symbols.group_rounded,
    accentColor: context.colors.primary,
    isSubmitting: _saving,
    submitLabel: context.l10n.save,
    cancelLabel: context.l10n.cancel,
    maxWidth: 460,
    onSubmit: _saving ? null : _save,
    body: FutureBuilder<List<ProjectMemberProfile>>(
      future: _profiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text(context.l10n.taskDetailsAssigneesLoadError);
        }
        final profiles = snapshot.data ?? const <ProjectMemberProfile>[];
        if (profiles.isEmpty) {
          return Text(context.l10n.taskDetailsNoProjectMembers);
        }
        return ConstrainedBox(
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
              final selected = _selected.contains(profile.coreUserId);
              return CheckboxListTile(
                value: selected,
                enabled: !_saving,
                onChanged: (value) => setState(() {
                  value == true
                      ? _selected.add(profile.coreUserId)
                      : _selected.remove(profile.coreUserId);
                }),
                secondary: CircleAvatar(
                  foregroundImage: profile.avatarUrl?.isNotEmpty == true
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  backgroundColor: _avatarColor(label),
                  child: profile.avatarUrl?.isNotEmpty == true
                      ? null
                      : Text(
                          label.characters.first.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
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
        );
      },
    ),
  );

  Future<void> _save() async {
    setState(() => _saving = true);
    final saved = await context.read<TaskDetailsCubit>().replaceAssignees(
      _selected.toList(growable: false),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }
}

/// Sekcja obserwowania zadania z kompaktowym stosem avatarów.
class _TaskWatchersSection extends StatelessWidget {
  const _TaskWatchersSection({required this.details, required this.isSaving});

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final people = {
      for (final user in details.includedUsers) user.coreUserId: user,
    };
    final visible = details.watchers.take(5).toList(growable: false);
    final remaining = details.watchers.length - visible.length;
    return _Section(
      title: context.l10n.taskDetailsWatchers,
      action: TextButton.icon(
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
        ),
      ),
      child: details.watchers.isEmpty
          ? Text(
              context.l10n.taskDetailsNoWatchers,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final watcher in visible)
                  _WatcherAvatar(user: people[watcher.coreUserId]),
                if (remaining > 0) _WatcherOverflow(count: remaining),
              ],
            ),
    );
  }
}

class _WatcherAvatar extends StatelessWidget {
  const _WatcherAvatar({required this.user});

  final UserReferenceResponse? user;

  @override
  Widget build(BuildContext context) {
    final label = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : user?.coreUserId ?? '?';
    final initial = label.characters.first.toUpperCase();
    final avatarUrl = user?.avatarUrl?.trim();
    return Tooltip(
      message: label,
      child: CircleAvatar(
        radius: 17,
        foregroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        backgroundColor: _avatarColor(label),
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _WatcherOverflow extends StatelessWidget {
  const _WatcherOverflow({required this.count});

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

Color _avatarColor(String value) {
  const palette = [
    Color(0xFF6366F1),
    Color(0xFF0F766E),
    Color(0xFFB45309),
    Color(0xFFBE123C),
    Color(0xFF7C3AED),
  ];
  return palette[value.hashCode.abs() % palette.length];
}
