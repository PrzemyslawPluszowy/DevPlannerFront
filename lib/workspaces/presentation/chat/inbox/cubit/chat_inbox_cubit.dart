import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prowadzi skrzynkę rozmów: filtr, kursor i serwerowy licznik nieprzeczytanych.
///
/// Cubit nie zna widgetów, nawigacji ani transakcji wiadomości. Filtrowanie po
/// frazie należy do widoku, bo dotyczy już pobranej strony i nie może udawać
/// wyszukiwania po serwerze.
final class ChatInboxCubit extends Cubit<ChatInboxState> {
  /// Tworzy cubit na porcie skrzynki.
  ChatInboxCubit({required this._repository, this.pageSize = 30})
    : super(const ChatInboxLoading());

  final ChatInboxRepository _repository;

  /// Rozmiar strony wysyłany do backendu.
  final int pageSize;

  ChatInboxFilter _filter = ChatInboxFilter.all;

  /// Bieżący filtr skrzynki.
  ChatInboxFilter get filter => _filter;

  /// Pobiera pierwszą stronę dla bieżącego filtra.
  Future<void> load() => _loadFirstPage();

  /// Ponawia pobranie pierwszej strony po błędzie.
  Future<void> retry() => _loadFirstPage();

  /// Zmienia filtr i pobiera pierwszą stronę od nowa.
  Future<void> setFilter(ChatInboxFilter filter) async {
    if (_filter == filter) return;
    _filter = filter;
    await _loadFirstPage();
  }

  /// Odświeża pierwszą stronę, zachowując bieżący filtr.
  Future<void> refresh() => _loadFirstPage();

  /// Dociąga kolejną stronę, jeśli istnieje i nie trwa już pobieranie.
  Future<void> loadMore() async {
    final current = state;
    if (current is! ChatInboxReady ||
        !current.hasMore ||
        current.isLoadingMore ||
        current.nextCursor == null) {
      return;
    }
    final requestId = ++_requestId;
    emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
    final result = await _repository.loadInbox(
      filter: _filter,
      cursor: current.nextCursor,
      limit: pageSize,
    );
    if (isClosed || requestId != _requestId) return;
    result.fold(
      (error) => emit(
        current.copyWith(isLoadingMore: false, loadMoreFailed: true),
      ),
      (page) => emit(
        current.copyWith(
          items: <ChatInboxItem>[...current.items, ...page.items],
          nextCursor: page.nextCursor,
          clearNextCursor: page.nextCursor == null,
          hasMore: page.hasMore,
          isLoadingMore: false,
          loadMoreFailed: false,
        ),
      ),
    );
  }

  /// Odświeża wyłącznie serwerowy licznik nieprzeczytanych.
  ///
  /// Wywoływane po oznaczeniu odczytu, żeby badge wrócił do stanu serwera bez
  /// pobierania wszystkich stron skrzynki.
  Future<void> refreshUnreadTotal() async {
    final result = await _repository.loadUnreadCount();
    result.fold((_) {}, (counts) {
      final current = state;
      if (current is ChatInboxReady) {
        emit(current.copyWith(unreadTotal: counts.totalUnreadCount));
      }
    });
  }

  /// Identyfikator najnowszego żądania pierwszej strony.
  ///
  /// Wolniejsza odpowiedź starszego filtra nie może zastąpić nowszej listy ani
  /// zostać podpisana aktualnym filtrem; emisja po zamknięciu Cubita jest
  /// pomijana tak samo.
  int _requestId = 0;

  Future<void> _loadFirstPage() async {
    final requestId = ++_requestId;
    emit(const ChatInboxLoading());
    // Licznik i strona idą równolegle, ale stan emitujemy raz: licznik pochodzi
    // z serwera i obejmuje wszystkie strony, nie tylko pobraną.
    final pageFuture = _repository.loadInbox(filter: _filter, limit: pageSize);
    final countsFuture = _repository.loadUnreadCount();
    final result = await pageFuture;
    final counts = await countsFuture;
    if (isClosed || requestId != _requestId) return;
    final unreadTotal = counts.fold(
      (error) => 0,
      (value) => value.totalUnreadCount,
    );
    result.fold(
      (error) => emit(ChatInboxFailure(error.message)),
      (page) => emit(_stateForPage(page, unreadTotal: unreadTotal)),
    );
  }

  /// Stan pierwszej strony bez gubienia kursora, gdy strona jest pusta.
  ///
  /// Backend może odfiltrować niedostępne rozmowy i zwrócić pustą stronę z
  /// `hasMore`, więc pusta strona oznacza „brak wyników na tej stronie”, a nie
  /// „brak rozmów”: kursor musi zostać, żeby użytkownik dotarł do dalszych stron.
  ChatInboxState _stateForPage(
    ChatInboxPage page, {
    required int unreadTotal,
  }) {
    if (page.items.isEmpty && !page.hasMore) {
      return ChatInboxEmpty(filter: _filter);
    }
    return ChatInboxReady(
      items: page.items,
      filter: _filter,
      unreadTotal: unreadTotal,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    );
  }
}
