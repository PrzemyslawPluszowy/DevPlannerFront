import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan ownera załączników należącego do pojedynczego composera.
sealed class ChatAttachmentComposerCoordinatorState {
  const ChatAttachmentComposerCoordinatorState();
}

/// Nie ma plików, które można bezpiecznie przekazać do draftu.
final class ChatAttachmentComposerCoordinatorIdle
    extends ChatAttachmentComposerCoordinatorState {
  const ChatAttachmentComposerCoordinatorIdle();
}

/// Wybrane pliki są uploadowane lub czekają na `Clean+Ready`.
final class ChatAttachmentComposerCoordinatorPreparing
    extends ChatAttachmentComposerCoordinatorState {
  const ChatAttachmentComposerCoordinatorPreparing();
}

/// Jedyna faza, w której draft otrzymuje UUID załączników.
final class ChatAttachmentComposerCoordinatorReady
    extends ChatAttachmentComposerCoordinatorState {
  ChatAttachmentComposerCoordinatorReady(List<String> attachmentIds)
    : attachmentIds = List.unmodifiable(attachmentIds);

  final List<String> attachmentIds;
}

/// Wysłano snapshot; sesje pozostają aktywne do potwierdzenia tego UUID.
final class ChatAttachmentComposerCoordinatorAwaitingConfirmation
    extends ChatAttachmentComposerCoordinatorState {
  ChatAttachmentComposerCoordinatorAwaitingConfirmation({
    required this.clientMessageId,
    required List<String> attachmentIds,
  }) : attachmentIds = List.unmodifiable(attachmentIds);

  final String clientMessageId;
  final List<String> attachmentIds;
}

/// Kolejka odrzuciła plik i anulowała wszystkie należące do niej sesje.
final class ChatAttachmentComposerCoordinatorFailed
    extends ChatAttachmentComposerCoordinatorState {
  const ChatAttachmentComposerCoordinatorFailed(this.message);

  final String message;
}

