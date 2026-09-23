import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Potwierdzony serwerowy stan nieprzeczytanych wiadomości Chat.
final class ChatUnreadState extends Equatable {
  /// Tworzy stan licznika.
  const ChatUnreadState({this.unread = 0, this.hasUnreadConversations = false});

  /// Łączna liczba nieprzeczytanych wiadomości.
  final int unread;

  /// Czy istnieje choć jedna rozmowa z nieprzeczytanymi wiadomościami.
  final bool hasUnreadConversations;

  /// Czy belka powinna pokazać badge.
  bool get hasUnread => unread > 0;

  @override
  List<Object?> get props => [unread, hasUnreadConversations];
}

/// Sesyjny licznik nieprzeczytanych wiadomości Chat.
///
/// Żyje dłużej niż panel, więc badge belki działa także przy zamkniętym panelu.
/// Liczbę zawsze bierze z serwerowego agregatu; sygnały realtime tylko zlecają
/// odświeżenie i są scalane, żeby seria zdarzeń nie wywołała serii żądań.
final class ChatUnreadCubit extends Cubit<ChatUnreadState> {
  /// Tworzy licznik na porcie skrzynki.
  ChatUnreadCubit({
    required this.repository,
    this.coalesceWindow = const Duration(milliseconds: 400),
  }) : super(const ChatUnreadState());

  final ChatInboxRepository repository;
  final Duration coalesceWindow;

  Timer? _coalesce;

  /// Pobiera agregat z serwera i publikuje wynik.
  Future<void> refresh() async {
    final result = await repository.loadUnreadCount();
    if (isClosed) return;
    result.fold(
      // Błąd nie może wyzerować badge: pokazujemy ostatni potwierdzony stan.
      (_) {},
      (count) => emit(
        ChatUnreadState(
          unread: count.totalUnreadCount,
          hasUnreadConversations: count.unreadConversationCount > 0,
        ),
      ),
    );
  }

  /// Zleca odświeżenie po zdarzeniu realtime, scalając serię sygnałów.
  void applySignal() {
    if (isClosed || (_coalesce?.isActive ?? false)) return;
    _coalesce = Timer(coalesceWindow, () => unawaited(refresh()));
  }

  /// Czyści licznik po zakończeniu sesji, żeby badge nie przeciekał między kontami.
  void reset() {
    _coalesce?.cancel();
    _coalesce = null;
    if (!isClosed) emit(const ChatUnreadState());
  }

  @override
  Future<void> close() {
    _coalesce?.cancel();
    _coalesce = null;
    return super.close();
  }
}
