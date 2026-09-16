import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_drawer_state.dart';

/// Lokalny Cubit listy rozmów; jego cykl życia należy do otwartego draweru.
class ChatDrawerCubit extends Cubit<ChatDrawerState> {
  /// Tworzy Cubit na kontrakcie domenowym Chat.
  ChatDrawerCubit(ChatRepository repository)
    : _repository = repository,
      super(const ChatDrawerInitial());

  final ChatRepository _repository;

  /// Pobiera aktywne rozmowy i zachowuje jawny komunikat błędu.
  Future<void> load() async {
    if (isClosed) return;
    emit(const ChatDrawerLoading());
    final result = await _repository.listConversations();
    if (isClosed) return;
    result.fold(
      (error) => emit(ChatDrawerFailure(error.message)),
      (items) => emit(
        items.isEmpty
            ? const ChatDrawerEmpty()
            : ChatDrawerReady(List.unmodifiable(items)),
      ),
    );
  }
}
