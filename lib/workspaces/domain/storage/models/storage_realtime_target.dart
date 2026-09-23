import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:equatable/equatable.dart';

/// Zakres kanału zmian plików odpowiadający widokowi eksploratora.
enum StorageRealtimeScopeKind { personal, workspace, project }

/// Adres subskrypcji w hubie Storage.
///
/// Hub adresuje zdarzenia zakresem, a nie folderem, więc kanał jest wspólny dla
/// wszystkich folderów danego zakresu.
final class StorageRealtimeTarget extends Equatable {
  /// Pliki prywatne wskazanego użytkownika.
  const StorageRealtimeTarget.personal(String this.ownerUserId)
    : kind = StorageRealtimeScopeKind.personal,
      workspaceId = null,
      projectId = null;

  /// Pliki jednego workspace'u.
  const StorageRealtimeTarget.workspace(String this.workspaceId)
    : kind = StorageRealtimeScopeKind.workspace,
      ownerUserId = null,
      projectId = null;

  /// Pliki jednego projektu.
  const StorageRealtimeTarget.project({
    required String this.workspaceId,
    required String this.projectId,
  }) : kind = StorageRealtimeScopeKind.project,
       ownerUserId = null;

  /// Rodzaj zakresu.
  final StorageRealtimeScopeKind kind;

  /// Właściciel plików prywatnych.
  final String? ownerUserId;

  /// Identyfikator workspace'u dla zakresu workspace'u i projektu.
  final String? workspaceId;

  /// Identyfikator projektu dla zakresu projektu.
  final String? projectId;

  /// Kanał widoku; `null`, gdy widok nie ma własnego kanału w hubie.
  ///
  /// Udostępnione, ostatnie, ulubione, kosz i zakres zasobu nie mają
  /// odpowiednika w hubie, więc zostają bez subskrypcji, zamiast podszywać się
  /// pod zakres prywatny, który pokazuje inny zbiór plików. Zakres prywatny bez
  /// znanego użytkownika również zostaje bez kanału: nie da się go zaadresować,
  /// a zgadywanie właściciela pokazałoby cudze zdarzenia.
  static StorageRealtimeTarget? forScope(
    StorageScope scope, {
    String? ownerUserId,
  }) => switch (scope) {
    StoragePersonalScope() when ownerUserId != null =>
      StorageRealtimeTarget.personal(ownerUserId),
    StorageWorkspaceScope(:final workspaceId) =>
      StorageRealtimeTarget.workspace(
        workspaceId,
      ),
    StorageProjectScope(:final workspaceId, :final projectId) =>
      StorageRealtimeTarget.project(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    _ => null,
  };

  @override
  List<Object?> get props => [kind, ownerUserId, workspaceId, projectId];
}