/// Koordynuje wybór 7A, przygotowanie 7E-B oraz snapshot draftu.
///
/// Nie zna widgetów, API wysyłki ani ticketów Storage. Wywołujący przekazuje
/// potwierdzenie backendu dopiero po zaakceptowanym create-message; błąd
/// dostawy i retry celowo nie zmieniają snapshotu, dzięki czemu UUID oraz
/// serwerowe sesje pozostają takie same.
final class ChatAttachmentComposerCoordinatorCubit
    extends Cubit<ChatAttachmentComposerCoordinatorState> {
  ChatAttachmentComposerCoordinatorCubit({
    required ChatAttachmentSelectionCubit selection,
    required ChatAttachmentUploadQueueCubit uploadQueue,
    required ChatAttachmentDraftUpdater updateDraftAttachmentIds,
  }) : this._(selection, uploadQueue, updateDraftAttachmentIds);

  ChatAttachmentComposerCoordinatorCubit._(
    this._selection,
    this._uploadQueue,
    this._updateDraftAttachmentIds,
  ) : super(const ChatAttachmentComposerCoordinatorIdle());

  final ChatAttachmentSelectionCubit _selection;
  final ChatAttachmentUploadQueueCubit _uploadQueue;
  final ChatAttachmentDraftUpdater _updateDraftAttachmentIds;
  var _generation = 0;
  var _consumedGeneration = -1;

  /// Aktualny zaakceptowany snapshot 7A, przydatny przyszłemu pickerowi UI.
  ChatAttachmentSelectionReady get selection =>
      _selection.state as ChatAttachmentSelectionReady;

  /// Lokalny owner 7A, udostępniony wyłącznie do renderowania chipów composera.
  ChatAttachmentSelectionCubit get selectionCubit => _selection;

  /// Przekazuje neutralne dane wejściowe do ograniczonej selekcji 7A.
  void selectInputs(List<StorageUploadInput> inputs) {
    if (state is ChatAttachmentComposerCoordinatorAwaitingConfirmation) return;
    _selection.selectInputs(inputs);
  }

  /// Usuwa jeden plik fail-closed: anuluje bieżącą grupę i przygotowuje resztę.
  Future<void> remove(String conversationId, String localId) async {
    if (state is ChatAttachmentComposerCoordinatorAwaitingConfirmation) return;
    await _uploadQueue.revoke();
    _selection.remove(localId);
    await prepare(conversationId);
  }

  /// Uruchamia równoległe przygotowanie aktualnego snapshotu 7A.
  ///
  /// Poprzednia kolejka jest anulowana przez 7E-B. UUID draftu są zerowane
  /// przed rozpoczęciem nowej generacji i wracają wyłącznie po pełnym ready.
  Future<void> prepare(String conversationId) async {
    if (state is ChatAttachmentComposerCoordinatorAwaitingConfirmation) return;
    final generation = ++_generation;
    _consumedGeneration = -1;
    _updateDraftAttachmentIds(const <String>[]);
    emit(const ChatAttachmentComposerCoordinatorPreparing());
    await _uploadQueue.start(conversationId, selection);
    if (isClosed || generation != _generation) return;

    final queueState = _uploadQueue.state;
    if (queueState is ChatAttachmentUploadQueueReady) {
      final ids = queueState.files.map((file) => file.storageFileId).toList();
      _updateDraftAttachmentIds(ids);
      emit(ChatAttachmentComposerCoordinatorReady(ids));
      return;
    }
    _updateDraftAttachmentIds(const <String>[]);
    if (queueState is ChatAttachmentUploadQueueFailed) {
      emit(ChatAttachmentComposerCoordinatorFailed(queueState.message));
    } else {
      emit(const ChatAttachmentComposerCoordinatorIdle());
    }
  }

  /// Wiąże gotową generację z konkretnym optimistic enqueue i jego UUID.
  void registerSubmittedMessage({
    required String clientMessageId,
    required List<String> attachmentIds,
  }) {
    final current = state;
    if (clientMessageId.trim().isEmpty ||
        current is! ChatAttachmentComposerCoordinatorReady ||
        !_sameOrder(current.attachmentIds, attachmentIds)) {
      return;
    }
    emit(
      ChatAttachmentComposerCoordinatorAwaitingConfirmation(
        clientMessageId: clientMessageId,
        attachmentIds: current.attachmentIds,
      ),
    );
  }

  /// Konsumuje sesje dokładnie raz, wyłącznie po zgodnym potwierdzeniu backendu.
  Future<void> markConsumedAfterConfirmedSend({
    required String clientMessageId,
    required List<String> confirmedAttachmentIds,
  }) async {
    final current = state;
    if (current is! ChatAttachmentComposerCoordinatorAwaitingConfirmation ||
        _consumedGeneration == _generation ||
        current.clientMessageId != clientMessageId ||
        !_sameOrder(current.attachmentIds, confirmedAttachmentIds)) {
      return;
    }
    _consumedGeneration = _generation;
    await _uploadQueue.markConsumedAfterConfirmedSend(confirmedAttachmentIds);
    if (isClosed || _generation != _consumedGeneration) return;
    _updateDraftAttachmentIds(const <String>[]);
    emit(const ChatAttachmentComposerCoordinatorIdle());
  }

  /// Błąd dostawy pozostawia ten sam ready snapshot dla kolejnej próby.
  void preserveForSendFailureOrRetry() {}

  /// Unieważnia sesje oraz prywatne UUID po 401/403 lub realtime revoke.
  Future<void> clearForAccessRevoked() => revoke();

  /// Anuluje wszystkie sesje po ręcznym revoke lub zmianie rozmowy.
  Future<void> revoke() async {
    ++_generation;
    _consumedGeneration = -1;
    await _uploadQueue.revoke();
    await _selection.revokeAndDispose();
    _updateDraftAttachmentIds(const <String>[]);
    if (!isClosed) emit(const ChatAttachmentComposerCoordinatorIdle());
  }

  bool _sameOrder(List<String> expected, List<String> actual) {
    if (expected.length != actual.length) return false;
    for (var index = 0; index < expected.length; index++) {
      if (expected[index] != actual[index]) return false;
    }
    return true;
  }

  @override
  Future<void> close() async {
    ++_generation;
    _updateDraftAttachmentIds(const <String>[]);
    await _uploadQueue.close();
    await _selection.close();
    return super.close();
  }
}
