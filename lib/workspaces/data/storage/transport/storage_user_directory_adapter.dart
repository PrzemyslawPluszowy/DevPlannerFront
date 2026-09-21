import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';

/// Adapter lokalnego katalogu użytkowników dla modułu Pliki.
///
/// Nie tworzy własnego klienta HTTP: korzysta z repozytorium Workspaces
/// złożonego przez composition root, więc zakres wyszukiwania i reguły błędów
/// są dokładnie te same co w ustawieniach workspace'u.
final class StorageUserDirectoryAdapter implements StorageUserDirectoryPort {
  /// Tworzy adapter nad repozytorium Workspaces.
  const StorageUserDirectoryAdapter(this._repository);

  final WorkspacesRepository _repository;

  @override
  Future<Either<ApiError, List<LocalUserDirectoryResponse>>> search({
    required String workspaceId,
    required String query,
  }) => _repository.searchLocalUsers(workspaceId: workspaceId, query: query);
}
