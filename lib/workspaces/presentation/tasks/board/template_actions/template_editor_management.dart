part of '../tasks_board_page.dart';

final class _TemplateManagementDialogs {
  const _TemplateManagementDialogs._();

  static Future<void> renameTemplate(
    BuildContext context,
    TaskTemplateResponse template, {
    TaskTemplatePickerCubit? pickerCubit,
  }) async {
    final controller = TextEditingController(text: template.name);
    final cubit = pickerCubit ?? context.read<TaskTemplatePickerCubit>();
    final l10n = context.l10n;
    final colors = context.colors;

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => WorkspaceCreationModalWrapper(
        title: l10n.tasksTemplatesRename,
        subtitle: l10n.taskDetailsTemplateName,
        icon: Symbols.edit_rounded,
        accentColor: colors.primary,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 420,
        onSubmit: () => Navigator.of(dialogContext).pop(controller.text.trim()),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              maxLength: 120,
              decoration: InputDecoration(
                hintText: l10n.taskDetailsTemplateName,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) =>
                  Navigator.of(dialogContext).pop(value.trim()),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty || name.trim() == template.name) {
      return;
    }

    await cubit.rename(templateId: template.id, name: name.trim());
  }

  static Future<void> confirmDeleteTemplate(
    BuildContext context,
    TaskTemplateResponse template, {
    TaskTemplatePickerCubit? pickerCubit,
  }) async {
    final cubit = pickerCubit ?? context.read<TaskTemplatePickerCubit>();
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.tasksTemplatesDeleteTitle,
      message: context.l10n.tasksTemplatesDeleteDescription(template.name),
      confirmLabel: context.l10n.delete,
      cancelLabel: context.l10n.cancel,
      tone: AppConfirmDialogTone.danger,
    );
    if (confirmed) {
      await cubit.delete(template.id);
    }
  }
}
