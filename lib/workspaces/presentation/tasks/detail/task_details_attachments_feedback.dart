import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class EmptyAttachments extends StatelessWidget {
  const EmptyAttachments({
    required this.onTap,
    required this.isDragging,
    super.key,
  });

  final VoidCallback? onTap;
  final bool isDragging;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          Icon(
            isDragging
                ? Symbols.file_download_rounded
                : Symbols.attach_file_rounded,
            color: context.tasksTheme.selectionAccent,
          ),
          const SizedBox(height: 8),
          Text(
            isDragging
                ? context.l10n.taskDetailsAttachmentsDrop
                : context.l10n.taskDetailsAttachmentsEmpty,
          ),
          const SizedBox(height: 3),
          Text(
            context.l10n.taskDetailsAttachmentsSelect,
            style: context.tasksTheme.metaText.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

class AttachmentsError extends StatelessWidget {
  const AttachmentsError({required this.message, this.apiError, super.key});

  final String message;
  final ApiError? apiError;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [
        if (apiError case final error?)
          TaskDetailsModalError(error: error)
        else
          Text(message),
        TextButton(
          onPressed: () =>
              unawaited(context.read<TaskAttachmentsCubit>().load()),
          child: Text(context.l10n.retry),
        ),
      ],
    ),
  );
}

class AttachmentsMutationNotice extends StatelessWidget {
  const AttachmentsMutationNotice({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageFileMutationCubit, StorageFileMutationState>(
        builder: (context, state) => switch (state) {
          StorageFileMutationFailure(
            :final message,
            :final statusCode,
            :final backendCode,
            :final apiCode,
            :final traceId,
          ) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message, style: TextStyle(color: context.colors.error)),
                  if (apiCode case final value?)
                    Text('${context.l10n.taskDetailsErrorCode}: $value'),
                  if (backendCode case final value?)
                    Text('${context.l10n.taskDetailsErrorBackendCode}: $value'),
                  if (statusCode case final value?)
                    Text('${context.l10n.taskDetailsErrorHttpStatus}: $value'),
                  if (traceId case final value?)
                    Text('${context.l10n.taskDetailsErrorTraceId}: $value'),
                ],
              ),
            ),
          _ => const SizedBox.shrink(),
        },
      );
}
