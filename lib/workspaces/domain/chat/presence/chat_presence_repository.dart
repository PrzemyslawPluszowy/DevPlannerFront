import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';

/// Port obecności opartej o REST: własny status i status innego użytkownika.
///
/// Lease'y obecności i wskaźnik pisania nie należą do tego portu, ponieważ są
/// wywołaniami huba; realizuje je port subskrypcji rozmowy, który ma własny
/// lifecycle połączenia. Ten port nie zgaduje statusu online z samego istnienia
/// konta w katalogu.
abstract interface class ChatPresenceRepository {
  /// Zwraca aktywny status użytkownika albo `null`, gdy status wygasł.
  Future<Either<ApiError, ChatUserStatus?>> getUserStatus(String userId);

  /// Ustawia własny status emoji/tekst z opcjonalnym wygaśnięciem i DND.
  Future<Either<ApiError, ChatUserStatus>> setOwnStatus(
    ChatUserStatusUpdate update,
  );

  /// Czyści własny status.
  Future<Either<ApiError, void>> clearOwnStatus();
}
