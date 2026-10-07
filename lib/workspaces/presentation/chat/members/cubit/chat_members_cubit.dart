import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan listy członków rozmowy.
sealed class ChatMembersState {
  const ChatMembersState();
}

/// Lista członków jest w drodze.
final class ChatMembersLoading extends ChatMembersState {
  /// Tworzy stan ładowania.
  const ChatMembersLoading();
}

/// Lista członków jest gotowa albo ostatnia mutacja się nie powiodła.
final class ChatMembersReady extends ChatMembersState {
  /// Tworzy stan gotowej listy.
  const ChatMembersReady({
    required this.members,
    required this.currentUserId,
    this.isMutating = false,
    this.failureCode,
    this.failureType,
    this.failureStatusCode,
  });

  final List<ChatMember> members;
  final String currentUserId;
  final bool isMutating;

  /// Kod domenowy ostatniej porażki; UI mapuje go na tekst przez ARB.
  final String? failureCode;

  /// Klasyfikacja błędu API potrzebna do podania użytkownikowi następnego kroku.
  final ApiErrorType? failureType;

  /// HTTP status zachowany, bo 400 walidacji klasyfikuje się jako badResponse.
  final int? failureStatusCode;

  /// Rola bieżącego użytkownika w rozmowie albo `null`, gdy nie jest członkiem.
  ChatMemberRole? get currentRole => members
      .where((member) => member.userId == currentUserId)
      .map((member) => member.role)
      .firstOrNull;

  /// Czy bieżący użytkownik może zarządzać członkami i rolami.
  bool get canManageMembers => currentRole?.canManageMembers ?? false;

  /// Czy opuszczenie wymaga wcześniej przekazania własności.
  bool get isSoleOwner =>
      currentRole == ChatMemberRole.owner &&
      members.where((member) => member.role == ChatMemberRole.owner).length ==
          1;

  /// Tworzy kopię stanu z nowymi wartościami; `clearFailure` usuwa kod błędu.
  ChatMembersReady copyWith({
    List<ChatMember>? members,
    bool? isMutating,
    String? failureCode,
    ApiErrorType? failureType,
    int? failureStatusCode,
    bool clearFailure = false,
  }) => ChatMembersReady(
    members: members ?? this.members,
    currentUserId: currentUserId,
    isMutating: isMutating ?? this.isMutating,
    failureCode: clearFailure ? null : failureCode ?? this.failureCode,
    failureType: clearFailure ? null : failureType ?? this.failureType,
    failureStatusCode: clearFailure
        ? null
        : failureStatusCode ?? this.failureStatusCode,
  );
}

/// Porażka pobrania listy członków.
final class ChatMembersFailure extends ChatMembersState {
  /// Tworzy stan błędu z kodem domenowym.
  const ChatMembersFailure(this.message, {this.accessRevoked = false});

  final String message;
  final bool accessRevoked;
}

/// Bieżący użytkownik opuścił rozmowę.
final class ChatMembersLeft extends ChatMembersState {
  /// Tworzy stan po opuszczeniu rozmowy.
  const ChatMembersLeft();
}

/// Prowadzi listę członków rozmowy oraz zmiany ról, usuwanie i opuszczenie.
///
/// Cubit nie decyduje o uprawnieniach: pokazuje role i akcje, ale każdą zmianę
/// wykonuje port, a backend ponownie egzekwuje politykę. Dzięki temu UI nie
/// udaje, że moderator może usunąć właściciela.
final class ChatMembersCubit extends Cubit<ChatMembersState> {
  /// Tworzy cubit na portach członkostwa i zarządzania rozmową.
  ChatMembersCubit({
    required ChatMembersRepository membersRepository,
    required this.conversationId,
    required this.currentUserId,
    ChatConversationManagementRepository? conversationManagement,
  }) : _members = membersRepository,
       _management = conversationManagement,
       super(const ChatMembersLoading());

  final ChatMembersRepository _members;
  final ChatConversationManagementRepository? _management;
  final String conversationId;
  final String currentUserId;
  int _loadGeneration = 0;
  bool _accessRevoked = false;

