import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_attachments.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class TaskAttachmentsSection extends StatelessWidget {
  const TaskAttachmentsSection({
    required this.taskId,
    required this.isEditable,
    super.key,
  });

  final String taskId;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final detail = context.read<TaskDetailsCubit>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = TaskAttachmentsCubit(
              repository: context.read<TaskAttachmentRepository>(),
              uploadTransport: context.read<TaskAttachmentUploadTransport>(),
              workspaceId: detail.workspaceId,
              projectId: detail.projectId,
              taskId: taskId,
              canEdit: () => switch (detail.state) {
                TaskDetailsReady(:final canEdit) => canEdit,
                _ => false,
              },
              onAccessLost: (error) =>
                  unawaited(detail.reportAccessLost(error)),
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => StorageFileMutationCubit(
            repository: context.read<StorageRepository>(),
            downloadTransport: context.read<DownloadTransport>(),
          ),
        ),
      ],
      child: TaskAttachmentsBody(isEditable: isEditable),
    );
  }
}
