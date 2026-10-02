import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/templates/task_template_copy_preview.dart';

/// Składa modal utworzenia template z aktualnym zadaniem i jego Cubitem.
///
/// Dialog nie wykonuje zapisu bezpośrednio — deleguje go do `TaskTemplateCubit`.
final class TaskTemplateDialogLauncher {
  const TaskTemplateDialogLauncher._();

  static Future<void> show(
    BuildContext context, {
    required String initialName,
  }) {
    final detailsCubit = context.read<TaskDetailsCubit>();
    final repository = context.read<TaskTemplateRepository>();
    final preview = switch (detailsCubit.state) {
      TaskDetailsReady(:final details) =>
        TaskTemplateCopyPreviewData.fromDetails(details),
      _ => null,
    };
    return DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider(
        create: (_) => TaskTemplateCubit(
          repository: repository,
          workspaceId: detailsCubit.workspaceId,
          projectId: detailsCubit.projectId,
          taskId: detailsCubit.taskId,
          canEdit: () =>
              !detailsCubit.isClosed &&
              switch (detailsCubit.state) {
                TaskDetailsReady(:final canEdit) => canEdit,
                _ => false,
              },
          onAccessLost: (error) =>
              unawaited(detailsCubit.reportAccessLost(error)),
        ),
        child: CreateTaskTemplateDialog(
          initialName: initialName,
          copyPreview: preview,
        ),
      ),
    );
  }
}

class CreateTaskTemplateDialog extends StatefulWidget {
  const CreateTaskTemplateDialog({
    required this.initialName,
    this.copyPreview,
    super.key,
  });

  final String initialName;
  final TaskTemplateCopyPreviewData? copyPreview;

  @override
  State<CreateTaskTemplateDialog> createState() =>
      CreateTaskTemplateDialogState();
}

class CreateTaskTemplateDialogState extends State<CreateTaskTemplateDialog> {
  TaskDetailDraftRegistration? _draft;
  late final TextEditingController _nameController;
  final ValueNotifier<bool> _nameRequired = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _nameController.addListener(_refreshDraft);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsCreateTemplateTitle,
    );
  }

  void _refreshDraft() {
    if (_nameRequired.value && _nameController.text.trim().isNotEmpty) {
      _nameRequired.value = false;
    }
    if (_nameController.text == widget.initialName) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _nameController.removeListener(_refreshDraft);
    _nameController.dispose();
    _nameRequired.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      _nameRequired.value = true;
      return;
    }
    unawaited(
      context.read<TaskTemplateCubit>().createFromTask(_nameController.text),
    );
  }

  void _submitted(String _) => _submit();

  void _onTemplateState(BuildContext context, TaskTemplateState state) {
    if (state is! TaskTemplateSaved ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _draft?.clear();
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.taskDetailsTemplateCreated;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<TaskTemplateCubit, TaskTemplateState>(
    listener: _onTemplateState,
    builder: (context, state) {
      final saving = state is TaskTemplateSaving;
      final l10n = context.l10n;
      final colors = context.colors;
      final tasks = context.tasksTheme;

      return WorkspaceCreationModalWrapper(
        title: l10n.taskDetailsCreateTemplateTitle,
        subtitle: l10n.taskDetailsCreateTemplateDescription,
        icon: Symbols.auto_awesome_mosaic,
        accentColor: tasks.selectionAccent,
        isSubmitting: saving,
        submitLabel: l10n.create,
        cancelLabel: l10n.cancel,
        maxWidth: 560,
        onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
          context,
          _draft,
        ),
        onSubmit: context.read<TaskTemplateCubit>().canSubmit ? _submit : null,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state case TaskTemplateFailure(apiError: final error?))
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: SingleChildScrollView(
                  child: TaskDetailsModalError(
                    error: error,
                    fallbackMessage: l10n.tasksTemplateSaveFailed,
                  ),
                ),
              ),
            Text(
              l10n.taskDetailsTemplateName,
              style: tasks.controlText.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            ValueListenableBuilder<bool>(
              valueListenable: _nameRequired,
              builder: (context, required, _) => TextField(
                key: const ValueKey('task_template_name'),
                controller: _nameController,
                autofocus: true,
                maxLength: 160,
                enabled: !saving,
                style: tasks.dataText.copyWith(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: l10n.taskDetailsTemplateName,
                  filled: true,
                  fillColor: tasks.canvas,
                  errorMaxLines: 3,
                  errorText: required
                      ? l10n.authFieldRequired
                      : switch (state) {
                          TaskTemplateFailure(:final apiError) =>
                            apiError?.fields['name']?.join(' · '),
                          _ => null,
                        },
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                    borderSide: BorderSide(color: tasks.canvasBorder),
                  ),
                  contentPadding: const .symmetric(
                    horizontal: Sizes.p12,
                    vertical: Sizes.p12,
                  ),
                ),
                onSubmitted: context.read<TaskTemplateCubit>().canSubmit
                    ? _submitted
                    : null,
              ),
            ),
            Gaps.h16,
            TaskTemplateCopyPreview(data: widget.copyPreview),
          ],
        ),
      );
    },
  );
}