  /// Odczyt ACL obecności zamyka widok danych po odebraniu dostępu.
  void invalidateAccess(ApiError error) {
    if (isClosed || _accessRevoked) return;
    _accessRevoked = true;
    _loadGeneration++;
    emit(ChatMembersFailure(error.message, accessRevoked: true));
  }

  /// Pobiera aktywnych członków rozmowy.
  Future<void> load() {
    final current = state;
    if (current is ChatMembersReady && current.isMutating) {
      return Future<void>.value();
    }
    return _reload(showLoading: true);
  }

  /// Odświeża listę po mutacji bez migotania pustym stanem.
  Future<void> _reload({bool showLoading = false}) async {
    if (isClosed || _accessRevoked) return;
    final generation = ++_loadGeneration;
    if (showLoading) emit(const ChatMembersLoading());
    final result = await _members.listMembers(conversationId);
    if (isClosed || _accessRevoked || generation != _loadGeneration) return;
    result.fold(
      (error) => emit(ChatMembersFailure(error.message)),
      (members) => emit(
        ChatMembersReady(members: members, currentUserId: currentUserId),
      ),
    );
  }

  /// Zmienia rolę członka i odświeża listę po potwierdzeniu.
  Future<void> changeRole({
    required String targetUserId,
    required ChatMemberRole role,
  }) => _mutate(
    () => _members.updateMemberRole(
      conversationId: conversationId,
      targetUserId: targetUserId,
      role: role,
    ),
  );

  /// Usuwa członka z rozmowy po potwierdzeniu.
  Future<void> removeMember(String targetUserId) => _mutate(
    () => _members.removeMember(
      conversationId: conversationId,
      targetUserId: targetUserId,
    ),
  );

  /// Dodaje wskazane konta i odświeża listę po potwierdzeniu.
  ///
  /// Wybór pozostaje po stronie widoku, żeby przy błędzie użytkownik nie tracił
  /// zaznaczenia; ten cubit odświeża wyłącznie potwierdzony stan serwera.
  Future<void> addMembers(List<String> userIds) {
    if (userIds.isEmpty) return Future<void>.value();
    return _mutate(
      () =>
          _members.addMembers(conversationId: conversationId, userIds: userIds),
    );
  }

  /// Opuszcza rozmowę bieżącym użytkownikiem.
  Future<void> leave() async {
    final management = _management;
    final current = state;
    if (isClosed ||
        _accessRevoked ||
        management == null ||
        current is! ChatMembersReady ||
        current.isMutating) {
      return;
    }
    _emitMutating(true);
    final result = await management.leaveConversation(conversationId);
    if (isClosed || _accessRevoked) return;
    switch (result) {
      case Left(value: final error):
        _emitFailure(error);
      case Right():
        emit(const ChatMembersLeft());
    }
  }

  Future<void> _mutate<T>(
    Future<Either<ApiError, T>> Function() operation,
  ) async {
    final current = state;
    if (isClosed ||
        _accessRevoked ||
        current is! ChatMembersReady ||
        current.isMutating) {
      return;
    }
    _emitMutating(true);
    final result = await operation();
    if (isClosed || _accessRevoked) return;
    // Odświeżenie jest czekane: wołający nie może zobaczyć starej listy jako
    // wyniku zakończonej mutacji.
    switch (result) {
      case Left(value: final error):
        _emitFailure(error);
      case Right():
        await _reload();
    }
  }

  void _emitMutating(bool value) {
    final current = state;
    if (current is ChatMembersReady) {
      emit(current.copyWith(isMutating: value, clearFailure: value));
    }
  }

  void _emitFailure(ApiError error) {
    final current = state;
    if (current is ChatMembersReady) {
      emit(
        current.copyWith(
          isMutating: false,
          failureCode: error.apiCode ?? error.message,
          failureType: error.type,
          failureStatusCode: error.statusCode,
        ),
      );
      return;
    }
    emit(ChatMembersFailure(error.message));
  }
}
