import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';

/// Port członkostwa rozmowy: lista, dodawanie, role i usuwanie.
///
/// Port nie egzekwuje uprawnień samodzielnie; rola i reguły publikacji są
/// sprawdzane po stronie backendu, a UI korzysta z [ChatMemberRole], aby nie
/// pokazywać akcji, których użytkownik nie może wykonać.
abstract interface class ChatMembersRepository {
  /// Zwraca aktywnych członków rozmowy w kolejności dołączenia.
  Future<Either<ApiError, List<ChatMember>>> listMembers(String conversationId);

  /// Dodaje nowych członków do rozmowy grupowej albo kanału.
  Future<Either<ApiError, List<ChatMember>>> addMembers({
    required String conversationId,
    required List<String> userIds,
  });

  /// Zmienia rolę wskazanego członka.
  Future<Either<ApiError, ChatMember>> updateMemberRole({
    required String conversationId,
    required String targetUserId,
    required ChatMemberRole role,
  });

  /// Usuwa członka z rozmowy.
  Future<Either<ApiError, void>> removeMember({
    required String conversationId,
    required String targetUserId,
  });
}
