import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';

/// Port polityki snippetów.
///
/// Presentation nie zna adresu endpointu ani klienta HTTP: bez polityki nie
/// zgaduje progów, tylko nie proponuje pliku TXT.
// Interfejs ma jednego członka celowo: to seam kompozycji (adapter REST
// w produkcji, fake w testach), a nie funkcja przekazywana argumentem.
// ignore: one_member_abstracts
abstract interface class ChatLinkPolicyRepository {
  /// Pobiera politykę snippetów obowiązującą na serwerze.
  Future<Either<ApiError, ChatLinkPolicy>> getPolicy();
}
