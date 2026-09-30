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
    this.retryAfterUtc,
    this.retryWaitSeconds = 0,
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

  /// Termin ponowienia zwrócony przez backend.
  final DateTime? retryAfterUtc;
  final int retryWaitSeconds;

  /// Czy fraza jest za krótka, żeby pytać backend.
  bool isTermTooShort(int minimum) => term.trim().length < minimum;

  /// Czy fraza przekracza maksymalną długość parametru Backend.
  bool isTermTooLong(int maximum) => term.trim().length > maximum;

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
    DateTime? retryAfterUtc,
    int? retryWaitSeconds,
    bool clearFailure = false,
    bool clearRetryAfter = false,
  }) => ChatSearchState(
    term: term ?? this.term,
    page: page ?? this.page,
    facets: facets ?? this.facets,
    isSearching: isSearching ?? this.isSearching,
    failureCode: clearFailure ? null : failureCode ?? this.failureCode,
    failureStatus: clearFailure ? null : failureStatus ?? this.failureStatus,
    retryAfterUtc: clearRetryAfter ? null : retryAfterUtc ?? this.retryAfterUtc,
    retryWaitSeconds: clearRetryAfter
        ? 0
        : retryWaitSeconds ?? this.retryWaitSeconds,
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
    int maximumTermLength = 160,
    int limit = 30,
  }) : this._(
         repository,
         debounce,
         minimumTermLength,
         maximumTermLength,
         limit,
       );

  ChatSearchCubit._(
    this._repository,
    this.debounce,
    this.minimumTermLength,
    this.maximumTermLength,
    this.limit,
  ) : super(const ChatSearchState());

  final ChatSearchRepository _repository;

  /// Opóźnienie przed zapytaniem do backendu.
  final Duration debounce;

  /// Minimalna długość frazy zgodna z kontraktem backendu.
  final int minimumTermLength;

  /// Maksymalna długość frazy zgodna z kontraktem backendowego API.
  final int maximumTermLength;

  /// Liczba wyników na stronę.
  final int limit;

  Timer? _timer;
  Timer? _retryCooldownTimer;
  int _requestId = 0;

  /// Otwiera widok wyszukiwania bez zmiany trasy ani stanu rozmowy.
  void open() => emit(
    state.copyWith(
      isOpen: true,
      clearFailure: state.retryWaitSeconds == 0,
    ),
  );

  /// Zamyka widok wyszukiwania i czyści wyniki.
  void closeView() {
    _timer?.cancel();
    _retryCooldownTimer?.cancel();
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
    final trimmedLength = value.trim().length;
    final shouldSearch =
        trimmedLength >= minimumTermLength &&
        trimmedLength <= maximumTermLength;
    final isCoolingDown = state.retryWaitSeconds > 0;
    emit(
      ChatSearchState(
        term: value,
        isOpen: state.isOpen,
        isSearching: shouldSearch && !isCoolingDown,
        failureCode: isCoolingDown
            ? state.failureCode ?? 'chat.search.failed'
            : null,
        failureStatus: isCoolingDown ? 429 : null,
        retryAfterUtc: isCoolingDown ? state.retryAfterUtc : null,
        retryWaitSeconds: isCoolingDown ? state.retryWaitSeconds : 0,
      ),
    );
    if (!shouldSearch || isCoolingDown) {
      return;
    }
    _timer = Timer(debounce, () => unawaited(_search(value, withFacets: true)));
  }

  /// Ponawia ostatnie zapytanie bez czekania na debounce.
  Future<void> retry() {
    if (state.retryWaitSeconds > 0 ||
        state.isTermTooShort(minimumTermLength) ||
        state.isTermTooLong(maximumTermLength)) {
      return Future<void>.value();
    }
    return _search(state.term, withFacets: true);
  }

  /// Dociąga kolejną stronę wyników kursorem backendu.
  Future<void> loadMore() async {
    final cursor = state.page?.nextCursor;
    if (cursor == null || state.isSearching) return;
    await _search(state.term, cursor: cursor);
  }

  /// Czyści wyniki wyszukiwania i wraca do listy rozmów.
  void clear() {
    _timer?.cancel();
    _retryCooldownTimer?.cancel();
    _requestId++;
    emit(const ChatSearchState());
  }

  Future<void> _search(
    String value, {
    String? cursor,
    bool withFacets = false,
  }) async {
    if (state.retryWaitSeconds > 0 ||
        value.trim().length < minimumTermLength ||
        value.trim().length > maximumTermLength) {
      return;
    }
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
          retryAfterUtc: error.retryAfterUtc,
          retryWaitSeconds: error.retryAfterUtc == null
              ? 0
              : _secondsUntil(error.retryAfterUtc!),
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
    final retryAt = state.retryAfterUtc;
    if (state.failureStatus == 429 && retryAt != null) {
      _startRetryCooldown(retryAt);
    }
    if (!withFacets || isClosed) return;
    final facets = await _repository.loadFacets(term: value.trim());
    if (requestId != _requestId || isClosed) return;
    facets.fold((_) {}, (value) => emit(state.copyWith(facets: value)));
  }

  void _startRetryCooldown(DateTime retryAtUtc) {
    _retryCooldownTimer?.cancel();
    if (!retryAtUtc.isAfter(DateTime.now().toUtc())) return;
    _retryCooldownTimer = Timer.periodic(
      const Duration(milliseconds: 250),
      (timer) {
        if (isClosed) {
          timer.cancel();
          return;
        }
        final remaining = _secondsUntil(retryAtUtc);
        if (remaining == 0) {
          timer.cancel();
          emit(state.copyWith(clearRetryAfter: true));
        } else if (remaining != state.retryWaitSeconds) {
          emit(state.copyWith(retryWaitSeconds: remaining));
        }
      },
    );
  }

  int _secondsUntil(DateTime retryAtUtc) {
    final milliseconds = retryAtUtc
        .difference(DateTime.now().toUtc())
        .inMilliseconds;
    return milliseconds <= 0 ? 0 : (milliseconds / 1000).ceil();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _retryCooldownTimer?.cancel();
    return super.close();
  }
}
