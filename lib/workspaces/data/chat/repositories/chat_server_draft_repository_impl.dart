import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:dio/dio.dart';

/// Implementacja portu serwerowego szkicu rozmowy.
final class ChatServerDraftRepositoryImpl implements ChatServerDraftRepository {
  /// Tworzy adapter na uwierzytelnionym kliencie Chat.
  ChatServerDraftRepositoryImpl(this._api);

  final ChatApi _api;
  static const _errorMapper = ChatApiErrorMapper();

  @override
  Future<Either<ApiError, ChatComposerDraft?>> readDraft(
    String conversationId,
  ) => _guard(
    () async {
      final response = await _api.getDraft(conversationId);
      if (response == null) return null;
      return ChatComposerDraft(
        text: response.text ?? '',
        deltaJson: response.deltaJson,
        replyToMessageId: response.replyToMessageId,
        attachmentIds:
            response.attachments
                ?.map((attachment) => attachment.storageFileId)
                .toList(growable: false) ??
            const <String>[],
      );
    },
    code: ChatApiErrorCode.loadDraft,
  );

  @override
  Future<Either<ApiError, ChatComposerDraft>> saveDraft({
    required String conversationId,
    required ChatComposerDraft draft,
    required int version,
  }) => _guard(
    () async {
      final response = await _api.upsertDraft(
        conversationId,
        UpsertChatDraftPayload(
          text: draft.text,
          deltaJson: draft.deltaJson,
          replyToMessageId: draft.replyToMessageId,
          version: version,
          attachmentStorageFileIds: draft.attachmentIds,
        ),
      );
      return ChatComposerDraft(
        text: response.text ?? '',
        deltaJson: response.deltaJson,
        replyToMessageId: response.replyToMessageId,
        attachmentIds:
            response.attachments
                ?.map((attachment) => attachment.storageFileId)
                .toList(growable: false) ??
            const <String>[],
      );
    },
    code: ChatApiErrorCode.saveDraft,
  );

  @override
  Future<Either<ApiError, void>> deleteDraft(String conversationId) => _guard(
    () => _api.deleteDraft(conversationId),
    code: ChatApiErrorCode.saveDraft,
  );

  Future<Either<ApiError, T>> _guard<T>(
    Future<T> Function() call, {
    required ChatApiErrorCode code,
  }) async {
    try {
      return Right(await call());
    } on DioException catch (error) {
      return Left(_errorMapper.fromDioException(error, code: code));
    } on Object {
      return Left(_errorMapper.fromParsing(code: code));
    }
  }
}
