import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/shared/users_search/cubit/inventory_users_search_state.dart';
import 'package:rxdart/rxdart.dart';

/// Cubit obslugujacy wyszukiwarke uzytkownikow w module inwentaryzacji.
class InventoryUsersSearchCubit extends Cubit<InventoryUsersSearchState> {
  /// Tworzy cubit wyszukiwarki uzytkownikow.
  InventoryUsersSearchCubit({
    required this._repository,
    this._debounce = const Duration(milliseconds: 500),
    this._limit = 10,
  }) : super(const InventoryUsersSearchInitial()) {
    _querySubscription = _querySubject.stream
        .map((value) => value.trim())
        .debounceTime(_debounce)
        .listen(_searchNow);
  }

  final UsersRepository _repository;
  final Duration _debounce;
  final int _limit;
  final PublishSubject<String> _querySubject = PublishSubject<String>();
  late final StreamSubscription<String> _querySubscription;
  int _requestId = 0;

  /// Przyjmuje surowa fraze i odpala wyszukiwanie z debounce.
  void onQueryChanged(String rawQuery) {
    _querySubject.add(rawQuery);
  }

  /// Czyści aktualny stan wyszukiwarki i anuluje oczekujace wyniki.
  void clear() {
    _requestId++;
    emit(const InventoryUsersSearchInitial());
  }

  /// Wyszukuje uzytkownikow po przekazanej frazie.
  Future<void> _searchNow(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.length < 2) {
      emit(const InventoryUsersSearchInitial());
      return;
    }

    final requestId = ++_requestId;
    final currentResults = state.results;
    emit(InventoryUsersSearchLoading(query: query, results: currentResults));

    final result = await _repository.searchUsers(
      search: query,
      limit: _limit,
      forceRefresh: true,
    );
    if (requestId != _requestId) {
      return;
    }

    result.fold(
      (error) => emit(
        InventoryUsersSearchError(
          message: error.message,
          query: query,
          results: currentResults,
        ),
      ),
      (users) => emit(InventoryUsersSearchLoaded(query: query, results: users)),
    );
  }

  @override
  Future<void> close() async {
    await _querySubscription.cancel();
    await _querySubject.close();
    return super.close();
  }
}
