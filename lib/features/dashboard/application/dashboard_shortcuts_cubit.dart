import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_state.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcuts_catalog.dart';

/// Cubit zarzadzajacy konfiguracja skrotow dashboardu.
class DashboardShortcutsCubit extends Cubit<DashboardShortcutsState> {
  /// Tworzy cubit konfiguracji skrotow dashboardu.
  DashboardShortcutsCubit({
    required this._repository,
    required this._readyUserId,
    required this._permissions,
  }) : super(const DashboardShortcutsLoading());

  final DashboardPreferencesRepository _repository;
  final String _readyUserId;
  final Set<String> _permissions;

  /// Laduje zapisane skroty dashboardu.
  Future<void> load() async {
    final preferences = await _repository.getPreferences(
      readyUserId: _readyUserId,
    );
    emit(
      DashboardShortcutsReady(
        items: DashboardShortcutsCatalog.buildItems(
          preferences.shortcuts,
          _permissions,
        ),
      ),
    );
  }

  /// Ustawia widocznosc wybranego skrotu.
  Future<void> setVisibility(
    String shortcutId,
    bool isVisible,
  ) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    if (isVisible) {
      await showShortcut(
        shortcutId,
        desktopSize: DashboardDesktopGeometry.fallbackDesktopSize,
      );
      return;
    }

