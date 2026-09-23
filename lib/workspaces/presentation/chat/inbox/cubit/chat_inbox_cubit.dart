import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prowadzi skrzynkę rozmów: filtr, kursor i serwerowy licznik nieprzeczytanych.
///
/// Cubit nie zna widgetów, nawigacji ani transakcji wiadomości. Fraza trafia
/// do backendu, aby szukać rozmów ze wszystkich stron z zachowaniem ACL.
final class ChatInboxCubit extends Cubit<ChatInboxState> {
  /// Tworzy cubit na porcie skrzynki.
  ChatInboxCubit({
    required this._repository,
    this.pageSize = 30,
    this.signalCoalesceWindow = const Duration(milliseconds: 400),
  }) : super(const ChatInboxLoading());

  final ChatInboxRepository _repository;

  /// Rozmiar strony wysyłany do backendu.
  final int pageSize;

  /// Scala realtime invalidations into a bounded number of REST refreshes.
  final Duration signalCoalesceWindow;
  Timer? _signalRefreshTimer;

  ChatInboxFilter _filter = ChatInboxFilter.all;
  String? _query;

  /// Bieżący filtr skrzynki.
  ChatInboxFilter get filter => _filter;

  /// Bieżąca fraza serwerowego wyszukiwania (minimum dwa znaki).
  String? get query => _query;

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

  /// Zmienia frazę i pobiera wyniki od pierwszej strony.
  Future<void> setQuery(String? query) async {
    final normalized = query?.trim();
    final next = normalized == null || normalized.length < 2
        ? null
        : normalized;
    if (_query == next) return;
    _query = next;
    await _loadFirstPage();
  }

  /// Odświeża pierwszą stronę, zachowując bieżący filtr i frazę.
  Future<void> refresh() => _loadFirstPage(preserveReadyState: true);

  /// Schedules one refresh for a burst of new-message/membership events.
  void applySignal() {
    if (isClosed || (_signalRefreshTimer?.isActive ?? false)) return;
    _signalRefreshTimer = Timer(signalCoalesceWindow, () {
      _signalRefreshTimer = null;
      unawaited(refresh());
    });
  }

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
      query: _query,
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

  Future<void> _loadFirstPage({bool preserveReadyState = false}) async {
    final requestId = ++_requestId;
    final previous = state;
    if (!preserveReadyState || previous is! ChatInboxReady) {
      emit(const ChatInboxLoading());
    }
    // Licznik i strona idą równolegle, ale stan emitujemy raz: licznik pochodzi
    // z serwera i obejmuje wszystkie strony, nie tylko pobraną.
    final pageFuture = _repository.loadInbox(
      filter: _filter,
      limit: pageSize,
      query: _query,
    );
    final countsFuture = _repository.loadUnreadCount();
    final result = await pageFuture;
    final counts = await countsFuture;
    if (isClosed || requestId != _requestId) return;
    final unreadTotal = counts.fold(
      (error) => preserveReadyState && previous is ChatInboxReady
          ? previous.unreadTotal
          : 0,
      (value) => value.totalUnreadCount,
    );
    result.fold(
      (error) {
        if (!preserveReadyState || previous is! ChatInboxReady) {
          emit(ChatInboxFailure(error.message));
        }
      },
      (page) => emit(_stateForPage(page, unreadTotal: unreadTotal)),
    );
  }

  @override
  Future<void> close() {
    _signalRefreshTimer?.cancel();
    _signalRefreshTimer = null;
    return super.close();
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
