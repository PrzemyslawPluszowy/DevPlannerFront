import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_open_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';

sealed class ResourceChatState {
  const ResourceChatState();
}

final class ResourceChatIdle extends ResourceChatState {
  const ResourceChatIdle();
}

final class ResourceChatResolving extends ResourceChatState {
  const ResourceChatResolving();
}

final class ResourceChatResolved extends ResourceChatState {
  const ResourceChatResolved({
    required this.conversation,
    required this.openRequest,
  });

  final ChatConversation conversation;
  final ResourceChatOpenRequest openRequest;
}

final class ResourceChatDenied extends ResourceChatState {
  const ResourceChatDenied(this.message);

  final String message;
}

final class ResourceChatFailure extends ResourceChatState {
  const ResourceChatFailure(this.message);

  final String message;
}

/// Orkiestruje pojedyncze, idempotentne otwarcie Chat pliku.
final class ResourceChatCubit extends Cubit<ResourceChatState> {
  ResourceChatCubit(this._repository) : super(const ResourceChatIdle());

  final ResourceChatRepository _repository;

  Future<void> resolveFile(ResourceChatFileRequest request) async {
    if (request.fileId.isEmpty || isClosed) return;
    emit(const ResourceChatResolving());
    final result = await _repository.resolveFileConversation(request);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        error.type == ApiErrorType.forbidden ||
                error.type == ApiErrorType.unauthorized
            ? ResourceChatDenied(error.message)
            : ResourceChatFailure(error.message),
      ),
      (conversation) => emit(
        ResourceChatResolved(
          conversation: conversation,
          openRequest: ResourceChatOpenRequest(
            conversationId: conversation.id,
            fileContext: request.fileContext,
          ),
        ),
      ),
    );
  }
}
