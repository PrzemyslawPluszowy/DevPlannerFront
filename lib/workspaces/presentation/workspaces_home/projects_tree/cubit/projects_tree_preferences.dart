part of 'projects_tree_cubit.dart';

/// Kanał preferencji jednego projektu.
///
/// Serializuje przypięcie i ukrycie: żądanie w locie jest jedno, a kolejne
/// intencje użytkownika są scalane do ostatniej wartości docelowej. Rewizje pól
/// pozwalają cofnąć wyłącznie to, czego dotyczyła nieudana operacja — bez
/// kasowania późniejszych decyzji użytkownika.
final class _PreferenceChannel {
  _PreferenceChannel({
    required this.projectId,
    required bool isPinned,
    required bool isHidden,
  }) : confirmedPinned = isPinned,
       confirmedHidden = isHidden;

  /// Identyfikator projektu, którego dotyczy kanał.
  final String projectId;

  /// Ostatnia wartość przypięcia potwierdzona przez serwer.
  bool confirmedPinned;

  /// Ostatnia wartość ukrycia potwierdzona przez serwer.
  bool confirmedHidden;

  /// Wersja preferencji z ostatniej odpowiedzi serwera.
  ///
  /// Backend porównuje ją z `xmin` preferencji, więc wysyłamy ją dopiero wtedy,
  /// gdy faktycznie ją znamy — inaczej pierwszy zapis w sesji nie miałby czego
  /// porównać.
  int? confirmedVersion;

  /// Docelowe przypięcie oczekujące na wysłanie; `null`, gdy brak intencji.
  bool? pendingPinned;

  /// Docelowe ukrycie oczekujące na wysłanie; `null`, gdy brak intencji.
  bool? pendingHidden;

  /// Rewizja pola przypięcia — rośnie przy każdej lokalnej zmianie użytkownika.
  int pinnedRevision = 0;

  /// Rewizja pola ukrycia — rośnie przy każdej lokalnej zmianie użytkownika.
  int hiddenRevision = 0;

  /// Pozycja w drzewie sprzed pierwszej intencji przypięcia w bieżącej serii.
  int? pinnedIndexBeforeBatch;

  /// Czy żądanie tego kanału jest w locie.
  bool inFlight = false;

  /// Czy kanał ma cokolwiek do wysłania albo czeka na odpowiedź.
  bool get hasPending =>
      inFlight || pendingPinned != null || pendingHidden != null;

  /// Czyści intencje bez wysyłania ich (gdy zniknął port albo projekt).
  void clearPending() {
    pendingPinned = null;
    pendingHidden = null;
  }
}

/// Obsługa przypięcia i ukrycia projektu.
///
/// Najpierw zmienia model lokalnie, potem wysyła jedno żądanie na kanał.
/// Porażka cofa wyłącznie pola tej operacji, a sukces przyjmuje wartości
/// serwera dla tych pól.
final class _PreferencesController {
  _PreferencesController(this._host);

  final _TreeCommandHost _host;
  final Map<String, _PreferenceChannel> _channels =
      <String, _PreferenceChannel>{};

  /// Identyfikatory projektów z mutacją w locie albo w kolejce.
  Set<String> get pendingProjectIds => <String>{
    for (final entry in _channels.entries)
      if (entry.value.hasPending) entry.key,
  };

  /// Usuwa kanał projektu (np. po trwałym usunięciu).
  void forget(String projectId) => _channels.remove(projectId);

  /// Czy projekt ma intencję preferencji w locie albo w kolejce.
  bool hasPendingPreference(String projectId) =>
      _channels[projectId]?.hasPending ?? false;

  /// Przyjmuje wartości serwera jako potwierdzone dla projektu bez intencji.
  ///
  /// [isHidden] pochodzi z listy serwera: lista zwracana przez backend dla
  /// filtra `visible` nie zawiera projektów ukrytych, więc potwierdzona wartość
  /// ukrycia dla projektu z takiej listy to `false`.
  void syncConfirmed(ProjectListItem project, {bool isHidden = false}) {
    final channel = _channels[project.id];
    if (channel == null || channel.hasPending) return;
    channel.confirmedPinned = project.isPinned;
    channel.confirmedHidden = isHidden;
  }

