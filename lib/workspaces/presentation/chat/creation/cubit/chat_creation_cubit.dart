import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_client_message_id_factory.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prowadzi szkic nowej rozmowy od typu do wysłania.
///
/// Cubit nie zna widgetów ani nawigacji. Waliduje dokładnie to, co egzekwuje
/// backend (liczba uczestników, długość nazwy), a unikalność rozmowy 1:1
/// pozostawia `POST /conversations/resolve`, który zwraca istniejącą rozmowę
/// pary zamiast tworzyć drugą.
final class ChatCreationCubit extends Cubit<ChatCreationState> {
  /// Tworzy cubit kreatora na porcie zarządzania rozmowami.
  ChatCreationCubit({
    required ChatConversationManagementRepository repository,
    ChatClientMessageIdFactory? scopeKeyFactory,
    Set<String> existingDirectConversationIds = const <String>{},
  }) : this._(
         repository,
         scopeKeyFactory ?? ChatClientMessageIdFactory(),
         existingDirectConversationIds,
       );

  ChatCreationCubit._(
    this._repository,
    this._scopeKeyFactory,
    Set<String> existingDirectConversationIds,
  ) : super(
        ChatCreationState(
          existingDirectConversationIds: existingDirectConversationIds,
        ),
      );

  /// Maksymalna długość nazwy zgodna z backendem.
  static const int maxNameLength = 240;

  /// Maksymalna liczba uczestników grupy zgodna z backendem (z twórcą).
  static const int maxGroupParticipants = 50;

  final ChatConversationManagementRepository _repository;
  final ChatClientMessageIdFactory _scopeKeyFactory;

  /// Wybiera typ rozmowy i przechodzi do właściwego kroku.
  void selectKind(ChatConversationKind kind) {
    emit(
      state.copyWith(
        kind: kind,
        // Ogłoszenia publikuje wyłącznie Owner/Moderator, więc wybór jest
        // zablokowany zamiast udawać, że backend to przyjmie.
        postingPermission: kind == ChatConversationKind.broadcast
            ? 'AdminsOnly'
            : state.postingPermission,
        step: _requiresParticipants(kind)
            ? ChatCreationStep.participants
            : ChatCreationStep.details,
        validationErrors: const <ChatCreationValidation>[],
        clearFailure: true,
      ),
    );
  }

  /// Wraca do poprzedniego kroku bez utraty szkicu.
  ///
  /// Z kroku uczestników wracamy do wyboru typu, a nie do tego samego kroku:
  /// inaczej zmiana rodzaju rozmowy wymagałaby zamknięcia kreatora.
  void back() {
    final kind = state.kind;
    if (kind == null || state.step == ChatCreationStep.chooser) return;
    final step =
        state.step == ChatCreationStep.details && _requiresParticipants(kind)
        ? ChatCreationStep.participants
        : ChatCreationStep.chooser;
    emit(
      state.copyWith(
        step: step,
        validationErrors: const <ChatCreationValidation>[],
      ),
    );
  }

  /// Przechodzi dalej, jeśli krok uczestników jest poprawny.
  void continueToDetails() {
    final errors = validateParticipants();
    if (errors.isNotEmpty) {
      emit(state.copyWith(validationErrors: errors));
      return;
    }
    emit(
      state.copyWith(
        step: ChatCreationStep.details,
        validationErrors: const <ChatCreationValidation>[],
      ),
    );
  }

  /// Dodaje albo usuwa osobę z listy uczestników.
  void toggleParticipant(ChatDirectoryEntry entry) {
    final current = state.participants;
    final exists = current.any((item) => item.userId == entry.userId);
    final updated = exists
        ? current
              .where((item) => item.userId != entry.userId)
              .toList(
                growable: false,
              )
        : <ChatDirectoryEntry>[...current, entry];
    emit(
      state.copyWith(
        participants: updated,
        validationErrors: const <ChatCreationValidation>[],
      ),
    );
  }

