import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan wyszukiwania w lokalnym katalogu kont.
class ChatDirectorySearchState {
  /// Tworzy stan wyszukiwania.
  const ChatDirectorySearchState({
    this.query = '',
    this.results = const <ChatDirectoryEntry>[],
    this.isSearching = false,
    this.failureCode,
  });

  final String query;
  final List<ChatDirectoryEntry> results;
  final bool isSearching;

  /// Kod domenowy błędu wyszukiwania; UI mapuje go na tekst.
  final String? failureCode;

  /// Czy fraza jest za krótka, żeby pytać backend.
  bool get isQueryTooShort => query.trim().length < minQueryLength;

  /// Czy pokazać stan pusty po zakończonym wyszukiwaniu.
  bool get isEmpty =>
      !isSearching &&
      failureCode == null &&
      !isQueryTooShort &&
      results.isEmpty;

  /// Minimalna długość frazy wymagana przez backend.
  static const int minQueryLength = 2;
}

/// Wyszukuje kandydatów w lokalnym katalogu bez pytań do UI.
///
/// Cubit debounce'uje frazę i nie pyta backendu o frazę krótszą niż dwa znaki,
/// bo taki kontrakt katalogu nie zwraca niczego sensownego i tylko generowałby
/// błędy walidacji.
final class ChatDirectorySearchCubit extends Cubit<ChatDirectorySearchState> {
  /// Tworzy cubit na porcie katalogu.
  ChatDirectorySearchCubit({
    required ChatDirectoryRepository repository,
    Duration debounce = const Duration(milliseconds: 300),
    int limit = 20,
  }) : this._(repository, debounce, limit);

  ChatDirectorySearchCubit._(this._repository, this.debounce, this.limit)
    : super(const ChatDirectorySearchState());

  final ChatDirectoryRepository _repository;

  /// Opóźnienie przed zapytaniem do backendu.
  final Duration debounce;

  /// Maksymalna liczba kandydatów w jednej odpowiedzi.
  final int limit;

  Timer? _timer;
  int _requestId = 0;

  /// Ustawia frazę i planuje zapytanie po debounce.
  void updateQuery(String value) {
    _timer?.cancel();
    // Unieważnia także żądanie już wysłane. Jego odpowiedź nie może wrócić do
    // nowej frazy w trakcie debounce i pokazać osób znalezionych dla starego
    // zapytania.
    _requestId++;
    final shouldSearch =
        value.trim().length >= ChatDirectorySearchState.minQueryLength;
    emit(
      ChatDirectorySearchState(
        query: value,
        isSearching: shouldSearch,
      ),
    );
    if (state.isQueryTooShort) return;
    _timer = Timer(debounce, () => unawaited(_search(value)));
  }

  /// Ponawia ostatnie zapytanie bez czekania na debounce.
  Future<void> retry() {
    _timer?.cancel();
    return _search(state.query);
  }

  /// Czyści wyniki bez czekania na debounce.
  void clear() {
    _timer?.cancel();
    _requestId++;
    emit(const ChatDirectorySearchState());
  }

  Future<void> _search(String value) async {
    final requestId = ++_requestId;
    emit(
      ChatDirectorySearchState(
        query: value,
        results: state.results,
        isSearching: true,
      ),
    );
    final result = await _repository.search(term: value.trim(), limit: limit);
    // Późniejsza odpowiedź starszego zapytania nie może nadpisać nowszej frazy.
    if (requestId != _requestId || isClosed) return;
    result.fold(
      (error) => emit(
        ChatDirectorySearchState(
          query: value,
          failureCode: error.apiCode ?? error.message,
        ),
      ),
      (entries) => emit(
        ChatDirectorySearchState(query: value, results: entries),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
