part of 'task_details_page.dart';

Future<void> _showCreateTaskTemplateDialog(
  BuildContext context, {
  required String initialName,
}) {
  final detailsCubit = context.read<TaskDetailsCubit>();
  final repository = context.read<TaskTemplateRepository>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => TaskTemplateCubit(
        repository: repository,
        workspaceId: detailsCubit.workspaceId,
        taskId: detailsCubit.taskId,
      ),
      child: _CreateTaskTemplateDialog(initialName: initialName),
    ),
  );
}

class _CreateTaskTemplateDialog extends StatefulWidget {
  const _CreateTaskTemplateDialog({required this.initialName});

  final String initialName;

  @override
  State<_CreateTaskTemplateDialog> createState() =>
      _CreateTaskTemplateDialogState();
}

class _CreateTaskTemplateDialogState extends State<_CreateTaskTemplateDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<TaskTemplateCubit, TaskTemplateState>(
        listener: (context, state) {
          if (state is TaskTemplateSaved) {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();
            messenger.showSnackBar(
              SnackBar(content: Text(context.l10n.taskDetailsTemplateCreated)),
            );
          }
        },
        builder: (context, state) {
          final saving = state is TaskTemplateSaving;
          final l10n = context.l10n;
          final colors = context.colors;

          return WorkspaceCreationModalWrapper(
            title: l10n.taskDetailsCreateTemplateTitle,
            subtitle: l10n.taskDetailsCreateTemplateDescription,
            icon: Symbols.auto_awesome_mosaic,
            accentColor: colors.primary,
            isSubmitting: saving,
            submitLabel: l10n.create,
            cancelLabel: l10n.cancel,
            maxWidth: 460,
            onSubmit: () => unawaited(
              context.read<TaskTemplateCubit>().createFromTask(
                _nameController.text.trim(),
              ),
            ),
            body: Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.taskDetailsTemplateName,
                  style: context.text.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Gaps.h8,
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  maxLength: 120,
                  enabled: !saving,
                  decoration: InputDecoration(
                    hintText: l10n.taskDetailsTemplateName,
                    errorText: switch (state) {
                      TaskTemplateFailure(:final message) => message,
                      _ => null,
                    },
                    border: const OutlineInputBorder(
                      borderRadius: .all(.circular(10)),
                    ),
                    contentPadding: const .symmetric(
                      horizontal: Sizes.p12,
                      vertical: Sizes.p12,
                    ),
                  ),
                  onSubmitted: saving
                      ? null
                      : (value) => unawaited(
                          context.read<TaskTemplateCubit>().createFromTask(
                            value.trim(),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      );
}
