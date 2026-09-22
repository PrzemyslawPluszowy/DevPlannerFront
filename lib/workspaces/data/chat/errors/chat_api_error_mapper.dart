import 'package:devplanner/core/error/api_error.dart';
import 'package:dio/dio.dart';

/// Typowane kody błędów bazowego pionu Chat.
enum ChatApiErrorCode {
  loadConversations,
  loadInbox,
  loadInboxUnreadCount,
  markConversationRead,
  markMessageDelivered,
  loadMessages,
  sendMessage,
  manageConversation,
  loadMembers,
  changeMembers,
  actOnMessage,
  searchMessages,
  createAttachmentSession,
  loadDraft,
  saveDraft,
  loadDirectory,
  loadUserStatus,
  updateOwnStatus,
  invalidResponse,
}

/// Mapuje błędy transportu Chat na kod domenowy bez tekstu dla użytkownika.
///
/// Warstwa presentation może później zmapować [ApiError.apiCode] przez ARB.
final class ChatApiErrorMapper {
  /// Tworzy mapper bez stanu i bez zależności od UI/l10n.
  const ChatApiErrorMapper();

  /// Mapuje błąd Dio, zachowując typ/status/kod backendu.
  ApiError fromDioException(
    DioException error, {
    required ChatApiErrorCode code,
  }) {
    final mapped = ApiError.fromDioException(
      error,
      fallbackMessage: _codeValue(code),
    );
    return ApiError(
      type: mapped.type,
      message: _codeValue(code),
      statusCode: mapped.statusCode,
      backendCode: mapped.backendCode,
      apiCode: _codeValue(code),
      traceId: mapped.traceId,
    );
  }

  /// Tworzy błąd parsowania z kodem maszynowym.
  ApiError fromParsing({required ChatApiErrorCode code}) => ApiError(
    type: ApiErrorType.parsing,
    message: _codeValue(code),
    apiCode: _codeValue(code),
  );

  String _codeValue(ChatApiErrorCode code) => switch (code) {
    ChatApiErrorCode.loadConversations => 'chat.conversations.load_failed',
    ChatApiErrorCode.loadInbox => 'chat.inbox.load_failed',
    ChatApiErrorCode.loadInboxUnreadCount => 'chat.inbox.unread_count_failed',
    ChatApiErrorCode.markConversationRead =>
      'chat.conversations.mark_read_failed',
    ChatApiErrorCode.markMessageDelivered =>
      'chat.messages.mark_delivered_failed',
    ChatApiErrorCode.loadMessages => 'chat.messages.load_failed',
    ChatApiErrorCode.sendMessage => 'chat.messages.send_failed',
    ChatApiErrorCode.manageConversation => 'chat.conversations.manage_failed',
    ChatApiErrorCode.loadMembers => 'chat.members.load_failed',
    ChatApiErrorCode.changeMembers => 'chat.members.change_failed',
    ChatApiErrorCode.actOnMessage => 'chat.messages.action_failed',
    ChatApiErrorCode.searchMessages => 'chat.search.failed',
    ChatApiErrorCode.createAttachmentSession =>
      'chat.attachments.session_failed',
    ChatApiErrorCode.loadDraft => 'chat.drafts.load_failed',
    ChatApiErrorCode.saveDraft => 'chat.drafts.save_failed',
    ChatApiErrorCode.loadDirectory => 'chat.directory.load_failed',
    ChatApiErrorCode.loadUserStatus => 'chat.status.load_failed',
    ChatApiErrorCode.updateOwnStatus => 'chat.status.update_failed',
    ChatApiErrorCode.invalidResponse => 'chat.response.invalid',
  };
}
