import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';

/// Kontrakt repozytorium wyszukiwarki uzytkownikow.
abstract interface class UsersRepository {
  /// Wyszukuje uzytkownikow po fragmencie tekstu.
  Future<Either<ApiError, List<GetReadyUsersSearchItem>>> searchUsers({
    required String search,
    int limit = 20,
    int offset = 0,
    bool includeInactive = false,
    bool forceRefresh = false,
  });

  /// Czyści cache wynikow wyszukiwarki.
  void invalidateUsersSearchCache();
}

/// Implementacja repozytorium wyszukiwarki uzytkownikow oparta o Retrofit.
class UsersRepositoryImpl extends ApiRepository implements UsersRepository {
  /// Tworzy repozytorium z klientem API inwentaryzacji.
  UsersRepositoryImpl({required this._api});

  final InventoryApi _api;
  final Map<String, List<GetReadyUsersSearchItem>> _searchCache = {};

  @override
  Future<Either<ApiError, List<GetReadyUsersSearchItem>>> searchUsers({
    required String search,
    int limit = 20,
    int offset = 0,
    bool includeInactive = false,
    bool forceRefresh = false,
  }) async {
    final normalized = search.trim();
    if (normalized.length < 2) {
      return const Right([]);
    }

    final cacheKey = '$normalized|$limit|$offset|$includeInactive';
    final cached = _searchCache[cacheKey];
    if (!forceRefresh && cached != null) {
      return Right(cached);
    }

    return guardApiCall(
      () async {
        final response = await _api.searchReadyUsers(
          q: normalized,
          limit: limit,
          offset: offset,
          includeInactive: includeInactive,
        );
        final data = List<GetReadyUsersSearchItem>.unmodifiable(response.data);
        _searchCache[cacheKey] = data;
        return data;
      },
      fallbackMessage: 'Nie udało się wyszukać użytkowników.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane wyszukiwarki użytkowników.',
    );
  }

  @override
  void invalidateUsersSearchCache() {
    _searchCache.clear();
  }
}