  /// Przypina albo odpina projekt.
  void setPinned(ProjectListItem project, {required bool isPinned}) {
    final model = _host.model;
    final current = model.resolve(project);
    if (!_host.requireMutations(ProjectsTreeOperation.pin)) return;
    final channel = _channelFor(current);
    if (channel.pendingPinned == null && !channel.inFlight) {
      // Pozycja sprzed pierwszego przypięcia w tej serii — rollback wraca
      // dokładnie tam, a nie na koniec listy.
      channel.pinnedIndexBeforeBatch = model.order.indexOf(current.id);
    }
    channel.pinnedRevision++;
    channel.pendingPinned = isPinned;
    model.applyPinnedLocally(current.id, isPinned: isPinned);
    _host.emitTreeState();
    unawaited(_drain(channel));
  }

  /// Ukrywa projekt w drzewie albo przywraca go do drzewa.
  void setHidden(ProjectListItem project, {required bool isHidden}) {
    final model = _host.model;
    final current = model.resolve(project);
    if (!_host.requireMutations(ProjectsTreeOperation.hide)) return;
    final channel = _channelFor(current);
    channel.hiddenRevision++;
    channel.pendingHidden = isHidden;
    model.applyHidden(current.id, hidden: isHidden);
    _host.emitTreeState();
    unawaited(_drain(channel));
  }

  /// Ponawia intencję preferencji po nieudanej operacji.
  ///
  /// Operacja `pin` albo `hide` niesie dokładnie jedno pole docelowe; dla
  /// scalonego żądania `preference` odtwarzamy oba.
  void retry(ProjectsRetryIntent intent) {
    final projectId = intent.projectId;
    final project = projectId == null ? null : _host.model.known[projectId];
    if (project == null) return;
    if (intent.targetPinned case final target?) {
      setPinned(project, isPinned: target);
    }
    if (intent.targetHidden case final target?) {
      setHidden(project, isHidden: target);
    }
  }

  _PreferenceChannel _channelFor(ProjectListItem project) =>
      _channels.putIfAbsent(
        project.id,
        () => _PreferenceChannel(
          projectId: project.id,
          isPinned: project.isPinned,
          isHidden: _host.model.hiddenIds.contains(project.id),
        ),
      );

  Future<void> _drain(_PreferenceChannel channel) async {
    if (channel.inFlight) return;
    final repository = _host.mutations;
    if (repository == null) {
      channel.clearPending();
      return;
    }
    final model = _host.model;
    channel.inFlight = true;
    _host.emitTreeState();
    try {
      while (!_host.isClosed &&
          (channel.pendingPinned != null || channel.pendingHidden != null)) {
        final current = model.known[channel.projectId];
        if (current == null) {
          channel.clearPending();
          break;
        }
        final pendingPinned = channel.pendingPinned;
        final pendingHidden = channel.pendingHidden;
        final targetPinned = pendingPinned ?? current.isPinned;
        final targetHidden =
            pendingHidden ?? model.hiddenIds.contains(channel.projectId);
        final pinnedRevision = channel.pinnedRevision;
        final hiddenRevision = channel.hiddenRevision;
        channel.clearPending();

        final result = await repository.updateProjectPreference(
          workspaceId: _host.workspaceId,
          projectId: channel.projectId,
          isPinned: targetPinned,
          isHidden: targetHidden,
          expectedVersion: channel.confirmedVersion,
        );
        if (_host.isClosed) return;

        result.fold(
          (error) => _rollback(
            channel: channel,
            error: error,
            pendingPinned: pendingPinned,
            pendingHidden: pendingHidden,
            pinnedRevision: pinnedRevision,
            hiddenRevision: hiddenRevision,
          ),
          (preference) => _commit(
            channel: channel,
            isPinned: preference.isPinned,
            isHidden: preference.isHidden,
            version: preference.version,
            pendingPinned: pendingPinned,
            pendingHidden: pendingHidden,
            pinnedRevision: pinnedRevision,
            hiddenRevision: hiddenRevision,
          ),
        );
      }
    } finally {
      channel.inFlight = false;
      if (!_host.isClosed) _host.emitTreeState();
    }
  }