  /// Wybiera jedną osobę i od razu kończy rozmowę 1:1.
  ///
  /// 1:1 nie ma kroku szczegółów: backend rozwiązuje istniejący DM pary albo
  /// tworzy go, a panel otwiera to, co wróciło. Podwójne kliknięcie nie tworzy
  /// duplikatu, bo w trakcie wysyłki metoda jest idempotentna.
  ///
  /// Rodzaj rozmowy ustawia sama metoda: popover „Nowy czat” startuje bez
  /// wybranego typu, a `submit()` czyta `state.kind`, więc pominięcie tego kroku
  /// kończyło się wyjątkiem zamiast rozmowy 1:1.
  Future<void> startDirectWith(ChatDirectoryEntry entry) async {
    if (isClosed || state.isSubmitting) return;
    emit(
      state.copyWith(
        kind: ChatConversationKind.direct,
        participants: <ChatDirectoryEntry>[entry],
        validationErrors: const <ChatCreationValidation>[],
        clearFailure: true,
      ),
    );
    await submit();
  }

  /// Ustawia nazwę rozmowy, obcinając nadmiarowe spacje brzegowe.
  void setName(String value) =>
      emit(state.copyWith(name: value, clearFailure: true));

  /// Ustawia zasady publikacji kanału.
  void setPostingPermission(String permission) {
    if (state.postingPermissionLocked) return;
    emit(state.copyWith(postingPermission: permission));
  }

  /// Waliduje krok uczestników zgodnie z regułami backendu.
  List<ChatCreationValidation> validateParticipants() {
    final kind = state.kind;
    final count = state.participants.length;
    if (kind == ChatConversationKind.direct && count != 1) {
      return const <ChatCreationValidation>[
        ChatCreationValidation.directRequiresOneParticipant,
      ];
    }
    if (kind == ChatConversationKind.group) {
      if (count < 1) {
        return const <ChatCreationValidation>[
          ChatCreationValidation.groupRequiresParticipant,
        ];
      }
      if (count + 1 > maxGroupParticipants) {
        return const <ChatCreationValidation>[
          ChatCreationValidation.groupTooManyParticipants,
        ];
      }
    }
    return const <ChatCreationValidation>[];
  }

  /// Waliduje krok szczegółów zgodnie z regułami backendu.
  List<ChatCreationValidation> validateDetails() {
    final name = state.name.trim();
    if (state.requiresName && name.isEmpty) {
      return const <ChatCreationValidation>[
        ChatCreationValidation.nameRequired,
      ];
    }
    if (name.length > maxNameLength) {
      return const <ChatCreationValidation>[
        ChatCreationValidation.nameTooLong,
      ];
    }
    return const <ChatCreationValidation>[];
  }

  /// Wysyła rozmowę do `POST /conversations/resolve`.
  ///
  /// Po sukcesie emituje utworzoną albo odnalezioną rozmowę; przy błędzie szkic
  /// zostaje nietknięty, więc użytkownik nie traci wyboru.
  Future<void> submit() async {
    if (isClosed || state.isSubmitting) return;
    var errors = validateParticipants();
    errors = <ChatCreationValidation>[...errors, ...validateDetails()];
    if (errors.isNotEmpty) {
      emit(state.copyWith(validationErrors: errors));
      return;
    }
    final kind = state.kind!;
    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    final command = ChatConversationCreateCommand(
      kind: kind,
      scope: ChatConversationScope.global,
      // Globalny kanał nie ma zakresu poza rozmową, więc klucz jest nieprzejrzystym
      // identyfikatorem nadanym raz przy tworzeniu.
      scopeKey: kind == ChatConversationKind.direct
          ? 'direct'
          : 'channel-${_scopeKeyFactory.create()}',
      name: state.requiresName
          ? state.name.trim()
          : state.name.trim().isEmpty
          ? null
          : state.name.trim(),
      userIds: state.requiresParticipants
          ? state.participants
                .map((entry) => entry.userId)
                .toList(
                  growable: false,
                )
          : const <String>[],
      postingPermission: state.postingPermission,
    );
    final result = await _repository.createConversation(command);
    result.fold(
      (error) => emit(
        state.copyWith(
          isSubmitting: false,
          failureCode: ChatCreationFailure.fromApiError(error).apiCode,
        ),
      ),
      (conversation) => emit(
        state.copyWith(isSubmitting: false, created: conversation),
      ),
    );
  }

  static bool _requiresParticipants(ChatConversationKind kind) =>
      kind == ChatConversationKind.direct || kind == ChatConversationKind.group;
}
