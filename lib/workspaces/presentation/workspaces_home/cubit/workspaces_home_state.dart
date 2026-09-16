import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';

/// Bazowy stan ekranu startowego Workspaces.
sealed class WorkspacesHomeState {
  const WorkspacesHomeState();
}

/// Stan początkowy przed pierwszym żądaniem.
final class WorkspacesHomeInitial extends WorkspacesHomeState {
  const WorkspacesHomeInitial();
}

/// Stan ładowania listy workspace’ów.
final class WorkspacesHomeLoading extends WorkspacesHomeState {
  const WorkspacesHomeLoading();
}

/// Stan poprawnie pobranej listy workspace’ów.
final class WorkspacesHomeLoaded extends WorkspacesHomeState {
  const WorkspacesHomeLoaded(
    this.items, {
    this.hiddenItems = const [],
    this.searchQuery = '',
  });

  /// Elementy posortowane przez backend według preferencji użytkownika.
  final List<WorkspaceListItem> items;

  /// Ukryte workspace’y dostępne do przywrócenia z katalogu preferencji.
  final List<WorkspaceListItem> hiddenItems;

  /// Aktualna fraza wyszukiwania.
  final String searchQuery;

  /// Przefiltrowane widoczne elementy na podstawie frazy wyszukiwania.
  List<WorkspaceListItem> get filteredItems {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items
        .where((item) {
          final nameMatches = item.name.toLowerCase().contains(query);
          final descMatches =
              item.description?.toLowerCase().contains(query) ?? false;
          return nameMatches || descMatches;
        })
        .toList(growable: false);
  }
}

/// Stan poprawnej odpowiedzi bez workspace’ów.
final class WorkspacesHomeEmpty extends WorkspacesHomeState {
  const WorkspacesHomeEmpty();
}

/// Stan braku dostępu zwróconego przez backend.
final class WorkspacesHomeForbidden extends WorkspacesHomeState {
  const WorkspacesHomeForbidden({required this.message, this.backendCode});

  /// Komunikat backendu przeznaczony do wyświetlenia użytkownikowi.
  final String message;

  /// Kod błędu backendu, jeżeli został zwrócony.
  final String? backendCode;
}

/// Stan nieprawidłowej lub wygasłej sesji użytkownika.
final class WorkspacesHomeUnauthorized extends WorkspacesHomeState {
  const WorkspacesHomeUnauthorized({required this.message, this.backendCode});

  /// Komunikat backendu przeznaczony do wyświetlenia użytkownikowi.
  final String message;

  /// Kod błędu backendu, jeżeli został zwrócony.
  final String? backendCode;
}

/// Stan błędu z komunikatem pochodzącym z repository/backendu.
final class WorkspacesHomeFailure extends WorkspacesHomeState {
  const WorkspacesHomeFailure({required this.message, this.backendCode});

  /// Komunikat przeznaczony do wyświetlenia użytkownikowi.
  final String message;

  /// Stabilny kod błędu backendu, jeżeli został zwrócony.
  final String? backendCode;
}
