import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Niezależny od UI stan całej kolejki załączników jednego composera.
sealed class ChatAttachmentUploadQueueState {
  const ChatAttachmentUploadQueueState();
}

/// Nie istnieje aktywna kolejka ani gotowe identyfikatory do publikacji.
final class ChatAttachmentUploadQueueIdle
    extends ChatAttachmentUploadQueueState {
  const ChatAttachmentUploadQueueIdle();
}

/// Przygotowanie przynajmniej jednego zaakceptowanego pliku jeszcze trwa.
final class ChatAttachmentUploadQueueWorking
    extends ChatAttachmentUploadQueueState {
  const ChatAttachmentUploadQueueWorking(this.fileCount);

  final int fileCount;
}

/// Wszystkie pliki są `Clean+Ready`, w tej samej kolejności co wybór 7A.
final class ChatAttachmentUploadQueueReady
    extends ChatAttachmentUploadQueueState {
  ChatAttachmentUploadQueueReady(List<ChatAttachmentPreparedFile> files)
    : files = List.unmodifiable(files);

  /// Jedyne UUID dostępne dla przyszłego send; nie ma tu ticketów ani URL-i.
  final List<ChatAttachmentPreparedFile> files;
}

/// Błąd jednego pliku; cała sesja composera została fail-closed anulowana.
final class ChatAttachmentUploadQueueFailed
    extends ChatAttachmentUploadQueueState {
  const ChatAttachmentUploadQueueFailed(this.message);

  final String message;
}

/// Fabryka ownerów pojedynczych plików; umożliwia testy bez API i widgetów.
typedef ChatAttachmentUploadOwnerFactory = ChatAttachmentUploadOwner Function();

/// Agreguje per-file ownerów 7D w jedną atomową kolejkę composera.
///
/// Przyjmuje wyłącznie elementy już zaakceptowane przez `ChatAttachmentSelectionCubit`
/// (7A). Jeżeli którykolwiek plik nie osiągnie `Clean+Ready`, unieważnia sesje
/// wszystkich pozostałych plików. Gotowe UUID są publikowane dopiero jako pełna,
/// uporządkowana lista.
final class ChatAttachmentUploadQueueCubit
    extends Cubit<ChatAttachmentUploadQueueState> {
  ChatAttachmentUploadQueueCubit(this._ownerFactory)
    : super(const ChatAttachmentUploadQueueIdle());

  /// Wygodna kompozycja z zaakceptowanym adapterem Storage/Chat 7D.
  factory ChatAttachmentUploadQueueCubit.fromUploadPort(
    ChatAttachmentUploadPort port, {
    int maxPolls = 20,
    Duration pollDelay = const Duration(milliseconds: 100),
  }) => ChatAttachmentUploadQueueCubit(
    () => ChatAttachmentUploadCubit(
      port,
      maxPolls: maxPolls,
      pollDelay: pollDelay,
    ),
  );

  final ChatAttachmentUploadOwnerFactory _ownerFactory;
  final List<ChatAttachmentUploadOwner> _owners = [];
  var _generation = 0;

  /// Przygotowuje wyłącznie zaakceptowane przez 7A pliki równolegle.
  Future<void> start(
    String conversationId,
    ChatAttachmentSelectionReady selection,
  ) async {
    final acceptedAttachments = selection.attachments;
    final generation = ++_generation;
    await _revokeOwners(_owners);
    _owners.clear();
    if (generation != _generation || isClosed) return;
    if (acceptedAttachments.isEmpty) {
      emit(const ChatAttachmentUploadQueueIdle());
      return;
    }

    final owners = List<ChatAttachmentUploadOwner>.generate(
      acceptedAttachments.length,
      (_) => _ownerFactory(),
    );
    _owners.addAll(owners);
    emit(ChatAttachmentUploadQueueWorking(owners.length));

    var failed = false;
    Future<void> failClosed() async {
      if (failed) return;
      failed = true;
      await _revokeOwners(owners);
    }

    await Future.wait(
      List<Future<void>>.generate(owners.length, (index) async {
        try {
          await owners[index].start(
            conversationId,
            acceptedAttachments[index].input,
          );
          if (generation == _generation && owners[index].preparedFile == null) {
            await failClosed();
          }
        } on Object {
          if (generation == _generation) await failClosed();
        }
      }),
    );

    if (generation != _generation || isClosed) return;
    final files = owners.map((owner) => owner.preparedFile).toList();
    if (failed || files.any((file) => file == null)) {
      _owners.clear();
      if (!isClosed) {
        emit(
          const ChatAttachmentUploadQueueFailed(
            'Co najmniej jeden załącznik nie przeszedł kontroli bezpieczeństwa.',
          ),
        );
      }
      return;
    }
    emit(
      ChatAttachmentUploadQueueReady(files.cast<ChatAttachmentPreparedFile>()),
    );
  }

  /// Unieważnia każdą aktywną sesję po revoke composera lub zmianie rozmowy.
  Future<void> revoke() async {
    ++_generation;
    await _revokeOwners(_owners);
    _owners.clear();
    if (!isClosed) emit(const ChatAttachmentUploadQueueIdle());
  }

  /// Zwalnia sesje tylko po potwierdzonym przez backend zapisie wiadomości.
  ///
  /// Pełna, uporządkowana lista UUID musi odpowiadać aktualnemu ready snapshotowi;
  /// częściowy albo ponowiony callback jest ignorowany fail-closed.
  Future<void> markConsumedAfterConfirmedSend(
    List<String> confirmedFileIds,
  ) async {
    final current = state;
    if (current is! ChatAttachmentUploadQueueReady) return;
    final expected = current.files.map((file) => file.storageFileId).toList();
    if (!_sameOrder(expected, confirmedFileIds)) return;
    for (final file in current.files) {
      final owner = _ownerForSession(file.sessionId);
      owner?.markConsumed(file.sessionId);
    }
    await Future.wait(_owners.map((owner) => owner.close()));
    _owners.clear();
  }

  ChatAttachmentUploadOwner? _ownerForSession(String sessionId) {
    for (final owner in _owners) {
      if (owner.preparedFile?.sessionId == sessionId) return owner;
    }
    return null;
  }

  Future<void> _revokeOwners(List<ChatAttachmentUploadOwner> owners) async {
    if (owners.isEmpty) return;
    await Future.wait(
      owners.map((owner) async {
        await owner.revoke();
        await owner.close();
      }),
    );
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
    await _revokeOwners(_owners);
    _owners.clear();
    return super.close();
  }
}
