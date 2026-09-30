import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Orkiestruje zapis prywatnej kopii i jej opcjonalne otwarcie w OnlyOffice.
final class ChatAttachmentStorageActions {
  const ChatAttachmentStorageActions._();

  /// Zapisuje załącznik; przy żądaniu otwarcia pobiera świeże prawa pliku.
  static Future<void> save(
    BuildContext context, {
    required ChatMessageAttachment attachment,
    required ChatAttachmentAccessPort port,
    required bool openAfterSave,
  }) async {
    final result = await port.saveToStorage(
      messageId: attachment.messageId,
      storageFileId: attachment.storageFileId,
    );
    if (!context.mounted) return;
    if (!result.succeeded) {
      AppToast.show(
        context,
        message:
            result.failure?.message ?? context.l10n.chatAttachmentSaveFailed,
        tone: AppToastTone.error,
      );
      return;
    }

    if (!openAfterSave) {
      AppToast.show(
        context,
        message: context.l10n.chatAttachmentSavedToStorage,
        tone: AppToastTone.success,
      );
      return;
    }
    if (!result.canEditOnline) {
      _showUnsupported(context);
      return;
    }

    final repository = context.read<StorageRepository?>();
    final fileId = result.storageFileId;
    if (repository == null || fileId == null) {
      AppToast.show(
        context,
        message: context.l10n.chatAttachmentSavedOpenUnavailable,
        tone: AppToastTone.error,
      );
      return;
    }
    final details = await repository.getFileDetails(fileId);
    if (!context.mounted) return;
    await details.fold(
      (error) async => AppToast.show(
        context,
        message: error.message,
        tone: AppToastTone.error,
      ),
      (details) async {
        if (!details.file.canEditOnline) {
          _showUnsupported(context);
          return;
        }
        await StorageOfficeEditorDialog.show(
          context,
          file: details.file,
          repository: repository,
        );
      },
    );
  }

  static void _showUnsupported(BuildContext context) => AppToast.show(
    context,
    message: context.l10n.chatAttachmentSavedOpenUnsupported,
    tone: AppToastTone.warning,
  );
}
