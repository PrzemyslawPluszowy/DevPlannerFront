part of 'projects_tree_cubit.dart';

/// Miejsce projektu w drzewie: widoczne, ukryte przez użytkownika albo
/// zarchiwizowane.
enum _ProjectStage { visible, hidden, archived }

/// Mutowalny model drzewa projektów.
///
/// Trzyma wyłącznie dane i czystą matematykę kolejności: znane projekty,
/// kolejność prezentacji, lokalne nakładki ukrycia i archiwum oraz pozycje do
/// przywrócenia po cofnięciu. Nie zna transportu, więc rollback pozycji można
/// sprawdzić testem bez żądań HTTP.
final class _ProjectsTreeModel {
  /// Wszystkie znane projekty (widoczne, ukryte i zarchiwizowane).
  final Map<String, ProjectListItem> known = <String, ProjectListItem>{};

  /// Identyfikatory projektów ukrytych przez bieżącego użytkownika.
  final Set<String> hiddenIds = <String>{};

  /// Identyfikatory projektów zarchiwizowanych.
  ///
  /// Zbiór jest potwierdzany przez serwer (`state: archived`), a nie tylko
  /// przez operacje wykonane w bieżącej sesji.
  final Set<String> archivedIds = <String>{};

  /// Pozycje projektów usuniętych z drzewa operacją użytkownika.
  ///
  /// Dzięki nim cofnięcie ukrycia i rollback archiwizacji wracają na dokładne
  /// miejsce, a nie na koniec listy.
  final Map<String, int> restorePositions = <String, int>{};

  /// Kolejność prezentacji widocznych projektów (przypięte na górze).
  List<String> order = const <String>[];

  /// Ostatnia kolejność potwierdzona przez serwer — baza precyzyjnego rollbacku.
  List<String> confirmedOrder = const <String>[];

  /// Czy trwa operacja kolejności; wtedy potwierdzona kolejność jest zamrożona.
  bool orderLocked = false;

  /// Projekty widoczne w kolejności prezentacji.
  List<ProjectListItem> get visible => <ProjectListItem>[
    for (final id in order) ?known[id],
  ];

  /// Projekty ukryte przez użytkownika — bez tych, które są zarchiwizowane.
  ///
  /// Archiwum ma pierwszeństwo: projekt zarchiwizowany i ukryty należy do
  /// sekcji `Archiwum`, bo tam można go przywrócić.
  List<ProjectListItem> get hidden => <ProjectListItem>[
    for (final id in known.keys.where(
      (id) => hiddenIds.contains(id) && !archivedIds.contains(id),
    ))
      ?known[id],
  ];

  /// Projekty zarchiwizowane, potwierdzone przez serwer albo optymistycznie.
  List<ProjectListItem> get archived => <ProjectListItem>[
    for (final id in known.keys.where(archivedIds.contains)) ?known[id],
  ];

  /// Scala listę serwera i zwraca kolejność widocznych identyfikatorów.
  ///
  /// Metoda porządkuje wyłącznie zbiór widocznych identyfikatorów: nie zmienia
  /// znaczników ukrycia ani archiwum, bo o nich rozstrzyga zakres listy
  /// ([applyServerStage]), a projekt z intencją w locie nie może zostać
  /// nadpisany przez wolniejszą odpowiedź odczytu.
  ///
  /// Projekt, który wraca na listę, wraca też na zapamiętaną pozycję, żeby
  /// odświeżenie nie przestawiło kolejności użytkownika.
  List<String> mergeServerItems(List<ProjectListItem> items) {
    final incoming = <String>{};
    for (final item in items) {
      incoming.add(item.id);
      known[item.id] = item;
    }
    final merged = <String>[];
    for (final id in order) {
      if (incoming.contains(id) &&
          !hiddenIds.contains(id) &&
          !archivedIds.contains(id)) {
        merged.add(id);
      }
    }
    for (final item in items) {
      if (merged.contains(item.id)) continue;
      if (hiddenIds.contains(item.id) || archivedIds.contains(item.id)) {
        continue;
      }
      final restoredIndex = restorePositions.remove(item.id);
      if (restoredIndex == null) {
        merged.add(item.id);
      } else {
        merged.insert(restoredIndex.clamp(0, merged.length), item.id);
      }
    }
    return order = normalizeOrder(merged);
  }

