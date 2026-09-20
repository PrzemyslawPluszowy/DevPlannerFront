part of 'projects_tree_cubit.dart';

/// Zapis kolejności widocznych projektów.
///
/// Backend wymaga pełnej, niepowtarzalnej listy widocznych projektów, więc
/// niepełna lista jest odrzucana lokalnie. Intencje w locie są scalane do
/// ostatniej wartości docelowej, a porażka przywraca dokładne poprzednie
/// pozycje potwierdzone przez serwer.
final class _OrderController {
  _OrderController(this._host);

  final _TreeCommandHost _host;

  int _revision = 0;
  bool _inFlight = false;
  List<String>? _pending;

  /// Czy trwa zapis kolejności.
  bool get isReordering => _inFlight;

  /// Zapisuje nową kolejność widocznych projektów.
  void reorder(List<String> orderedIds) {
    final model = _host.model;
    if (!_host.requireMutations(ProjectsTreeOperation.reorder)) return;
    if (!model.isSameIdSet(orderedIds, model.order)) {
      _host.raiseFailure(
        operation: ProjectsTreeOperation.reorder,
        kind: ProjectsTreeFailureKind.invalidIntent,
        rolledBack: false,
      );
      return;
    }
    if (_inFlight) {
      // Scalanie intencji: wysyłamy ostatnią wartość docelową użytkownika.
      _pending = List<String>.unmodifiable(orderedIds);
      return;
    }
    _revision++;
    model.order = model.normalizeOrder(orderedIds);
    _pending = List<String>.unmodifiable(model.order);
    model.orderLocked = true;
    _host.emitTreeState();
    unawaited(_drain());
  }

  /// Ponawia zapis kolejności po nieudanej operacji.
  void retry(ProjectsRetryIntent intent) {
    if (intent.targetOrder case final order?) reorder(order);
  }

  Future<void> _drain() async {
    if (_inFlight) return;
    final repository = _host.mutations;
    if (repository == null) {
      _pending = null;
      _host.model.orderLocked = false;
      return;
    }
    final model = _host.model;
    _inFlight = true;
    _host.emitTreeState();
    try {
      while (!_host.isClosed && _pending != null) {
        final payload = _pending!;
        final revision = _revision;
        final snapshot = List<String>.unmodifiable(model.confirmedOrder);
        _pending = null;

        final result = await repository.updateProjectOrder(
          workspaceId: _host.workspaceId,
          projectIds: payload,
        );
        if (_host.isClosed) return;

        result.fold(
          (error) {
            final superseded = _revision != revision;
            if (!superseded) {
              model.order = model.restoreOrder(snapshot);
              model.confirmedOrder = snapshot;
            }
            _host.raiseFailure(
              operation: ProjectsTreeOperation.reorder,
              kind: _host.kindFor(error),
              rolledBack: !superseded,
              error: error,
              retry: ProjectsRetryIntent(
                operation: ProjectsTreeOperation.reorder,
                targetOrder: payload,
              ),
            );
          },
          (items) {
            for (final item in items) {
              model.known[item.id] = item;
            }
            final serverOrder = <String>[
              for (final item in items)
                if (!model.hiddenIds.contains(item.id) &&
                    !model.archivedIds.contains(item.id))
                  item.id,
            ];
            if (_revision == revision && _pending == null) {
              // Serwer jest źródłem kolejności, ale odpowiedź niepełna (np.
              // pominięty projekt) nie może wyczyścić drzewa użytkownika.
              final coversPayload = payload.every(serverOrder.contains);
              if (coversPayload || serverOrder.length > payload.length) {
                model.order = model.normalizeOrder(serverOrder);
                model.confirmedOrder = List<String>.unmodifiable(model.order);
              }
            }
          },
        );
      }
    } finally {
      _inFlight = false;
      if (!_host.isClosed) {
        model.orderLocked = false;
        _host.emitTreeState();
      }
    }
  }
}