  void _rollback({
    required _PreferenceChannel channel,
    required ApiError error,
    required bool? pendingPinned,
    required bool? pendingHidden,
    required int pinnedRevision,
    required int hiddenRevision,
  }) {
    final model = _host.model;
    final projectId = channel.projectId;
    var rolledBack = false;

    // Wersja preferencji, którą właśnie odrzucono, jest już nieaktualna.
    // Porzucamy ją, żeby jawne ponowienie użytkownika nie kończyło się
    // wiecznym 409; komunikat o konflikcie pozostaje widoczny.
    channel.confirmedVersion = null;

    final known = model.known[projectId];
    if (pendingPinned != null &&
        channel.pinnedRevision == pinnedRevision &&
        known != null &&
        known.isPinned != channel.confirmedPinned) {
      model.applyPinnedLocally(
        projectId,
        isPinned: channel.confirmedPinned,
        restoreIndex: channel.pinnedIndexBeforeBatch,
      );
      rolledBack = true;
    }
    if (pendingHidden != null &&
        channel.hiddenRevision == hiddenRevision &&
        model.hiddenIds.contains(projectId) != channel.confirmedHidden) {
      model.applyHidden(projectId, hidden: channel.confirmedHidden);
      rolledBack = true;
    }

    final operation = pendingPinned != null && pendingHidden != null
        ? ProjectsTreeOperation.preference
        : pendingHidden != null
        ? ProjectsTreeOperation.hide
        : ProjectsTreeOperation.pin;
    _host.raiseFailure(
      operation: operation,
      kind: _host.kindFor(error),
      rolledBack: rolledBack,
      error: error,
      retry: ProjectsRetryIntent(
        operation: operation,
        projectId: projectId,
        targetPinned: pendingPinned,
        targetHidden: pendingHidden,
      ),
    );
  }

  void _commit({
    required _PreferenceChannel channel,
    required bool isPinned,
    required bool isHidden,
    required int? version,
    required bool? pendingPinned,
    required bool? pendingHidden,
    required int pinnedRevision,
    required int hiddenRevision,
  }) {
    final model = _host.model;
    channel.confirmedPinned = isPinned;
    channel.confirmedHidden = isHidden;
    channel.confirmedVersion = version ?? channel.confirmedVersion;
    final projectId = channel.projectId;
    if (channel.pinnedRevision == pinnedRevision) {
      final known = model.known[projectId];
      if (known != null && known.isPinned != isPinned) {
        model.applyPinnedLocally(projectId, isPinned: isPinned);
      }
    }
    if (channel.hiddenRevision == hiddenRevision &&
        model.hiddenIds.contains(projectId) != isHidden) {
      model.applyHidden(projectId, hidden: isHidden);
    }

    // Jedno potwierdzenie na żądanie: zmiana ukrycia jest istotniejsza dla
    // użytkownika, więc przykrywa potwierdzenie samego przypięcia.
    final projectName = model.known[projectId]?.name ?? '';
    if (pendingHidden != null && channel.hiddenRevision == hiddenRevision) {
      _host.raiseNotice(
        isHidden
            ? ProjectsTreeNoticeKind.hidden
            : ProjectsTreeNoticeKind.unhidden,
        projectId: projectId,
        projectName: projectName,
        canUndo: isHidden,
      );
    } else if (pendingPinned != null &&
        channel.pinnedRevision == pinnedRevision) {
      _host.raiseNotice(
        isPinned
            ? ProjectsTreeNoticeKind.pinned
            : ProjectsTreeNoticeKind.unpinned,
        projectId: projectId,
        projectName: projectName,
      );
    }
  }
}
