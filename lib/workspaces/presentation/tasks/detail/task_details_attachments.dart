part of 'task_details_page.dart';

class _TaskAttachmentsSection extends StatelessWidget {
  const _TaskAttachmentsSection({required this.taskId});
  final String taskId;

  @override
  Widget build(BuildContext context) {
    final detail = context.read<TaskDetailsCubit>();
    return BlocProvider(
      create: (context) {
        final cubit = TaskAttachmentsCubit(
          repository: context.read<TaskAttachmentRepository>(),
          uploadTransport: context.read<TaskAttachmentUploadTransport>(),
          workspaceId: detail.workspaceId,
          projectId: detail.projectId,
          taskId: taskId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _TaskAttachmentsBody(),
    );
  }
}

class _TaskAttachmentsBody extends StatefulWidget {
  const _TaskAttachmentsBody();
  @override
  State<_TaskAttachmentsBody> createState() => _TaskAttachmentsBodyState();
}

class _TaskAttachmentsBodyState extends State<_TaskAttachmentsBody> {
  var _isDragging = false;

  @override
  Widget build(BuildContext context) => DropTarget(
    onDragEntered: (_) => setState(() => _isDragging = true),
    onDragExited: (_) => setState(() => _isDragging = false),
    onDragDone: (details) async {
      setState(() => _isDragging = false);
      await _uploadFiles(details.files);
    },
    child: _Section(
      title: context.l10n.taskDetailsAttachments,
      action: TextButton.icon(
        onPressed: _pickFiles,
        icon: const Icon(Symbols.upload_file_rounded, size: 18),
        label: Text(context.l10n.taskDetailsAttachmentsAdd),
      ),
      child: BlocBuilder<TaskAttachmentsCubit, TaskAttachmentsState>(
        builder: (context, state) => switch (state) {
          TaskAttachmentsLoading() => const Padding(
            padding: EdgeInsets.all(18),
            child: Center(child: CircularProgressIndicator()),
          ),
          TaskAttachmentsFailure(:final message) => _AttachmentsError(
            message: message,
          ),
          TaskAttachmentsReady() => _AttachmentsReady(
            state: state,
            onPickFiles: _pickFiles,
            isDragging: _isDragging,
          ),
        },
      ),
    ),
  );

  Future<void> _pickFiles() async {
    final files = await openFiles();
    if (!mounted || files.isEmpty) return;
    await _uploadFiles(files);
  }

  Future<void> _uploadFiles(List<XFile> files) async {
    final inputs = await Future.wait(
      files.map(
        (file) async => TaskAttachmentUploadInput(
          name: file.name,
          bytes: await file.readAsBytes(),
        ),
      ),
    );
    if (mounted) await context.read<TaskAttachmentsCubit>().upload(inputs);
  }
}

class _AttachmentsReady extends StatelessWidget {
  const _AttachmentsReady({
    required this.state,
    required this.onPickFiles,
    required this.isDragging,
  });
  final TaskAttachmentsReady state;
  final VoidCallback onPickFiles;
  final bool isDragging;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: isDragging
          ? context.colors.primaryContainer
          : context.colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDragging
            ? context.colors.primary
            : context.colors.outlineVariant,
        width: isDragging ? 2 : 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.error != null) ...[
            Text(state.error!, style: TextStyle(color: context.colors.error)),
            const SizedBox(height: 10),
          ],
          if (state.files.isEmpty && state.uploads.isEmpty)
            _EmptyAttachments(onTap: onPickFiles, isDragging: isDragging),
          for (final file in state.files)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Symbols.insert_drive_file),
              title: Text(
                file.originalFileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(_fileSize(file.fileSizeBytes)),
              trailing: const Icon(Symbols.visibility_rounded, size: 18),
              onTap: () => _openPreview(context, file),
            ),
          for (final upload in state.uploads)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(_uploadIcon(upload.status)),
              title: Text(
                upload.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: upload.error == null
                  ? Text(_uploadLabel(context, upload.status))
                  : Text(
                      upload.error!,
                      style: TextStyle(color: context.colors.error),
                    ),
            ),
          if (state.isUploading) ...[
            const SizedBox(height: 10),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    ),
  );

  void _openPreview(BuildContext context, StorageFileResponse file) {
    final previewCubit = StoragePreviewCubit(
      repository: context.read<StorageRepository>(),
      authRepository: context.read<AuthRepository>(),
    );
    final mutationCubit = StorageFileMutationCubit(
      repository: context.read<StorageRepository>(),
      downloadTransport: const DownloadTransportImpl(),
    );
    unawaited(previewCubit.preparePreview(file));
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: previewCubit),
            BlocProvider.value(value: mutationCubit),
          ],
          child: StoragePreviewDialog(file: file),
        ),
      ).whenComplete(() {
        unawaited(previewCubit.close());
        unawaited(mutationCubit.close());
      }),
    );
  }
}

class _EmptyAttachments extends StatelessWidget {
  const _EmptyAttachments({required this.onTap, required this.isDragging});
  final VoidCallback onTap;
  final bool isDragging;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          Icon(
            isDragging
                ? Symbols.file_download_rounded
                : Symbols.attach_file_rounded,
            color: context.colors.primary,
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
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

class _AttachmentsError extends StatelessWidget {
  const _AttachmentsError({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [
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

IconData _uploadIcon(TaskAttachmentUploadStatus status) => switch (status) {
  TaskAttachmentUploadStatus.queued => Symbols.schedule_rounded,
  TaskAttachmentUploadStatus.uploading => Symbols.upload_rounded,
  TaskAttachmentUploadStatus.uploaded => Symbols.check_circle_outline_rounded,
  TaskAttachmentUploadStatus.failed => Symbols.error_outline_rounded,
};
String _uploadLabel(BuildContext context, TaskAttachmentUploadStatus status) =>
    switch (status) {
      TaskAttachmentUploadStatus.queued =>
        context.l10n.taskDetailsAttachmentsQueued,
      TaskAttachmentUploadStatus.uploading =>
        context.l10n.taskDetailsAttachmentsUploading,
      TaskAttachmentUploadStatus.uploaded =>
        context.l10n.taskDetailsAttachmentsUploaded,
      TaskAttachmentUploadStatus.failed =>
        context.l10n.taskDetailsAttachmentsFailed,
    };
String _fileSize(int bytes) => bytes < 1024
    ? '$bytes B'
    : bytes < 1024 * 1024
    ? '${(bytes / 1024).toStringAsFixed(1)} KB'
    : '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