    await hideShortcut(shortcutId);
  }

  /// Zapisuje nowa etykiete uzytkownika dla skrotu.
  Future<void> setUserLabel(
    String shortcutId,
    String userLabel,
  ) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    DashboardShortcutItemViewModel? currentItem;
    for (final item in readyState.items) {
      if (item.shortcutId == shortcutId) {
        currentItem = item;
        break;
      }
    }
    if (currentItem == null) {
      return;
    }

    final normalizedLabel = userLabel.trim();
    final nextUserLabel = normalizedLabel.isEmpty ? null : normalizedLabel;

    final nextPreferences = [
      for (final item in readyState.items)
        DashboardShortcutPreference(
          shortcutId: item.shortcutId,
          userLabel: item.shortcutId == shortcutId
              ? nextUserLabel
              : item.userLabel,
          isVisible: item.isVisible,
          position: item.position,
          gridColumn: item.gridColumn,
          gridRow: item.gridRow,
        ),
    ];

    await _persist(nextPreferences);
  }

  /// Resetuje niestandardowa etykiete i przywraca katalogowa nazwe skrotu.
  Future<void> resetUserLabel(String shortcutId) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    final nextPreferences = [
      for (final item in readyState.items)
        DashboardShortcutPreference(
          shortcutId: item.shortcutId,
          userLabel: item.shortcutId == shortcutId ? null : item.userLabel,
          isVisible: item.isVisible,
          position: item.position,
          gridColumn: item.gridColumn,
          gridRow: item.gridRow,
        ),
    ];

    await _persist(nextPreferences);
  }

  /// Zmienia kolejnosc skrotow i utrwala nowy uklad.
  Future<void> reorderShortcuts(
    int oldIndex,
    int newIndex,
  ) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    final reorderedItems = [...readyState.items];
    final targetIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    final movedItem = reorderedItems.removeAt(oldIndex);
    reorderedItems.insert(targetIndex, movedItem);

    final nextPreferences = [
      for (var index = 0; index < reorderedItems.length; index++)
        DashboardShortcutPreference(
          shortcutId: reorderedItems[index].shortcutId,
          userLabel: reorderedItems[index].userLabel,
          isVisible: reorderedItems[index].isVisible,
          position: index,
          gridColumn: reorderedItems[index].gridColumn,
          gridRow: reorderedItems[index].gridRow,
        ),
    ];

    await _persist(nextPreferences);
  }

  /// Pokazuje skrot na pulpicie i ustawia go na koncu widocznych ikon, opcjonalnie we wskazanej pozycji.
  Future<void> showShortcut(
    String shortcutId, {
    required Size desktopSize,
    int? gridColumn,
    int? gridRow,
  }) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    emit(readyState.copyWith(isSaving: true));
    final preferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final layout = DashboardDesktopLayoutEngine.showShortcut(
          preferences: current,
          shortcutId: shortcutId,
          desktopSize: desktopSize,
          gridColumn: gridColumn,
          gridRow: gridRow,
        );
        return current.copyWith(
          widgets: layout.widgets,
          shortcuts: layout.shortcuts,
          updatedAt: DateTime.now(),
        );
      },
    );
    emit(
      DashboardShortcutsReady(
        items: DashboardShortcutsCatalog.buildItems(
          preferences.shortcuts,
          _permissions,
        ),
      ),
    );
  }

  /// Ukrywa skrot z pulpitu, ale pozostawia go w bibliotece dostepnych ikon.
  Future<void> hideShortcut(String shortcutId) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    final visibleItems = [...readyState.visibleItems];
    final hiddenItems = [...readyState.hiddenItems];
    DashboardShortcutItemViewModel? removedItem;

    visibleItems.removeWhere((item) {
      if (item.shortcutId != shortcutId) {
        return false;
      }
      removedItem = item;
      return true;
    });

    if (removedItem == null) {
      return;
    }

    hiddenItems.add(removedItem!.copyWith(isVisible: false));
    await _persist(_buildPreferences(visibleItems, hiddenItems));
  }

  /// Zapisuje nowa pozycje ikony na pulpicie.
  Future<DashboardPreferences?> setShortcutDesktopPosition(
    String shortcutId, {
    required int gridColumn,
    required int gridRow,
    double? exactDx,
    double? exactDy,
    required Size desktopSize,
  }) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return null;
    }

    emit(readyState.copyWith(isSaving: true));
    final preferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final layout = DashboardDesktopLayoutEngine.moveShortcut(
          preferences: current,
          shortcutId: shortcutId,
          gridColumn: gridColumn,
          gridRow: gridRow,
          exactDx: exactDx,
          exactDy: exactDy,
          desktopSize: desktopSize,
        );
        return current.copyWith(
          widgets: layout.widgets,
          shortcuts: layout.shortcuts,
          updatedAt: DateTime.now(),
        );
      },
    );
    emit(
      DashboardShortcutsReady(
        items: DashboardShortcutsCatalog.buildItems(
          preferences.shortcuts,
          _permissions,
        ),
      ),
    );
    return preferences;
  }

  DashboardShortcutsReady? get _readyStateOrNull {
    final currentState = state;
    return currentState is DashboardShortcutsReady ? currentState : null;
  }

  Future<void> _persist(
    List<DashboardShortcutPreference> shortcuts,
  ) async {
    final readyState = _readyStateOrNull;
    if (readyState == null) {
      return;
    }

    emit(readyState.copyWith(isSaving: true));
    final preferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) => current.copyWith(
        shortcuts: shortcuts,
        updatedAt: DateTime.now(),
      ),
    );
    emit(
      DashboardShortcutsReady(
        items: DashboardShortcutsCatalog.buildItems(
          preferences.shortcuts,
          _permissions,
        ),
      ),
    );
  }

  List<DashboardShortcutPreference> _buildPreferences(
    List<DashboardShortcutItemViewModel> visibleItems,
    List<DashboardShortcutItemViewModel> hiddenItems,
  ) {
    final orderedItems = [...visibleItems, ...hiddenItems];
    return [
      for (var index = 0; index < orderedItems.length; index++)
        DashboardShortcutPreference(
          shortcutId: orderedItems[index].shortcutId,
          userLabel: orderedItems[index].userLabel,
          isVisible: index < visibleItems.length,
          position: index,
          gridColumn: orderedItems[index].gridColumn,
          gridRow: orderedItems[index].gridRow,
        ),
    ];
  }
}
