part of 'tasks_board_page.dart';

final class TaskTemplatePickerOverlay {
  const TaskTemplatePickerOverlay._();

  static Future<void> show(BuildContext context) {
    final boardCubit = context.read<TasksBoardCubit>();
    final pickerCubit = context.read<TaskTemplatePickerCubit>();
    final customFieldsFuture = context
        .read<TaskMetadataRepository>()
        .listCustomFields(
          workspaceId: boardCubit.workspaceId,
          projectId: boardCubit.projectId,
        )
        .then(
          (result) => result.getOrElse(
            () => const <TaskCustomFieldResponse>[],
          ),
        );
    return AppExpandableSideSheet.show<void>(
      context,
      title: context.l10n.tasksTemplatesTitle,
      subtitle: context.l10n.tasksTemplatesDescription,
      leading: Icon(
        Symbols.auto_awesome_mosaic,
        color: context.colors.primary,
      ),
      collapsedWidth: 620,
      expandedWidth: 900,
      padding: EdgeInsets.zero,
      scrollBody: false,
      bodyBuilder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: boardCubit),
          BlocProvider.value(value: pickerCubit),
        ],
        child: TaskTemplatePickerBody(
          boardCubit: boardCubit,
          pickerCubit: pickerCubit,
          customFieldsFuture: customFieldsFuture,
        ),
      ),
    );
  }
}

/// Główna zawartość panelu bocznego biblioteki szablonów zadań.
class TaskTemplatePickerBody extends StatelessWidget {
  const TaskTemplatePickerBody({
    required this.boardCubit,
    this.pickerCubit,
    this.customFieldsFuture,
    super.key,
  });

  final TasksBoardCubit boardCubit;
  final TaskTemplatePickerCubit? pickerCubit;
  final Future<List<TaskCustomFieldResponse>>? customFieldsFuture;

  @override
  Widget build(BuildContext context) {
    final effectiveCubit =
        pickerCubit ?? context.read<TaskTemplatePickerCubit>();
    return BlocBuilder<TaskTemplatePickerCubit, TaskTemplatePickerState>(
      bloc: effectiveCubit,
      builder: (context, state) => switch (state) {
        TaskTemplatePickerLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        TaskTemplatePickerFailure(:final message) => _TemplatePickerError(
          message: message,
          onRetry: () => unawaited(effectiveCubit.load()),
        ),
        TaskTemplatePickerReady() =>
          FutureBuilder<List<TaskCustomFieldResponse>>(
            future: customFieldsFuture,
            initialData: const <TaskCustomFieldResponse>[],
            builder: (context, snapshot) => _TaskTemplatePickerList(
              state: state,
              boardCubit: boardCubit,
              pickerCubit: effectiveCubit,
              customFields: snapshot.data ?? const <TaskCustomFieldResponse>[],
            ),
          ),
      },
    );
  }
}

class _TemplatePickerError extends StatelessWidget {
  const _TemplatePickerError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const .all(24),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(
            Symbols.cloud_off_rounded,
            size: 48,
            color: context.colors.error,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: .center,
            style: TextStyle(color: context.colors.error),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Symbols.refresh_rounded),
            label: Text(context.l10n.taskDetailsHistoryRetry),
          ),
        ],
      ),
    ),
  );
}

class _TaskTemplatePickerList extends StatefulWidget {
  const _TaskTemplatePickerList({
    required this.state,
    required this.boardCubit,
    required this.pickerCubit,
    required this.customFields,
  });

  final TaskTemplatePickerReady state;
  final TasksBoardCubit boardCubit;
  final TaskTemplatePickerCubit pickerCubit;
  final List<TaskCustomFieldResponse> customFields;

  @override
  State<_TaskTemplatePickerList> createState() =>
      _TaskTemplatePickerListState();
}

class _TaskTemplatePickerListState extends State<_TaskTemplatePickerList> {
  final ValueNotifier<String?> _applyingTemplateId = ValueNotifier(null);

