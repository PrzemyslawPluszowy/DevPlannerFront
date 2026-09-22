import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:equatable/equatable.dart';

/// Krok kreatora rozmowy.
enum ChatCreationStep {
  /// Wybór typu rozmowy.
  chooser,

  /// Wybór uczestników z lokalnego katalogu.
  participants,

  /// Nazwa i zasady publikacji.
  details,
}

/// Walidacja kreatora rozmowy zwracająca kod domenowy błędu pola.
enum ChatCreationValidation {
  /// Kanał albo ogłoszenia wymagają nazwy.
  nameRequired,

  /// Nazwa przekracza limit backendu.
  nameTooLong,

  /// Rozmowa 1:1 wymaga dokładnie jednej osoby.
  directRequiresOneParticipant,

  /// Grupa wymaga co najmniej jednej osoby poza twórcą.
  groupRequiresParticipant,

  /// Grupa przekracza limit uczestników backendu.
  groupTooManyParticipants,
}

/// Stan kreatora rozmowy: szkic, walidacja i wynik wysłania.
class ChatCreationState extends Equatable {
  /// Tworzy stan kreatora.
  const ChatCreationState({
    this.step = ChatCreationStep.chooser,
    this.kind,
    this.participants = const <ChatDirectoryEntry>[],
    this.name = '',
    this.postingPermission = 'Everyone',
    this.isSubmitting = false,
    this.validationErrors = const <ChatCreationValidation>[],
    this.failureCode,
    this.created,
    this.existingDirectConversationIds = const <String>{},
  });

  final ChatCreationStep step;
  final ChatConversationKind? kind;
  final List<ChatDirectoryEntry> participants;
  final String name;
  final String postingPermission;
  final bool isSubmitting;
  final List<ChatCreationValidation> validationErrors;

  /// Kod domenowy błędu wysłania; UI mapuje go na tekst przez ARB.
  final String? failureCode;

  /// Utworzona albo odnaleziona rozmowa.
  final ChatConversation? created;

  /// Rozmowy 1:1, które już istnieją dla wybranej osoby; backend je odnawia.
  final Set<String> existingDirectConversationIds;

  /// Czy rozmowa wymaga listy uczestników (1:1 i grupa).
  bool get requiresParticipants =>
      kind == ChatConversationKind.direct || kind == ChatConversationKind.group;

  /// Czy rozmowa wymaga nazwy (kanał i ogłoszenia).
  bool get requiresName =>
      kind == ChatConversationKind.channel ||
      kind == ChatConversationKind.broadcast;

  /// Czy ogłoszenia wymuszają publikację tylko dla uprawnionych.
  bool get postingPermissionLocked =>
      kind == ChatConversationKind.broadcast;

  /// Tworzy kopię stanu z nowymi wartościami.
  ChatCreationState copyWith({
    ChatCreationStep? step,
    ChatConversationKind? kind,
    List<ChatDirectoryEntry>? participants,
    String? name,
    String? postingPermission,
    bool? isSubmitting,
    List<ChatCreationValidation>? validationErrors,
    String? failureCode,
    bool clearFailure = false,
    ChatConversation? created,
    Set<String>? existingDirectConversationIds,
  }) => ChatCreationState(
    step: step ?? this.step,
    kind: kind ?? this.kind,
    participants: participants ?? this.participants,
    name: name ?? this.name,
    postingPermission: postingPermission ?? this.postingPermission,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    validationErrors: validationErrors ?? this.validationErrors,
    failureCode: clearFailure ? null : failureCode ?? this.failureCode,
    created: created ?? this.created,
    existingDirectConversationIds:
        existingDirectConversationIds ?? this.existingDirectConversationIds,
  );

  @override
  List<Object?> get props => [
    step,
    kind,
    participants,
    name,
    postingPermission,
    isSubmitting,
    validationErrors,
    failureCode,
    created,
    existingDirectConversationIds,
  ];
}

/// Błąd wysłania kreatora rozmowy z zachowanym kodem i `traceId`.
class ChatCreationFailure {
  /// Tworzy błąd z bezpiecznym kodem domenowym.
  const ChatCreationFailure(this.apiCode, {this.statusCode, this.traceId});

  /// Tworzy błąd z odpowiedzi portu bez ujawniania wyjątku transportu.
  factory ChatCreationFailure.fromApiError(ApiError error) => ChatCreationFailure(
    error.apiCode ?? error.message,
    statusCode: error.statusCode,
    traceId: error.traceId,
  );

  final String apiCode;
  final int? statusCode;
  final String? traceId;
}
