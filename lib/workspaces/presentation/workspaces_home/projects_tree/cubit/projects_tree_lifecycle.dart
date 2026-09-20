part of 'projects_tree_cubit.dart';

/// Kanał lifecycle jednego projektu (archiwizacja, przywrócenie, usunięcie).
final class _LifecycleChannel {
  _LifecycleChannel(this.projectId);

  /// Identyfikator projektu, którego dotyczy kanał.
  final String projectId;

  /// Czy operacja lifecycle jest w locie.
  bool busy = false;

  /// Rewizja operacji — pozwala pominąć rollback, gdy użytkownik zdążył
  /// wykonać kolejną operację na tym samym projekcie.
  int revision = 0;
}

/// Jedna rozpoczęta operacja lifecycle wraz z danymi potrzebnymi do rollbacku.
final class _LifecycleAttempt {
  const _LifecycleAttempt({
    required this.operation,
    required this.project,
    required this.previousStage,
    required this.revision,
    required this.channel,
  });

  final ProjectsTreeOperation operation;
  final ProjectListItem project;
  final _ProjectStage previousStage;
  final int revision;
  final _LifecycleChannel channel;

  String get projectId => project.id;
}

/// Archiwizacja, przywrócenie i trwałe usunięcie projektu.
///
/// Operacje są optymistyczne: projekt natychmiast zmienia miejsce w drzewie, a
/// niepowodzenie przywraca dokładny poprzedni stan i zostawia trwały komunikat.
final class _LifecycleController {
  _LifecycleController(this._host);

  final _TreeCommandHost _host;
  final Map<String, _LifecycleChannel> _channels =
      <String, _LifecycleChannel>{};

  /// Identyfikatory projektów z operacją lifecycle w locie.
  Set<String> get pendingProjectIds => <String>{
    for (final entry in _channels.entries)
      if (entry.value.busy) entry.key,
  };

  /// Usuwa kanał projektu po trwałym usunięciu.
  void forget(String projectId) => _channels.remove(projectId);

  /// Czy projekt ma operację lifecycle w locie.
  bool hasPendingLifecycle(String projectId) =>
      _channels[projectId]?.busy ?? false;

  /// Archiwizuje projekt i przenosi go do sekcji `Archiwum`.
  void archive(ProjectListItem project) {
    final attempt = _begin(project, ProjectsTreeOperation.archive);
    final repository = _host.mutations;
    if (attempt == null || repository == null) return;
    finishArchived(attempt, _ProjectStage.archived);

    unawaited(
      () async {
        final result = await repository.archiveProject(
          workspaceId: _host.workspaceId,
          projectId: attempt.projectId,
          // Wersja z ostatniego odczytu: konflikt w drugiej sesji zwraca 409
          // i nie nadpisuje cudzej zmiany.
          expectedVersion: attempt.project.version,
        );
        if (_host.isClosed) return;
        attempt.channel.busy = false;
        result.fold(
          (error) => _rollback(attempt, error),
          (archived) {
            _host.model
              ..applyLifecycleResponse(archived)
              ..applyStage(attempt.projectId, _ProjectStage.archived);
            _host.raiseNotice(
              ProjectsTreeNoticeKind.archived,
              projectId: attempt.projectId,
              projectName: attempt.project.name,
              canUndo: true,
            );
          },
        );
        _host.emitTreeState();
      }(),
    );
  }

  /// Przywraca zarchiwizowany projekt do aktywnego drzewa.
  void restore(ProjectListItem project) {
    final attempt = _begin(project, ProjectsTreeOperation.restore);
    final repository = _host.mutations;
    if (attempt == null || repository == null) return;
    finishArchived(attempt, _ProjectStage.visible);

    unawaited(
      () async {
        final result = await repository.restoreProject(
          workspaceId: _host.workspaceId,
          projectId: attempt.projectId,
          expectedVersion: attempt.project.version,
        );
        if (_host.isClosed) return;
        attempt.channel.busy = false;
        result.fold(
          (error) => _rollback(attempt, error),
          (restored) {
            _host.model
              ..applyLifecycleResponse(restored)
              ..applyStage(attempt.projectId, _ProjectStage.visible);
            _host.raiseNotice(
              ProjectsTreeNoticeKind.restored,
              projectId: attempt.projectId,
              projectName: attempt.project.name,
            );
          },
        );
        _host.emitTreeState();
      }(),
    );
  }