  @override
  void dispose() {
    _applyingTemplateId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String?>(
    valueListenable: _applyingTemplateId,
    builder: (context, applyingTemplateId, _) =>
        _buildTemplateList(context, applyingTemplateId),
  );

  Widget _buildTemplateList(BuildContext context, String? applyingTemplateId) {
    final state = widget.state;
    final colors = context.colors;
    final l10n = context.l10n;
    final boardState = widget.boardCubit.state;
    final rawMembers = boardState is TasksBoardReady
        ? boardState.memberProfilesByUserId.values.toList(growable: false)
        : const <ProjectMemberProfile>[];
    final currentUser = context.read<AuthSessionPort?>()?.snapshot.user;
    final members = [
      for (final member in rawMembers)
        if (member.displayName?.trim().isNotEmpty == true ||
            currentUser?.userId.toLowerCase() != member.userId.toLowerCase())
          member
        else
          ProjectMemberProfile(
            userId: member.userId,
            role: member.role,
            displayName: currentUser?.displayName.trim().isNotEmpty == true
                ? currentUser!.displayName.trim()
                : currentUser?.login,
            avatarUrl: member.avatarUrl,
          ),
    ];
    final columns = boardState is TasksBoardReady
        ? boardState.board.columns
        : const <KanbanColumnResponse>[];

    return Column(
      children: [
        Padding(
          padding: const .fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.tasksTemplatesTitle,
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: .w600,
                  ),
                ),
              ),
              if (state.templates.isNotEmpty)
                FilledButton.icon(
                  onPressed: () => unawaited(
                    _TemplateManagementActions.createTemplateFromDefinition(
                      context,
                      members,
                      columns: columns,
                      pickerCubit: widget.pickerCubit,
                      customFields: widget.customFields,
                    ),
                  ),
                  icon: const Icon(Symbols.add_rounded, size: 18),
                  label: Text(l10n.tasksTemplatesNew),
                  style: FilledButton.styleFrom(
                    visualDensity: .compact,
                    padding: const .symmetric(horizontal: Sizes.p12),
                    minimumSize: const Size(0, 32),
                    shape: const RoundedRectangleBorder(
                      borderRadius: .all(.circular(Sizes.p8)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (state.error != null)
          Padding(
            padding: const .symmetric(horizontal: 16, vertical: 4),
            child: Text(
              state.error!,
              style: TextStyle(color: colors.error),
            ),
          ),
        if (state.templates.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Icon(
                    Symbols.auto_awesome_mosaic_rounded,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: .4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.tasksTemplatesEmpty,
                    style: context.text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => unawaited(
                      _TemplateManagementActions.createTemplateFromDefinition(
                        context,
                        members,
                        columns: columns,
                        pickerCubit: widget.pickerCubit,
                        customFields: widget.customFields,
                      ),
                    ),
                    icon: const Icon(Symbols.add_rounded),
                    label: Text(l10n.tasksTemplatesEmptyCreateCta),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const .symmetric(horizontal: 16, vertical: 8),
              itemCount: state.templates.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final template = state.templates[index];
                final isDefault = template.id == state.defaultTemplateId;
                final applying = template.id == applyingTemplateId;
                final busy =
                    state.updatingTemplateId == template.id ||
                    state.deletingTemplateId == template.id;
                return _TaskTemplateTile(
                  template: template,
                  isDefault: isDefault,
                  applying: applying,
                  savingDefault: state.isSavingDefault,
                  busy: busy,
                  members: members,
                  columns: columns,
                  pickerCubit: widget.pickerCubit,
                  customFields: widget.customFields,
                  onApply: () => _apply(template.id),
                  onToggleDefault: () => unawaited(
                    widget.pickerCubit.toggleDefault(template.id),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _apply(String templateId) async {
    if (_applyingTemplateId.value != null) return;
    final titleController = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => WorkspaceCreationModalWrapper(
        title: context.l10n.tasksQuickCreate,
        subtitle: context.l10n.tasksTemplatesUse,
        icon: Symbols.add_task_rounded,
        accentColor: context.colors.primary,
        submitLabel: context.l10n.tasksQuickCreate,
        cancelLabel: context.l10n.cancel,
        maxWidth: 440,
        onSubmit: () {
          final value = titleController.text.trim();
          if (value.isNotEmpty) Navigator.of(dialogContext).pop(value);
        },
        body: TextField(
          controller: titleController,
          autofocus: true,
          maxLength: 240,
          decoration: InputDecoration(
            labelText: context.l10n.taskDetailsTitleField,
          ),
          onSubmitted: (value) {
            final normalized = value.trim();
            if (normalized.isNotEmpty) {
              Navigator.of(dialogContext).pop(normalized);
            }
          },
        ),
      ),
    );
    titleController.dispose();
    if (!mounted || title == null) return;
    _applyingTemplateId.value = templateId;
    final created = await widget.boardCubit.applyTaskTemplate(
      templateId: templateId,
      title: title,
    );
    if (!mounted) return;
    if (created) Navigator.of(context).pop();
    if (mounted) _applyingTemplateId.value = null;
  }
}
