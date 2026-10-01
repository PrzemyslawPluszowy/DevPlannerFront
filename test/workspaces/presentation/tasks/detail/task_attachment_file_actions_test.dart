import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachment_file_actions.dart';
import 'package:flutter_test/flutter_test.dart';

StorageFileResponse _file({
  bool canPreview = false,
  bool canDownload = false,
  bool canManageVersions = false,
  bool canEditOnline = false,
  bool canEdit = false,
  bool canConvertToPdf = false,
  bool canShare = false,
  bool canRead = false,
  bool canDismissFromShared = false,
  bool canRestore = false,
  bool canDelete = false,
  bool isDeleted = false,
}) => StorageFileResponse(
  id: 'file-1',
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.task,
  originalFileName: 'brief.txt',
  extension: 'txt',
  mimeType: 'text/plain',
  fileSizeBytes: 1,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  isDeleted: isDeleted,
  processingStatus: StorageProcessingStatus.ready,
  scanStatus: StorageScanStatus.clean,
  aiStatus: StorageAiStatus.none,
  canPreview: canPreview,
  canDownload: canDownload,
  canManageVersions: canManageVersions,
  canEditOnline: canEditOnline,
  canEdit: canEdit,
  canConvertToPdf: canConvertToPdf,
  canShare: canShare,
  canRead: canRead,
  canDismissFromShared: canDismissFromShared,
  canRestore: canRestore,
  canDelete: canDelete,
);

void main() {
  test('hides every file action when the API grants no capability', () {
    expect(TaskAttachmentFileActions.availableActions(_file()), isEmpty);
  });

  test('exposes only actions granted by the file capabilities', () {
    expect(
      TaskAttachmentFileActions.availableActions(
        _file(canPreview: true, canDownload: true),
      ),
      [
        TaskAttachmentFileAction.preview,
        TaskAttachmentFileAction.download,
      ],
    );
    expect(
      TaskAttachmentFileActions.availableActions(
        _file(canManageVersions: true, canEditOnline: true),
      ),
      [
        TaskAttachmentFileAction.office,
        TaskAttachmentFileAction.versions,
      ],
    );
  });

  test('maps every supported Storage capability to its file action', () {
    expect(
      TaskAttachmentFileActions.availableActions(
        _file(
          canPreview: true,
          canDownload: true,
          canManageVersions: true,
          canEditOnline: true,
          canEdit: true,
          canConvertToPdf: true,
          canShare: true,
          canRead: true,
          canDismissFromShared: true,
          canDelete: true,
        ),
      ),
      [
        TaskAttachmentFileAction.preview,
        TaskAttachmentFileAction.rename,
        TaskAttachmentFileAction.description,
        TaskAttachmentFileAction.office,
        TaskAttachmentFileAction.convertToPdf,
        TaskAttachmentFileAction.share,
        TaskAttachmentFileAction.favorite,
        TaskAttachmentFileAction.dismiss,
        TaskAttachmentFileAction.download,
        TaskAttachmentFileAction.versions,
        TaskAttachmentFileAction.delete,
      ],
    );
    expect(
      TaskAttachmentFileActions.availableActions(
        _file(isDeleted: true, canRestore: true, canDelete: true),
      ),
      [TaskAttachmentFileAction.restore],
    );
  });

  test('more-menu visibility covers every action-only capability', () {
    final actionOnlyFiles = [
      _file(canEdit: true),
      _file(canConvertToPdf: true),
      _file(canShare: true),
      _file(canRead: true),
      _file(canDismissFromShared: true),
      _file(canDelete: true),
      _file(isDeleted: true, canRestore: true),
    ];

    expect(
      actionOnlyFiles.every(TaskAttachmentFileCapabilities.hasAnyAction),
      isTrue,
    );
  });
}
