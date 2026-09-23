import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan przełącznika wyciszenia rozmowy.
class ChatConversationMuteState {
  /// Tworzy stan wyciszenia.
  const ChatConversationMuteState({
    this.mode,
    this.isBusy = false,
    this.failureCode,
  });

  /// Aktualna polityka dostarczania rozmowy albo `null` przed odczytem.
  final ChatConversationNotificationMode? mode;
  final bool isBusy;

  /// Kod domenowy ostatniej porażki; UI mapuje go na tekst przez ARB.
  final String? failureCode;

  /// Czy rozmowa jest wyciszona.
  bool get isMuted => mode == ChatConversationNotificationMode.muted;

  /// Tworzy kopię stanu z nowymi wartościami.
  ChatConversationMuteState copyWith({
    ChatConversationNotificationMode? mode,
    bool? isBusy,
    String? failureCode,
    bool clearFailure = false,
  }) => ChatConversationMuteState(
    mode: mode ?? this.mode,
    isBusy: isBusy ?? this.isBusy,
    failureCode: clearFailure ? null : failureCode ?? this.failureCode,
  );
}

/// Prowadzi wyciszenie jednej rozmowy na porcie ustawień powiadomień.
///
/// Wyciszenie jest polityką serwera, nie stanem UI: po przełączeniu cubit
/// zapisuje politykę i pokazuje stan potwierdzony przez backend. Porażka wraca
/// kodem, a poprzednia polityka zostaje bez zmian, więc przełącznik nie kłamie.
final class ChatConversationMuteCubit extends Cubit<ChatConversationMuteState> {
  /// Tworzy cubit na porcie ustawień powiadomień.
  ChatConversationMuteCubit({
    required ChatNotificationSettingsRepository repository,
    required String conversationId,
  }) : this._(repository, conversationId);

  ChatConversationMuteCubit._(this._repository, this.conversationId)
    : super(const ChatConversationMuteState());

  final ChatNotificationSettingsRepository _repository;

  /// Rozmowa, której dotyczy przełącznik.
  final String conversationId;

  /// Odczytuje bieżącą politykę rozmowy.
  Future<void> load() async {
    if (isClosed) return;
    emit(state.copyWith(isBusy: true, clearFailure: true));
    final result = await _repository.getConversationSetting(conversationId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          isBusy: false,
          failureCode: error.apiCode ?? error.message,
        ),
      ),
      (setting) => emit(state.copyWith(mode: setting.mode, isBusy: false)),
    );
  }

  /// Przełącza wyciszenie rozmowy i zapisuje politykę na serwerze.
  Future<void> toggleMute() async {
    if (isClosed || state.isBusy) return;
    final previous = state.mode;
    final target = state.isMuted
        ? ChatConversationNotificationMode.all
        : ChatConversationNotificationMode.muted;
    emit(state.copyWith(isBusy: true, clearFailure: true, mode: target));
    final result = await _repository.updateConversationSetting(
      conversationId: conversationId,
      mode: target,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        // Powrót do potwierdzonego stanu: przełącznik nie może zostać w pozycji,
        // której serwer nie przyjął.
        state.copyWith(
          isBusy: false,
          mode: previous ?? ChatConversationNotificationMode.all,
          failureCode: error.apiCode ?? error.message,
        ),
      ),
      (setting) => emit(state.copyWith(mode: setting.mode, isBusy: false)),
    );
  }
}
