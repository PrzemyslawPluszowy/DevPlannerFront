import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan wyszukiwania wiadomości w panelu Chat.
class ChatSearchState {
  /// Tworzy stan wyszukiwania.
  const ChatSearchState({
    this.term = '',
    this.page,
    this.facets,
    this.isSearching = false,
    this.failureCode,
    this.failureStatus,
    this.isOpen = false,
  });

  final String term;

  /// Czy panel pokazuje widok wyszukiwania zamiast listy rozmów.
  final bool isOpen;

  /// Wyniki bieżącej strony wyszukiwania.
  final ChatSearchPage? page;

  /// Agregaty pokazujące, gdzie szukać dalej.
  final ChatSearchFacets? facets;
  final bool isSearching;

  /// Kod domenowy błędu; UI mapuje go na tekst przez ARB.
  final String? failureCode;

  /// Kod HTTP, żeby UI mogło rozpoznać `429` i respektować `Retry-After`.
  final int? failureStatus;

  /// Czy fraza jest za krótka, żeby pytać backend.
  bool isTermTooShort(int minimum) => term.trim().length < minimum;

  /// Czy pokazać stan pusty po zakończonym wyszukiwaniu.
  bool get isEmpty =>
      !isSearching &&
      failureCode == null &&
      page != null &&
      (page?.hits.isEmpty ?? true);

  /// Czy wyszukiwanie zostało ograniczone stawką (`429`).
  bool get isRateLimited => failureStatus == 429;

  /// Tworzy kopię stanu z nowymi wartościami.
  ChatSearchState copyWith({
    String? term,
    bool? isOpen,
    ChatSearchPage? page,
    ChatSearchFacets? facets,
    bool? isSearching,
    String? failureCode,
    int? failureStatus,
    bool clearFailure = false,
  }) => ChatSearchState(
    term: term ?? this.term,
    page: page ?? this.page,
    facets: facets ?? this.facets,
    isSearching: isSearching ?? this.isSearching,
    failureCode: clearFailure ? null : failureCode ?? this.failureCode,
    failureStatus: clearFailure ? null : failureStatus ?? this.failureStatus,
    isOpen: isOpen ?? this.isOpen,
  );
}

/// Wyszukuje wiadomości w rozmowach dostępnych dla bieżącego użytkownika.
///
/// Cubit zna wyłącznie port wyszukiwania: nie otwiera rozmów ani nie przewija
/// widoku. Wynik przekazuje jako dane, a panel decyduje o skoku do wiadomości.
/// Minimalna długość frazy i stawka pochodzą z backendu, więc UI ich nie zgaduje.
final class ChatSearchCubit extends Cubit<ChatSearchState> {
  /// Tworzy cubit na porcie wyszukiwania.
  ChatSearchCubit({
    required ChatSearchRepository repository,
    Duration debounce = const Duration(milliseconds: 300),
    int minimumTermLength = 2,
    int limit = 30,
  }) : this._(repository, debounce, minimumTermLength, limit);

  ChatSearchCubit._(
    this._repository,
    this.debounce,
    this.minimumTermLength,
    this.limit,
  ) : super(const ChatSearchState());

  final ChatSearchRepository _repository;

  /// Opóźnienie przed zapytaniem do backendu.
  final Duration debounce;

  /// Minimalna długość frazy zgodna z kontraktem backendu.
  final int minimumTermLength;

  /// Liczba wyników na stronę.
  final int limit;

  Timer? _timer;
  int _requestId = 0;

  /// Otwiera widok wyszukiwania bez zmiany trasy ani stanu rozmowy.
  void open() => emit(state.copyWith(isOpen: true, clearFailure: true));

  /// Zamyka widok wyszukiwania i czyści wyniki.
  void closeView() {
    _timer?.cancel();
    _requestId++;
    emit(const ChatSearchState());
  }

  /// Ustawia frazę i planuje zapytanie po debounce.
  void updateTerm(String value) {
    _timer?.cancel();
    // Każda zmiana frazy unieważnia stronę i odpowiedzi zapytań, które już
    // trwają. Bez tego stary wynik może pojawić się pod nową frazą podczas
    // debounce albo nadpisać jej rezultat.
    _requestId++;
    final shouldSearch = value.trim().length >= minimumTermLength;
    emit(
      ChatSearchState(
        term: value,
        isOpen: state.isOpen,
        isSearching: shouldSearch,
      ),
    );
    if (!shouldSearch) {
      return;
    }
    _timer = Timer(debounce, () => unawaited(_search(value, withFacets: true)));
  }

  /// Ponawia ostatnie zapytanie bez czekania na debounce.
  Future<void> retry() => _search(state.term, withFacets: true);

  /// Dociąga kolejną stronę wyników kursorem backendu.
  Future<void> loadMore() async {
    final cursor = state.page?.nextCursor;
    if (cursor == null || state.isSearching) return;
    await _search(state.term, cursor: cursor);
  }

  /// Czyści wyniki wyszukiwania i wraca do listy rozmów.
  void clear() {
    _timer?.cancel();
    _requestId++;
    emit(const ChatSearchState());
  }

  Future<void> _search(
    String value, {
    String? cursor,
    bool withFacets = false,
  }) async {
    final requestId = ++_requestId;
    emit(state.copyWith(isSearching: true, clearFailure: true));
    final result = await _repository.searchMessages(
      ChatSearchQuery(term: value.trim(), cursor: cursor, limit: limit),
    );
    // Późniejsza odpowiedź starszego zapytania nie może nadpisać nowszej frazy.
    if (requestId != _requestId || isClosed) return;
    await result.fold(
      (error) async => emit(
        state.copyWith(
          isSearching: false,
          failureCode: error.apiCode ?? error.message,
          failureStatus: error.statusCode,
        ),
      ),
      (page) async {
        final merged = cursor == null || state.page == null
            ? page
            : ChatSearchPage(
                hits: <ChatSearchHit>[...state.page!.hits, ...page.hits],
                nextCursor: page.nextCursor,
                totalApproximate: page.totalApproximate,
              );
        emit(state.copyWith(page: merged, isSearching: false));
      },
    );
    if (!withFacets || isClosed) return;
    final facets = await _repository.loadFacets(term: value.trim());
    if (requestId != _requestId || isClosed) return;
    facets.fold((_) {}, (value) => emit(state.copyWith(facets: value)));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