  /// Zastępuje jedną sekcję drzewa pełną listą serwera.
  ///
  /// Poza ustawieniem stanu każdego elementu zdejmuje znaczniki wymiaru, dla
  /// którego lista jest zapytaniem wprost (`visibility: hidden` dla sekcji
  /// `Ukryte`, `state: archived` dla sekcji `Archiwum`). Dzięki temu projekt
  /// przywrócony albo odsłonięty w innej sesji znika z sekcji, a lista
  /// aktywnych nie kasuje znacznika archiwum, którego nie dotyczy.
  ///
  /// [skipIds] to projekty z intencją w locie: ich znaczników nie zmieniamy,
  /// ale nadal liczą się jako obecne na liście, więc nie zostaną przycięte.
  void applyServerSection(
    List<ProjectListItem> items, {
    required ProjectListState state,
    required ProjectListVisibility visibility,
    Set<String> skipIds = const <String>{},
  }) {
    final serverIds = <String>{};
    for (final item in items) {
      serverIds.add(item.id);
      if (skipIds.contains(item.id)) continue;
      applyServerStage(item, state: state, visibility: visibility);
    }
    _pruneServerSection(serverIds, state: state, visibility: visibility);
  }

  /// Ustawia miejsce projektu wynikające z zakresu listy serwera.
  ///
  /// [state] decyduje o znaczniku archiwum, a [visibility] o znaczniku ukrycia,
  /// przy czym dla filtrów `all` rozstrzyga pole projektu (`isHidden`,
  /// `archivedAtUtc`) — dokładnie tak, jak filtruje backend.
  void applyServerStage(
    ProjectListItem project, {
    required ProjectListState state,
    required ProjectListVisibility visibility,
  }) {
    final id = project.id;
    final wasInTree = !hiddenIds.contains(id) && !archivedIds.contains(id);
    known[id] = project;

    final isArchived = switch (state) {
      ProjectListState.active => false,
      ProjectListState.archived => true,
      ProjectListState.all => project.isArchived,
    };
    final isHidden = switch (visibility) {
      ProjectListVisibility.visible => false,
      ProjectListVisibility.hidden => true,
      ProjectListVisibility.all => project.isHidden,
    };
    if (isHidden) {
      hiddenIds.add(id);
    } else {
      hiddenIds.remove(id);
    }
    if (isArchived) {
      archivedIds.add(id);
    } else {
      archivedIds.remove(id);
    }

    if (isHidden || isArchived) {
      if (wasInTree) rememberPosition(id);
      order = List<String>.unmodifiable(order.where((entry) => entry != id));
    } else if (!wasInTree) {
      insertRestored(id);
    } else if (!order.contains(id)) {
      order = normalizeOrder(<String>[...order, id]);
    }
    syncConfirmedOrder();
  }

  /// Zdejmuje znaczniki wymiaru, którego świeża lista nie zawiera już projektu.
  ///
  /// Wywoływane po zastosowaniu pełnej listy sekcji: brak projektu na liście
  /// `hidden` oznacza, że nie jest już ukryty, a brak na liście `archived` —
  /// że został przywrócony. Lista nie opisuje drugiego wymiaru, więc ten
  /// wymiar pozostaje nietknięty.
  void _pruneServerSection(
    Set<String> serverIds, {
    required ProjectListState state,
    required ProjectListVisibility visibility,
  }) {
    if (visibility == ProjectListVisibility.hidden) {
      for (final id in hiddenIds.toList(growable: false)) {
        // Lista ukrytych nie zawiera projektów archiwalnych, więc brak
        // identyfikatora nie jest dowodem na to, że projekt nie jest ukryty.
        if (serverIds.contains(id) || archivedIds.contains(id)) continue;
        _clearHiddenMarker(id);
      }
    }
    if (state == ProjectListState.archived) {
      for (final id in archivedIds.toList(growable: false)) {
        if (serverIds.contains(id)) continue;
        _clearArchivedMarker(id);
      }
    }
  }

