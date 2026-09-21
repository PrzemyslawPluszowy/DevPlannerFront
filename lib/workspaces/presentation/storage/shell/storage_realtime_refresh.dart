import 'dart:async';

import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';

/// Łączy kanał zmian z listą plików.
///
/// Zdarzenie z huba jest sygnałem, nie danymi: koordynator odświeża bieżący
/// widok w miejscu, zamiast łatać listę po identyfikatorach plików. Dzięki temu
/// zmiana z cudzej sesji nie przewija listy, nie zmienia folderu i nie gubi
/// zaznaczenia, a uprawnienia zaznaczonych plików są brane ze świeżej odpowiedzi.
final class StorageRealtimeRefreshCoordinator {
  /// Tworzy koordynator dla jednego ekranu.
  StorageRealtimeRefreshCoordinator({
    required this.client,
    required this.browser,
    required this.selection,
    required this.onFailure,
    this.debounce = const Duration(milliseconds: 250),
  }) {
    _events = client.events.listen(_onEvent);
  }

  /// Kanał zmian tego ekranu.
  final StorageRealtimeClient client;

  /// Lista, którą odświeża zdarzenie.
  final StorageBrowserCubit browser;

  /// Zaznaczenie, które po odświeżeniu musi zawęzić się do istniejących pozycji.
  final StorageSelectionCubit selection;

  /// Jedyna powierzchnia błędu: trwały banner nad listą.
  final void Function(StorageMutationError) onFailure;

  /// Okno zbierania zdarzeń.
  ///
  /// Jedna operacja potrafi wygenerować kilka zdarzeń (np. seria przeniesień),
  /// a użytkownik potrzebuje jednego odświeżenia, nie pięciu.
  final Duration debounce;

  late final StreamSubscription<StorageRealtimeEvent> _events;
  Timer? _debounceTimer;
  StorageRealtimeTarget? _target;
  bool _disposed = false;
  bool _refreshInFlight = false;
  bool _refreshAgain = false;

  /// Podłącza kanał zakresu widoku.
  ///
  /// Zakres bez własnego kanału (kosz, udostępnione, ostatnie, ulubione, zasób)
  /// zamyka poprzednią subskrypcję, żeby zdarzenia innego zakresu nie
  /// odświeżały tej listy.
  Future<void> start(StorageScope scope, {String? ownerUserId}) async {
    if (_disposed) return;
    final target = StorageRealtimeTarget.forScope(
      scope,
      ownerUserId: ownerUserId,
    );
    final unchanged = target == _target;
    _target = target;
    // Ten sam zakres wołamy ponownie świadomie: kanał mógł się nie połączyć
    // przy pierwszej próbie i wtedy ponowienie należy do klienta, a nie do
    // decyzji koordynatora o pominięciu wywołania.
    if (unchanged && target != null) {
      _debounceTimer?.cancel();
      _debounceTimer = null;
      await client.start(target);
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = null;
    if (target == null) {
      await client.stop();
      return;
    }
    await client.start(target);
  }

  /// Zamyka kanał i zwalnia zasoby.
  ///
  /// Odsubskrybowanie nie jest wyczekiwane: zamknięcie ekranu nie może zależeć
  /// od tego, czy anulowanie strumienia zdążyło wrócić. Zwolnienie klienta
  /// zamyka transport, więc subskrypcja i tak kończy się razem z nim.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _debounceTimer?.cancel();
    _debounceTimer = null;
    unawaited(_events.cancel());
    await client.dispose();
  }

  void _onEvent(StorageRealtimeEvent event) {
    if (_disposed) return;
    if (event.requiresFullRefresh) {
      // Luka w historii znaczy, że zmiany mogły umknąć. Nie czekamy na ciszę,
      // bo zwłoka pokazywałaby listę, o której wiemy, że jest nieaktualna.
      _debounceTimer?.cancel();
      unawaited(_refresh());
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => unawaited(_refresh()));
  }

  Future<void> _refresh() async {
    if (_disposed) return;
    if (_refreshInFlight) {
      _refreshAgain = true;
      return;
    }
    _refreshInFlight = true;
    try {
      final target = _target;
      final failure = await browser.refreshFromRealtime();
      // Wynik odrzucony, gdy zmienił się zakres: to już inna lista.
      if (_disposed || target != _target) return;
      if (failure != null) {
        onFailure(
          StorageMutationError(
            message: failure.message,
            code: failure.apiCode,
            traceId: failure.traceId,
            // Odświeżenie listy jest bezpieczne do powtórzenia i nie tworzy
            // drugiej zmiany, więc „Ponów” zachowuje sens także tutaj.
            onRetry: () => unawaited(_refresh()),
          ),
        );
        return;
      }
      final state = browser.state;
      if (state is StorageBrowserReady) {
        selection.retain(allFiles: state.files, allFolders: state.folders);
      } else if (state is StorageBrowserEmpty) {
        selection.retain(allFiles: const [], allFolders: const []);
      }
    } finally {
      _refreshInFlight = false;
      if (_refreshAgain && !_disposed) {
        _refreshAgain = false;
        unawaited(_refresh());
      }
    }
  }
}
