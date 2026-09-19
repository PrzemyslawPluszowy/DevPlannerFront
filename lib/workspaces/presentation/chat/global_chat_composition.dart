import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';

/// Zależności, które composition root dostarcza globalnemu Chatowi.
///
/// Klasa jest celowo niemutowalnym portem kompozycji. Panel nie tworzy
/// klienta HTTP, nie odczytuje sesji z globalnego stanu i nie zgaduje
/// implementacji backendu.
final class DevPlannerGlobalChatComposition {
  const DevPlannerGlobalChatComposition({
    required this.repository,
    required this.userId,
    required this.draftRepository,
    this.attachmentUploadPort,
    this.filePickerPort,
    this.realtimeFactory,
  });

  /// Repozytorium listy, historii i wysyłki rozmów.
  final ChatRepository repository;

  /// Kanoniczny lokalny UserId bieżącej sesji, używany wyłącznie do draftów.
  final String userId;

  /// Prywatny magazyn draftów z lifecycle ograniczonym do użytkownika.
  final ChatDraftRepository draftRepository;

  /// Opcjonalny port bezpiecznego uploadu załączników Chat/Storage.
  final ChatAttachmentUploadPort? attachmentUploadPort;

  /// Opcjonalny adapter wyboru plików platformy.
  final FilePickerPort? filePickerPort;

  /// Fabryka połączeń realtime o lifecycle jednej rozmowy.
  final WorkspaceChatRealtimeFactory? realtimeFactory;

  /// Historia rozmowy jest dostępna, gdy repozytorium implementuje pełny
  /// kontrakt Chat. Brak kontraktu nie może powodować castu w UI.
  ChatConversationRepository? get conversationRepository =>
      repository is ChatConversationRepository
      ? repository as ChatConversationRepository
      : null;

  /// Opcjonalne kontrakty rozszerzeń pełnego widoku; panel nie wymusza ich.
  ChatMessageActionsRepository? get messageActionsRepository =>
      repository is ChatMessageActionsRepository
      ? repository as ChatMessageActionsRepository
      : null;

  ChatThreadRepository? get threadRepository =>
      repository is ChatThreadRepository
      ? repository as ChatThreadRepository
      : null;

  ChatDiscussionRepository? get discussionRepository =>
      repository is ChatDiscussionRepository
      ? repository as ChatDiscussionRepository
      : null;
}
