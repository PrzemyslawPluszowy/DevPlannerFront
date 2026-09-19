import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mały owner draftu z sekwencyjną, wersjonowaną trwałością per rozmowa.
final class ChatComposerCubit extends Cubit<ChatComposerState> {
  ChatComposerCubit({
    this.repository,
    this.userId,
    this.conversationId,
    this.debounce = const Duration(milliseconds: 350),
  }) : super(const ChatComposerState(draft: ChatComposerDraft(text: '')));

  final ChatDraftRepository? repository;
  final String? userId;
  final String? conversationId;
  final Duration debounce;
  Timer? _timer;
  Future<void> _persistenceTail = Future<void>.value();
  int _persistenceVersion = 0;

  void updatePlainText(String text) =>
      _update(state.draft.copyWith(text: text, clearDeltaJson: true));
  void updateRichText({required String text, required String deltaJson}) =>
      _update(state.draft.copyWith(text: text, deltaJson: deltaJson));
  void selectMode(ChatComposerMode mode) {
    if (state.mode != mode) emit(state.copyWith(mode: mode));
  }

  void replyTo(String id) =>
      _update(state.draft.copyWith(replyToMessageId: id));
  void clearReplyTarget() =>
      _update(state.draft.copyWith(clearReplyToMessageId: true));
  void updateAttachmentIds(List<String> attachmentIds) =>
      _update(state.draft.copyWith(attachmentIds: attachmentIds));

  Future<void> restore() async {
    final identity = _identity();
    if (identity == null) return;
    final restoreVersion = _persistenceVersion;
    final draft = await identity.repository.read(
      userId: identity.userId,
      conversationId: identity.conversationId,
    );
    if (!isClosed && restoreVersion == _persistenceVersion && draft != null) {
      emit(state.copyWith(draft: draft));
    }
  }

  void clearAfterSubmit() => unawaited(_clearPersisted());

  /// Usuwa prywatny draft po 401/403 lub realtime access-revoked.
  Future<void> clearForAccessRevoked() => _clearPersisted();

  Future<void> flush() async {
    _timer?.cancel();
    final version = ++_persistenceVersion;
    await _enqueueSave(version);
  }

  void _update(ChatComposerDraft draft) {
    emit(state.copyWith(draft: draft));
    _timer?.cancel();
    final version = ++_persistenceVersion;
    _timer = Timer(debounce, () => unawaited(_enqueueSave(version)));
  }

  Future<void> _clearPersisted() async {
    _timer?.cancel();
    ++_persistenceVersion;
    emit(
      ChatComposerState(
        draft: const ChatComposerDraft(text: ''),
        mode: state.mode,
      ),
    );
    await _enqueueDelete();
  }

  Future<void> _enqueueSave(int version) {
    final pending = _persistenceTail.then((_) async {
      if (version != _persistenceVersion) return;
      await _saveCurrent();
    });
    _persistenceTail = pending.catchError((Object _) {});
    return pending;
  }

  Future<void> _enqueueDelete() {
    final pending = _persistenceTail.then((_) => _deleteCurrent());
    _persistenceTail = pending.catchError((Object _) {});
    return pending;
  }

  Future<void> _saveCurrent() async {
    final identity = _identity();
    if (identity == null) return;
    final draft = state.draft;
    if (draft.isEmpty && draft.attachmentIds.isEmpty) {
      await identity.repository.delete(
        userId: identity.userId,
        conversationId: identity.conversationId,
      );
      return;
    }
    await identity.repository.save(
      userId: identity.userId,
      conversationId: identity.conversationId,
      draft: draft,
    );
  }

  Future<void> _deleteCurrent() async {
    final identity = _identity();
    if (identity != null) {
      await identity.repository.delete(
        userId: identity.userId,
        conversationId: identity.conversationId,
      );
    }
  }

  _DraftIdentity? _identity() {
    final repository = this.repository;
    final userId = this.userId;
    final conversationId = this.conversationId;
    return repository == null ||
            userId == null ||
            userId.trim().isEmpty ||
            conversationId == null ||
            conversationId.trim().isEmpty
        ? null
        : _DraftIdentity(repository, userId, conversationId);
  }

  @override
  Future<void> close() async {
    await flush();
    _timer?.cancel();
    await _persistenceTail;
    return super.close();
  }
}

final class _DraftIdentity {
  const _DraftIdentity(this.repository, this.userId, this.conversationId);
  final ChatDraftRepository repository;
  final String userId;
  final String conversationId;
}
