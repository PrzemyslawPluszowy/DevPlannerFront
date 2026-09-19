import 'package:devplanner/workspaces/domain/chat/attachments/models/chat_attachment_prepared_file.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/ports/chat_attachment_upload_owner.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan pojedynczego uploadu Chat; identyfikator pliku jest ujawniany wyłącznie po Clean+Ready.
sealed class ChatAttachmentUploadState {
  const ChatAttachmentUploadState();
}

/// Brak aktywnego uploadu.
final class ChatAttachmentUploadIdle extends ChatAttachmentUploadState {
  const ChatAttachmentUploadIdle();
}

/// Upload lub polling bezpieczeństwa jest w toku.
final class ChatAttachmentUploadWorking extends ChatAttachmentUploadState {
  const ChatAttachmentUploadWorking(this.stage);
  final String stage;
}

/// Gotowy, stabilny UUID Storage w kolejności nadanej przez ownera kolejki.
final class ChatAttachmentUploadReady extends ChatAttachmentUploadState {
  const ChatAttachmentUploadReady(this.storageFileId, this.sessionId);
  final String storageFileId;

  /// Sesja pozostaje aktywna aż composer potwierdzi zapis wiadomości.
  final String sessionId;
}

/// Błąd terminalny; sesja została anulowana zanim stan został wyemitowany.
final class ChatAttachmentUploadFailed extends ChatAttachmentUploadState {
  const ChatAttachmentUploadFailed(this.message);
  final String message;
}

/// Port 7C/Storage ukrywający kontrakt HTTP i presigned URL przed presentation.
abstract interface class ChatAttachmentUploadPort {
  Future<ChatAttachmentUploadSession> createSession(String conversationId);
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  });
  Future<void> upload(ChatAttachmentTicket ticket, StorageUploadInput input);
  Future<void> complete(String storageFileId);
  Future<ChatAttachmentRemoteStatus> status(String storageFileId);
  Future<void> cancelSession(String conversationId, String sessionId);
}

/// Serwerowa sesja tymczasowa 7B.
final class ChatAttachmentUploadSession {
  const ChatAttachmentUploadSession(this.id);
  final String id;
}

/// Ticket Storage dla pojedynczego pliku.
final class ChatAttachmentTicket {
  const ChatAttachmentTicket(this.storageFileId);
  final String storageFileId;
}

/// Bezpieczny snapshot skanowania/processing Storage.
enum ChatAttachmentRemoteStatus {
  pending,
  processing,
  cleanReady,
  infected,
  failed,
}

/// Owner fail-closed lifecycle jednego wybranego pliku; composer nie zna API ani sesji.
final class ChatAttachmentUploadCubit extends Cubit<ChatAttachmentUploadState>
    implements ChatAttachmentUploadOwner {
  ChatAttachmentUploadCubit(
    this._port, {
    this.maxPolls = 20,
    this.pollDelay = const Duration(milliseconds: 100),
  }) : super(const ChatAttachmentUploadIdle());
  final ChatAttachmentUploadPort _port;
  final int maxPolls;
  final Duration pollDelay;
  String? _conversationId;
  String? _sessionId;
  var _generation = 0;

  @override
  ChatAttachmentPreparedFile? get preparedFile => switch (state) {
    ChatAttachmentUploadReady(:final storageFileId, :final sessionId) =>
      ChatAttachmentPreparedFile(
        storageFileId: storageFileId,
        sessionId: sessionId,
      ),
    _ => null,
  };

  @override
  Future<void> start(String conversationId, StorageUploadInput input) async {
    await cancel();
    final generation = ++_generation;
    _conversationId = conversationId;
    try {
      emit(const ChatAttachmentUploadWorking('session'));
      final session = await _port.createSession(conversationId);
      if (generation != _generation) {
        await _port.cancelSession(conversationId, session.id);
        return;
      }
      _sessionId = session.id;
      emit(const ChatAttachmentUploadWorking('upload'));
      final ticket = await _port.createTicket(
        sessionId: session.id,
        input: input,
      );
      await _port.upload(ticket, input);
      await _port.complete(ticket.storageFileId);
      for (var attempt = 0; attempt < maxPolls; attempt++) {
        if (generation != _generation) return;
        final status = await _port.status(ticket.storageFileId);
        if (generation != _generation) return;
        if (status == ChatAttachmentRemoteStatus.cleanReady) {
          emit(ChatAttachmentUploadReady(ticket.storageFileId, session.id));
          return;
        }
        if (status == ChatAttachmentRemoteStatus.infected ||
            status == ChatAttachmentRemoteStatus.failed) {
          throw StateError('Plik nie przeszedł kontroli bezpieczeństwa.');
        }
        emit(const ChatAttachmentUploadWorking('scan'));
        await Future<void>.delayed(pollDelay * (attempt + 1));
      }
      throw StateError('Przekroczono czas oczekiwania na skanowanie pliku.');
    } catch (error) {
      if (generation != _generation) return;
      await _cancelSilently();
      if (!isClosed) emit(ChatAttachmentUploadFailed('$error'));
    }
  }

  Future<void> cancel() async {
    ++_generation;
    await _cancelSilently();
    if (!isClosed) emit(const ChatAttachmentUploadIdle());
  }

  @override
  Future<void> revoke() => cancel();

  /// Wywoływane dopiero po potwierdzonym zapisie wiadomości przez backend.
  @override
  void markConsumed(String sessionId) {
    if (_sessionId == sessionId) _sessionId = null;
  }

  Future<void> _cancelSilently() async {
    final session = _sessionId;
    final conversation = _conversationId;
    _sessionId = null;
    if (session != null && conversation != null) {
      try {
        await _port.cancelSession(conversation, session);
      } catch (_) {}
    }
  }

  @override
  Future<void> close() async {
    await _cancelSilently();
    return super.close();
  }
}
