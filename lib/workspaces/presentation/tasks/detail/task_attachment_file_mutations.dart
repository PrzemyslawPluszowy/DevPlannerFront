import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_preview_launcher.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

abstract final class TaskAttachmentFileMutations {
  static Future<void> mutate(
    BuildContext context,
    StorageFileMutationCubit mutation,
    TaskAttachmentsCubit attachments,
    Future<void> Function() operation,
  ) async {
    await operation();
    if (!context.mounted) return;
    if (mutation.state is StorageFileMutationSuccess) {
      await attachments.load();
    }
  }

  static Future<void> confirmAndMutate(
    BuildContext context,
    StorageFileResponse file,
    TaskAttachmentsCubit attachments,
    StorageFileMutationCubit mutation, {
    required String title,
    required String message,
    required String confirmLabel,
    required Future<void> Function() action,
  }) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: context.l10n.cancel,
      tone: file.isDeleted
          ? AppConfirmDialogTone.info
          : AppConfirmDialogTone.danger,
    );
    if (!confirmed || !context.mounted) return;
    await mutate(context, mutation, attachments, action);
  }

  static Future<void> preview(
    BuildContext context,
    StorageFileResponse file,
  ) => TaskAttachmentPreviewLauncher.open(context, file);

  static Future<void> openOffice(
    BuildContext context,
    StorageFileResponse file,
  ) async {
    if (!file.canEditOnline || !context.mounted) return;
    final repository = context.read<StorageRepository>();
    final attachments = context.read<TaskAttachmentsCubit>();
    await StorageOfficeEditorDialog.show(
      context,
      file: file,
      repository: repository,
    );
    if (context.mounted) await attachments.load();
  }

  static Future<void> convertToPdf(
    BuildContext context,
    StorageFileResponse file,
    StorageRepository repository,
    TaskAttachmentsCubit attachments,
  ) => DevPlannerModalHost.showDialog<void>(
    context,
    builder: (_) => TaskAttachmentPdfConversionDialog(
      file: file,
      repository: repository,
      onConverted: attachments.load,
    ),
  );
}

final class TaskAttachmentPdfConversionDialog extends StatefulWidget {
  const TaskAttachmentPdfConversionDialog({
    required this.file,
    required this.repository,
    required this.onConverted,
    super.key,
  });

  final StorageFileResponse file;
  final StorageRepository repository;
  final Future<void> Function() onConverted;

  @override
  State<TaskAttachmentPdfConversionDialog> createState() =>
      _TaskAttachmentPdfConversionDialogState();
}

final class _TaskAttachmentPdfConversionDialogState
    extends State<TaskAttachmentPdfConversionDialog> {
  ApiError? _error;
  bool _isConverting = false;

  Future<void> _convert() async {
    if (_isConverting) return;
    setState(() {
      _isConverting = true;
      _error = null;
    });
    final result = await widget.repository.convertToPdf(widget.file.id);
    if (!mounted) return;
    final error = result.fold<ApiError?>((value) => value, (_) => null);
    if (error != null) {
      setState(() {
        _isConverting = false;
        _error = error;
      });
      return;
    }
    await widget.onConverted();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Dialog(
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.storageConvertToPdfAction,
                style: tasks.dataStrongText,
              ),
              const SizedBox(height: 10),
              Text(widget.file.originalFileName, style: tasks.dataText),
              if (_error case final error?) ...[
                const SizedBox(height: 12),
                TaskDetailsModalError(error: error),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isConverting
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _isConverting ? null : _convert,
                    child: _isConverting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(context.l10n.storageConvertToPdfAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