  /// Trwale usuwa zarchiwizowany projekt.
  ///
  /// Dostępne wyłącznie z sekcji `Archiwum` i po potwierdzeniu nazwy w warstwie
  /// prezentacji.
  void deletePermanently(ProjectListItem project) {
    final attempt = _begin(project, ProjectsTreeOperation.deletePermanently);
    final repository = _host.mutations;
    if (attempt == null || repository == null) return;

    unawaited(
      () async {
        final result = await repository.deleteProject(
          workspaceId: _host.workspaceId,
          projectId: attempt.projectId,
        );
        if (_host.isClosed) return;
        attempt.channel.busy = false;
        result.fold(
          (error) => _rollback(attempt, error),
          (_) {
            _host.model.forget(attempt.projectId);
            _host.forgetProject(attempt.projectId);
            _host.raiseNotice(
              ProjectsTreeNoticeKind.deleted,
              projectId: attempt.projectId,
              projectName: attempt.project.name,
            );
          },
        );
        _host.emitTreeState();
      }(),
    );
  }

  /// Opuszcza jawne członkostwo projektu.
  ///
  /// Zwraca `true` tylko po potwierdzeniu przez serwer, żeby wołający mógł
  /// odświeżyć listę projektu, którego widoczność mogła się zmienić. Stan
  /// drzewa nie zmienia się przed odpowiedzią: projekt Shared może pozostać
  /// widoczny przez dziedziczenie dostępu workspace.
  Future<bool> leave(ProjectListItem project) async {
    final current = _host.model.resolve(project);
    if (!_host.requireMutations(ProjectsTreeOperation.leaveMembership)) {
      return false;
    }
    final repository = _host.mutations!;
    final channel = _channels.putIfAbsent(
      current.id,
      () => _LifecycleChannel(current.id),
    );
    if (channel.busy) return false;
    channel.busy = true;
    channel.revision++;

    final result = await repository.leaveProject(
      workspaceId: _host.workspaceId,
      projectId: current.id,
    );
    if (_host.isClosed) return false;
    channel.busy = false;
    return result.fold(
      (error) {
        _host.raiseFailure(
          operation: ProjectsTreeOperation.leaveMembership,
          kind: _host.kindFor(error),
          rolledBack: false,
          error: error,
          retry: ProjectsRetryIntent(
            operation: ProjectsTreeOperation.leaveMembership,
            projectId: current.id,
          ),
        );
        return false;
      },
      (_) {
        _host.raiseNotice(
          ProjectsTreeNoticeKind.left,
          projectId: current.id,
          projectName: current.name,
        );
        return true;
      },
    );
  }

  /// Nakłada lokalny skutek operacji przed odpowiedzią serwera.
  void finishArchived(_LifecycleAttempt attempt, _ProjectStage stage) {
    _host.model.applyStage(attempt.projectId, stage);
    _host.emitTreeState();
  }

  /// Wspólny początek operacji lifecycle: walidacja portu i serializacja.
  ///
  /// Zwraca `null`, gdy port mutacji nie istnieje albo projekt ma już operację
  /// w locie (jedna mutacja na zasób).
  _LifecycleAttempt? _begin(
    ProjectListItem project,
    ProjectsTreeOperation operation,
  ) {
    final current = _host.model.resolve(project);
    if (!_host.requireMutations(operation)) return null;
    final channel = _channels.putIfAbsent(
      current.id,
      () => _LifecycleChannel(current.id),
    );
    if (channel.busy) return null;
    channel.busy = true;
    channel.revision++;
    return _LifecycleAttempt(
      operation: operation,
      project: current,
      previousStage: _host.model.stageOf(current.id),
      revision: channel.revision,
      channel: channel,
    );
  }

  void _rollback(_LifecycleAttempt attempt, ApiError error) {
    final rolledBack = attempt.revision == attempt.channel.revision;
    if (rolledBack) {
      _host.model.applyStage(attempt.projectId, attempt.previousStage);
    }
    _host.raiseFailure(
      operation: attempt.operation,
      kind: _host.kindFor(error),
      rolledBack: rolledBack,
      error: error,
      retry: ProjectsRetryIntent(
        operation: attempt.operation,
        projectId: attempt.projectId,
      ),
    );
  }
}
