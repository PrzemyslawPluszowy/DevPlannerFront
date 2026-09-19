import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owner lokalnej walidacji plików composera, bez wywołań UI lub backendu.
final class ChatAttachmentSelectionCubit
    extends Cubit<ChatAttachmentSelectionState> {
  /// Tworzy selekcję z opcjonalnym, neutralnym źródłem zdarzeń platformowych.
  ChatAttachmentSelectionCubit({
    ChatAttachmentSelectionSource? selectionSource,
    this.disposalPort,
    this.limits = const ChatAttachmentLimits(),
  }) : super(ChatAttachmentSelectionReady()) {
    _selectionSubscription = selectionSource?.selections.listen(selectInputs);
  }

  final ChatAttachmentDisposalPort? disposalPort;
  final ChatAttachmentLimits limits;
  StreamSubscription<List<StorageUploadInput>>? _selectionSubscription;
  var _nextLocalId = 0;

  /// Waliduje grupę plików atomowo względem aktualnego lokalnego wyboru.
  void selectInputs(List<StorageUploadInput> inputs) {
    if (isClosed || inputs.isEmpty) return;
    final current = state as ChatAttachmentSelectionReady;
    final accepted = [...current.attachments];
    final rejections = <ChatAttachmentRejection>[];
    var count = _countedAttachments(accepted).length;
    var bytes = _countedAttachments(accepted).fold<int>(
      0,
      (sum, attachment) => sum + attachment.input.size,
    );

    for (final input in inputs) {
      final reason = _rejectionReason(input, count: count, bytes: bytes);
      if (reason != null) {
        rejections.add(ChatAttachmentRejection(input: input, reason: reason));
        continue;
      }
      accepted.add(
        ChatAttachment(
          localId: 'chat-attachment-${++_nextLocalId}',
          input: input,
        ),
      );
      count++;
      bytes += input.size;
    }
    emit(
      ChatAttachmentSelectionReady(
        attachments: accepted,
        rejections: rejections,
      ),
    );
  }

  /// Odłącza lokalny wybór przed asynchroniczną utylizacją jego zasobów.
  void remove(String localId) {
    final current = state as ChatAttachmentSelectionReady;
    final removed = _findAttachment(current.attachments, localId);
    if (removed == null) return;
    emit(
      ChatAttachmentSelectionReady(
        attachments: current.attachments
            .where((attachment) => attachment.localId != localId)
            .toList(),
        rejections: current.rejections,
        disposalFailed: current.disposalFailed,
      ),
    );
    unawaited(_disposeDetached([removed], reportFailure: true));
  }

  /// Zmienia lifecycle wyłącznie według bezpiecznej, monotonicznej maszyny stanów.
  void transitionStatus(String localId, ChatAttachmentStatus nextStatus) {
    final current = state as ChatAttachmentSelectionReady;
    final attachment = _findAttachment(current.attachments, localId);
    if (attachment == null || !_canTransition(attachment.status, nextStatus)) {
      return;
    }
    emit(
      ChatAttachmentSelectionReady(
        attachments: current.attachments
            .map(
              (item) =>
                  item.localId == localId ? item.withStatus(nextStatus) : item,
            )
            .toList(),
      ),
    );
  }

  /// Odłącza lokalne dane najpierw; błąd portu nie może ich wskrzesić.
  Future<void> revokeAndDispose() async {
    final current = state as ChatAttachmentSelectionReady;
    final attachments = current.attachments;
    emit(ChatAttachmentSelectionReady());
    await _disposeDetached(attachments, reportFailure: true);
  }

  List<ChatAttachment> _countedAttachments(List<ChatAttachment> attachments) =>
      attachments
          .where(
            (attachment) =>
                attachment.status != ChatAttachmentStatus.infected &&
                attachment.status != ChatAttachmentStatus.failed,
          )
          .toList();

  ChatAttachment? _findAttachment(
    List<ChatAttachment> attachments,
    String localId,
  ) {
    for (final attachment in attachments) {
      if (attachment.localId == localId) return attachment;
    }
    return null;
  }

  ChatAttachmentRejectionReason? _rejectionReason(
    StorageUploadInput input, {
    required int count,
    required int bytes,
  }) {
    if (count >= limits.maxFiles) {
      return ChatAttachmentRejectionReason.tooManyFiles;
    }
    if (input.size > limits.maxFileSizeBytes) {
      return ChatAttachmentRejectionReason.fileTooLarge;
    }
    if (bytes + input.size > limits.maxMessageSizeBytes) {
      return ChatAttachmentRejectionReason.messageTooLarge;
    }
    return null;
  }

  bool _canTransition(
    ChatAttachmentStatus from,
    ChatAttachmentStatus to,
  ) => switch (from) {
    ChatAttachmentStatus.processing =>
      to == ChatAttachmentStatus.scanning || to == ChatAttachmentStatus.failed,
    ChatAttachmentStatus.scanning =>
      to == ChatAttachmentStatus.clean ||
          to == ChatAttachmentStatus.infected ||
          to == ChatAttachmentStatus.failed,
    ChatAttachmentStatus.clean ||
    ChatAttachmentStatus.infected ||
    ChatAttachmentStatus.failed => false,
  };

  Future<void> _disposeDetached(
    List<ChatAttachment> attachments, {
    required bool reportFailure,
  }) async {
    if (attachments.isEmpty) return;
    try {
      await disposalPort?.dispose(attachments);
    } on Object {
      if (!reportFailure || isClosed) return;
      final current = state as ChatAttachmentSelectionReady;
      emit(
        ChatAttachmentSelectionReady(
          attachments: current.attachments,
          rejections: current.rejections,
          disposalFailed: true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _selectionSubscription?.cancel();
    final attachments = (state as ChatAttachmentSelectionReady).attachments;
    if (attachments.isNotEmpty) {
      emit(ChatAttachmentSelectionReady());
      await _disposeDetached(attachments, reportFailure: false);
    }
    return super.close();
  }
}
