import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';

enum TaskAttachmentFileAction {
  preview,
  rename,
  description,
  office,
  convertToPdf,
  share,
  favorite,
  dismiss,
  download,
  versions,
  restore,
  delete,
}

abstract final class TaskAttachmentFileCapabilities {
  static bool hasAnyAction(StorageFileResponse file) =>
      actions(file).isNotEmpty;

  static List<TaskAttachmentFileAction> actions(StorageFileResponse file) => [
    if (!file.isDeleted && file.canPreview) TaskAttachmentFileAction.preview,
    if (!file.isDeleted && file.canEdit) TaskAttachmentFileAction.rename,
    if (!file.isDeleted && file.canEdit) TaskAttachmentFileAction.description,
    if (!file.isDeleted && file.canEditOnline) TaskAttachmentFileAction.office,
    if (!file.isDeleted && file.canConvertToPdf)
      TaskAttachmentFileAction.convertToPdf,
    if (!file.isDeleted && file.canShare) TaskAttachmentFileAction.share,
    if (!file.isDeleted && file.canRead) TaskAttachmentFileAction.favorite,
    if (file.canDismissFromShared) TaskAttachmentFileAction.dismiss,
    if (!file.isDeleted && file.canDownload) TaskAttachmentFileAction.download,
    if (!file.isDeleted && file.canManageVersions)
      TaskAttachmentFileAction.versions,
    if (file.isDeleted && file.canRestore) TaskAttachmentFileAction.restore,
    if (!file.isDeleted && file.canDelete) TaskAttachmentFileAction.delete,
  ];
}