  /// Zdejmuje znacznik ukrycia i przywraca projekt do drzewa, gdy wraca.
  void _clearHiddenMarker(String projectId) {
    if (!hiddenIds.remove(projectId)) return;
    _restoreIfVisibleAgain(projectId);
  }

  /// Zdejmuje znacznik archiwum i przywraca projekt do drzewa, gdy wraca.
  void _clearArchivedMarker(String projectId) {
    if (!archivedIds.remove(projectId)) return;
    _restoreIfVisibleAgain(projectId);
  }

  void _restoreIfVisibleAgain(String projectId) {
    if (hiddenIds.contains(projectId) || archivedIds.contains(projectId)) {
      return;
    }
    insertRestored(projectId);
    syncConfirmedOrder();
  }

  /// Dopisuje projekt do znanych i wstawia go na koniec listy, jeśli brakuje.
  ProjectListItem resolve(ProjectListItem project) {
    final existing = known[project.id];
    if (existing != null) return existing;
    known[project.id] = project;
    if (!hiddenIds.contains(project.id) &&
        !archivedIds.contains(project.id) &&
        !order.contains(project.id)) {
      order = normalizeOrder(<String>[...order, project.id]);
      syncConfirmedOrder();
    }
    return project;
  }

  /// Porządkuje identyfikatory: przypięte na górze, reszta zachowuje kolejność.
  List<String> normalizeOrder(List<String> ids) {
    final pinned = <String>[];
    final regular = <String>[];
    for (final id in ids) {
      final project = known[id];
      if (project != null && project.isPinned) {
        pinned.add(id);
      } else {
        regular.add(id);
      }
    }
    return List<String>.unmodifiable(<String>[...pinned, ...regular]);
  }

  /// Przywraca zapisane pozycje, pomijając projekty, które zniknęły z drzewa.
  List<String> restoreOrder(List<String> ids) => List<String>.unmodifiable(
    ids.where(
      (id) =>
          known.containsKey(id) &&
          !hiddenIds.contains(id) &&
          !archivedIds.contains(id),
    ),
  );

  /// Nakłada lokalne przypięcie i ustala pozycję projektu w kolejności.
  ///
  /// [restoreIndex] jest używany przy rollbacku: projekt wraca na pozycję
  /// zapamiętaną przy pierwszej intencji, a nie na koniec listy.
  void applyPinnedLocally(
    String projectId, {
    required bool isPinned,
    int? restoreIndex,
  }) {
    final known = this.known[projectId];
    if (known == null) return;
    this.known[projectId] = known.copyWith(isPinned: isPinned);
    if (!order.contains(projectId)) {
      syncConfirmedOrder();
      return;
    }
    final others = order.where((id) => id != projectId).toList();
    final next = restoreIndex != null
        ? (others.toList()
            ..insert(restoreIndex.clamp(0, others.length), projectId))
        : order.toList();
    order = normalizeOrder(next);
    syncConfirmedOrder();
  }

  /// Ukrywa projekt w drzewie albo przywraca go do drzewa.
  void applyHidden(String projectId, {required bool hidden}) {
    final changed = hidden
        ? hiddenIds.add(projectId)
        : hiddenIds.remove(projectId);
    if (!changed) return;
    if (hidden) {
      rememberPosition(projectId);
      order = List<String>.unmodifiable(
        order.where((id) => id != projectId),
      );
    } else {
      insertRestored(projectId);
    }
    syncConfirmedOrder();
  }

