import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_snapshot.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';

export 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_snapshot.dart';

/// Port serwerowego szkicu rozmowy.
///
/// Szkic serwerowy jest źródłem prawdy dla wskaźnika `isDraft` w skrzynce:
/// lokalny secure storage chroni treść offline, ale tylko wersja serwerowa jest
/// widoczna dla tego samego użytkownika na innym urządzeniu.
abstract interface class ChatServerDraftRepository {
  /// Zwraca szkic rozmowy albo `null`, gdy użytkownik nie ma szkicu.
  Future<Either<ApiError, ChatServerDraftSnapshot?>> readDraft(
    String conversationId,
  );

  /// Zapisuje szkic z wersją wymaganą przez backend.
  Future<Either<ApiError, ChatServerDraftSnapshot>> saveDraft({
    required String conversationId,
    required ChatComposerDraft draft,
    required int version,
  });

  /// Usuwa szkic rozmowy.
  Future<Either<ApiError, void>> deleteDraft(String conversationId);
}
