import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/snippets/chat_snippet_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_external_link_port.dart';

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
    this.inboxRepository,
    this.conversationManagementRepository,
    this.directoryRepository,
    this.pendingSendStore,
    this.serverDraftRepository,
    this.threadRepository,
    this.discussionRepository,
    this.membersRepository,
    this.searchRepository,
    this.presenceRepository,
    this.messageActions,
    this.notificationSettingsRepository,
    this.attachmentUploadPort,
    this.attachmentAccessPort,
    this.linkPort,
    this.linkPolicyRepository,
    this.linkPreviewRepository,
    this.snippetRepository,
    this.filePickerPort,
    this.realtimeFactory,
  });

  /// Repozytorium listy, historii i wysyłki rozmów.
  final ChatRepository repository;

  /// Kanoniczny lokalny UserId bieżącej sesji, używany wyłącznie do draftów.
  final String userId;

  /// Prywatny magazyn draftów z lifecycle ograniczonym do użytkownika.
  final ChatDraftRepository draftRepository;

  /// Port serwerowej skrzynki: licznik nieprzeczytanych, kursory i znacznik odczytu.
  final ChatInboxRepository? inboxRepository;

  /// Port zarządzania rozmowami: tworzenie, szczegóły, archiwum, opuszczenie.
  final ChatConversationManagementRepository? conversationManagementRepository;

  /// Port historii wątku; brak oznacza panel bez wątków.
  final ChatThreadRepository? threadRepository;

  /// Port nazwanej dyskusji przypiętej do wiadomości.
  final ChatDiscussionRepository? discussionRepository;

  /// Port serwerowego szkicu; bez niego szkic zostaje wyłącznie lokalny.
  final ChatServerDraftRepository? serverDraftRepository;

  /// Magazyn oczekujących wysyłek; na Web celowo nieutrwalający.
  final ChatPendingSendStore? pendingSendStore;

  /// Port lokalnego katalogu kont do rozpoczęcia nowej rozmowy.
  final ChatDirectoryRepository? directoryRepository;

  /// Port członkostwa rozmowy: lista, dodawanie, role, usuwanie.
  final ChatMembersRepository? membersRepository;

  /// Port wyszukiwania wiadomości i podpowiedzi wzmianek.
  final ChatSearchRepository? searchRepository;

  /// Port obecności REST: własny status i status innego użytkownika.
  final ChatPresenceRepository? presenceRepository;

  /// Port polityki powiadomień Chat: globalnej i per rozmowa.
  ///
  /// Jest częścią kompozycji, bo modale ustawień są montowane w rootowym hoście
  /// i nie mogą odczytywać portu z poddrzewa panelu.
  final ChatNotificationSettingsRepository? notificationSettingsRepository;

  /// Opcjonalny port bezpiecznego uploadu załączników Chat/Storage.
  final ChatAttachmentUploadPort? attachmentUploadPort;

  /// Opcjonalny port otwierania linków poza aplikacją; brak ukrywa „Otwórz”.
  final ChatExternalLinkPort? linkPort;

  /// Port polityki snippetów; bez niego UI nie proponuje pliku TXT.
  final ChatLinkPolicyRepository? linkPolicyRepository;

  /// Autoryzowany backendowy podgląd pierwszego bezpiecznego linku wiadomości.
  final ChatLinkPreviewRepository? linkPreviewRepository;

  /// Port przygotowania snippet-u; bez niego nie da się wysłać tekstu jako TXT.
  final ChatSnippetRepository? snippetRepository;

  /// Opcjonalny port pobrania załącznika przez autoryzowaną ścieżkę Storage.
  ///
  /// Bez niego karta załącznika nie pokazuje akcji otwarcia, bo nie istnieje
  /// bezpieczny transport pliku na tej platformie.
  final ChatAttachmentAccessPort? attachmentAccessPort;

  /// Opcjonalny adapter wyboru plików platformy.
  final FilePickerPort? filePickerPort;

  /// Akcje na wiadomościach dostarczone jako osobny adapter.
  final ChatMessageActionsRepository? messageActions;

  /// Sesyjny właściciel subskrypcji realtime Chatu.
  final WorkspaceChatRealtimeFactory? realtimeFactory;

  /// Historia rozmowy jest dostępna, gdy repozytorium implementuje pełny
  /// kontrakt Chat. Brak kontraktu nie może powodować castu w UI.
  ChatConversationRepository? get conversationRepository =>
      repository is ChatConversationRepository
      ? repository as ChatConversationRepository
      : null;

  /// Opcjonalne kontrakty rozszerzeń pełnego widoku; panel nie wymusza ich.
  /// Akcje na wiadomościach: edycja, usuwanie, forward, przypięcia,
  /// zakładki i reakcje.
  ChatMessageActionsRepository? get messageActionsRepository =>
      messageActions ?? _actionsFromRepository;

  ChatMessageActionsRepository? get _actionsFromRepository =>
      repository is ChatMessageActionsRepository
      ? repository as ChatMessageActionsRepository
      : null;
}