  /// Ustawia miejsce projektu w drzewie (widoczne, ukryte, zarchiwizowane).
  void applyStage(String projectId, _ProjectStage stage) {
    hiddenIds.remove(projectId);
    archivedIds.remove(projectId);
    if (stage != _ProjectStage.visible) rememberPosition(projectId);
    order = List<String>.unmodifiable(
      order.where((id) => id != projectId),
    );
    switch (stage) {
      case _ProjectStage.visible:
        insertRestored(projectId);
      case _ProjectStage.hidden:
        hiddenIds.add(projectId);
      case _ProjectStage.archived:
        archivedIds.add(projectId);
    }
    syncConfirmedOrder();
  }

  /// Bieżące miejsce projektu w drzewie.
  _ProjectStage stageOf(String projectId) {
    if (archivedIds.contains(projectId)) return _ProjectStage.archived;
    if (hiddenIds.contains(projectId)) return _ProjectStage.hidden;
    return _ProjectStage.visible;
  }

  /// Zapisuje pozycję projektu przed usunięciem go z drzewa.
  void rememberPosition(String projectId) {
    final index = order.indexOf(projectId);
    if (index >= 0) restorePositions[projectId] = index;
  }

  /// Wstawia projekt z powrotem na zapamiętaną pozycję albo na koniec listy.
  void insertRestored(String projectId) {
    if (!known.containsKey(projectId)) return;
    final index = restorePositions.remove(projectId);
    if (index == null) {
      order = normalizeOrder(<String>[...order, projectId]);
      return;
    }
    final next = order.toList();
    next.insert(index.clamp(0, next.length), projectId);
    order = normalizeOrder(next);
  }

  /// Kolejność potwierdzona przez serwer podąża za zmianami zbioru widocznych
  /// projektów, dopóki nie ma intencji kolejności w drodze.
  void syncConfirmedOrder() {
    if (orderLocked) return;
    confirmedOrder = List<String>.unmodifiable(order);
  }

  /// Usuwa projekt z modelu po trwałym usunięciu.
  void forget(String projectId) {
    known.remove(projectId);
    hiddenIds.remove(projectId);
    archivedIds.remove(projectId);
    restorePositions.remove(projectId);
    order = List<String>.unmodifiable(
      order.where((id) => id != projectId),
    );
    confirmedOrder = List<String>.unmodifiable(
      confirmedOrder.where((id) => id != projectId),
    );
  }

  /// Scala odpowiedź lifecycle z danymi listy.
  ///
  /// Odpowiedź pojedynczego projektu nie niesie osobistych preferencji, więc
  /// aktualizujemy wyłącznie pola, których dotyczyła operacja. Nadpisanie
  /// całego obiektu skasowałoby lokalne przypięcie. Wersja i capabilities są
  /// przyjmowane z odpowiedzi, żeby kolejna mutacja użyła świeżego
  /// `expectedVersion`, a menu nie działało na nieaktualnych uprawnieniach.
  void applyLifecycleResponse(ProjectListItem response) {
    final existing = known[response.id] ?? response;
    known[response.id] = existing.copyWith(
      name: response.name,
      description: response.description,
      clearDescription: response.description == null,
      icon: response.icon,
      clearIcon: response.icon == null,
      primaryColor: response.primaryColor,
      clearPrimaryColor: response.primaryColor == null,
      visibility: response.visibility,
      status: response.status,
      myRole: response.myRole,
      clearMyRole: response.myRole == null,
      archivedAtUtc: response.archivedAtUtc,
      clearArchivedAtUtc: response.archivedAtUtc == null,
      version: response.version,
      clearVersion: response.version == null,
      capabilities: response.capabilities,
      clearCapabilities: response.capabilities == null,
    );
  }

  /// Czy dwa zbiory identyfikatorów są identyczne (pełna lista DnD).
  bool isSameIdSet(List<String> candidate, List<String> reference) {
    if (candidate.length != reference.length) return false;
    final expected = reference.toSet();
    final actual = candidate.toSet();
    return actual.length == candidate.length &&
        expected.length == actual.length &&
        expected.containsAll(actual);
  }
}
