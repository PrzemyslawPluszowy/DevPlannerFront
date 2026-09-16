import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';

/// Cubit zarządzający odczytem ustawień dashboardu użytkownika.
class DashboardPreferencesCubit extends Cubit<DashboardPreferences> {
  /// Tworzy cubit ustawień dashboardu.
  DashboardPreferencesCubit({
    required this._repository,
    required String readyUserId,
    Size? initialDesktopSize,
  }) : _readyUserId = readyUserId,
       _lastNormalizedDesktopSize = initialDesktopSize,
       super(DashboardPreferences.defaults(readyUserId: readyUserId));

  final DashboardPreferencesRepository _repository;
  final String _readyUserId;
  Size? _lastNormalizedDesktopSize;
  DashboardDesktopLayoutResult? _activeLayout;

  /// Zwraca aktualny przeliczony układ pulpitu zawierający widoczne i schowane elementy.
  DashboardDesktopLayoutResult? get activeLayout => _activeLayout;

  /// Ładuje ustawienia dashboardu dla wskazanego użytkownika.
  Future<void> load() async {
    final current = await _repository.getPreferences(
      readyUserId: _readyUserId,
    );
    
    final size = _lastNormalizedDesktopSize;
    if (size != null && size.width > 0 && size.height > 0) {
      final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
        preferences: current,
        desktopSize: size,
      );
      _activeLayout = normalizedLayout;
      final normalizedPreferences = current.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      );
      emit(normalizedPreferences);
    } else {
      emit(current);
    }
  }

  /// Stosuje preferencje zapisane przez inny moduł dashboardu.
  void applySavedPreferences(DashboardPreferences preferences) {
    if (preferences.readyUserId != _readyUserId) {
      return;
    }
    final size = _lastNormalizedDesktopSize;
    if (size != null) {
      final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
        preferences: preferences,
        desktopSize: size,
      );
      _activeLayout = normalizedLayout;
      emit(
        preferences.copyWith(
          widgets: normalizedLayout.widgets,
          shortcuts: normalizedLayout.shortcuts,
        ),
      );
    } else {
      emit(preferences);
    }
  }

  /// Renormalizuje układ pulpitu do aktualnego rozmiaru okna.
  Future<void> normalizeLayoutForDesktopSize(Size desktopSize) async {
    if (desktopSize.width <= 0 || desktopSize.height <= 0) {
      return;
    }

    if (_lastNormalizedDesktopSize == desktopSize) {
      return;
    }

    _lastNormalizedDesktopSize = desktopSize;
    final current = await _repository.getPreferences(readyUserId: _readyUserId);
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: current,
      desktopSize: desktopSize,
    );
    _activeLayout = normalizedLayout;
    final normalizedPreferences = current.copyWith(
      widgets: normalizedLayout.widgets,
      shortcuts: normalizedLayout.shortcuts,
    );

    if (normalizedPreferences == current) {
      if (state != current) {
        emit(current);
      }
      return;
    }

    emit(normalizedPreferences);
  }

  /// Przełącza tryb przyciągania elementów do siatki.
  Future<void> toggleSnapToGrid() async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) => current.copyWith(
        snapToGrid: !current.snapToGrid,
        updatedAt: DateTime.now(),
      ),
    );

    final size =
        _lastNormalizedDesktopSize ??
        DashboardDesktopGeometry.fallbackDesktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: size,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }

  /// Automatycznie grupuje wszystkie elementy na pulpicie zaczynając od lewego górnego rogu.
  Future<void> autoArrange() async {
    final size =
        _lastNormalizedDesktopSize ??
        DashboardDesktopGeometry.fallbackDesktopSize;
    
    final current = await _repository.getPreferences(readyUserId: _readyUserId);
    final autoArrangedLayout = DashboardDesktopLayoutEngine.autoArrange(
      preferences: current,
      desktopSize: size,
    );

    final savedPreferences = await _repository.savePreferences(
      current.copyWith(
        widgets: autoArrangedLayout.widgets,
        shortcuts: autoArrangedLayout.shortcuts,
        updatedAt: DateTime.now(),
      ),
    );

    _activeLayout = autoArrangedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: autoArrangedLayout.widgets,
        shortcuts: autoArrangedLayout.shortcuts,
      ),
    );
  }

  /// Dodaje nowy widget do preferencji pulpitu.
  Future<bool> addWidget(
    DashboardWidgetPreference widget, {
    required Size desktopSize,
  }) async {
    final current = await _repository.getPreferences(
      readyUserId: _readyUserId,
    );
    final layout = DashboardDesktopLayoutEngine.placeWidget(
      preferences: current,
      widget: widget,
      desktopSize: desktopSize,
    );
    if (layout == null) {
      return false;
    }

    final savedPreferences = await _repository.savePreferences(
      current.copyWith(
        widgets: layout.widgets,
        shortcuts: layout.shortcuts,
        updatedAt: DateTime.now(),
      ),
    );

    _lastNormalizedDesktopSize = desktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: desktopSize,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
    return true;
  }

  /// Usuwa widget z preferencji pulpitu.
  Future<void> removeWidget(String id) async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) => current.copyWith(
        widgets: current.widgets.where((w) => w.id != id).toList(),
        updatedAt: DateTime.now(),
      ),
    );

    final size =
        _lastNormalizedDesktopSize ??
        DashboardDesktopGeometry.fallbackDesktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: size,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }

  /// Przesuwa widget na wierzch (na koniec listy, dzięki czemu renderuje się najwyżej).
  Future<void> bringWidgetToFront(String id) async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final target = current.widgets.firstWhere((w) => w.id == id);
        final others = current.widgets.where((w) => w.id != id).toList();
        return current.copyWith(
          widgets: [...others, target],
          updatedAt: DateTime.now(),
        );
      },
    );

    if (_activeLayout != null) {
      _activeLayout = DashboardDesktopLayoutResult(
        widgets: savedPreferences.widgets,
        shortcuts: _activeLayout!.shortcuts,
        overflowedWidgets: _activeLayout!.overflowedWidgets,
        overflowedShortcuts: _activeLayout!.overflowedShortcuts,
      );
    }
    emit(state.copyWith(widgets: savedPreferences.widgets));
  }

  /// Przesuwa widget pod spód (na początek listy, dzięki czemu renderuje się najniżej).
  Future<void> sendWidgetToBack(String id) async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final target = current.widgets.firstWhere((w) => w.id == id);
        final others = current.widgets.where((w) => w.id != id).toList();
        return current.copyWith(
          widgets: [target, ...others],
          updatedAt: DateTime.now(),
        );
      },
    );

    if (_activeLayout != null) {
      _activeLayout = DashboardDesktopLayoutResult(
        widgets: savedPreferences.widgets,
        shortcuts: _activeLayout!.shortcuts,
        overflowedWidgets: _activeLayout!.overflowedWidgets,
        overflowedShortcuts: _activeLayout!.overflowedShortcuts,
      );
    }
    emit(state.copyWith(widgets: savedPreferences.widgets));
  }

  /// Zmienia rozmiar wskazanego widgetu.
  Future<void> updateWidgetSize(
    String id,
    int width,
    int height, {
    required Size desktopSize,
  }) async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final layout = DashboardDesktopLayoutEngine.resizeWidget(
          preferences: current,
          widgetId: id,
          width: width,
          height: height,
          desktopSize: desktopSize,
        );
        return current.copyWith(
          widgets: layout.widgets,
          shortcuts: layout.shortcuts,
          updatedAt: DateTime.now(),
        );
      },
    );

    _lastNormalizedDesktopSize = desktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: desktopSize,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }

  /// Zmienia pozycję wskazanego widgetu na pulpicie.
  Future<void> updateWidgetPosition(
    String id,
    int gridColumn,
    int gridRow, {
    double? exactDx,
    double? exactDy,
    required Size desktopSize,
  }) async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final layout = DashboardDesktopLayoutEngine.moveWidget(
          preferences: current,
          widgetId: id,
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

    _lastNormalizedDesktopSize = desktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: desktopSize,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }

  /// Aktualizuje ustawienia konkretnego widgetu bez ingerencji w układ siatki.
  Future<void> updateWidgetSettings(
    String id,
    Map<String, dynamic> settings,
  ) async {
    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) {
        final nextWidgets = [
          for (final widget in current.widgets)
            if (widget.id == id)
              widget.copyWith(
                settings: {
                  ...?widget.settings,
                  ...settings,
                },
              )
            else
              widget,
        ];
        return current.copyWith(
          widgets: nextWidgets,
          updatedAt: DateTime.now(),
        );
      },
    );

    final size =
        _lastNormalizedDesktopSize ??
        DashboardDesktopGeometry.fallbackDesktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: size,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }

  /// Ustawia aktywną tapetę dashboardu i zapisuje wybór lokalnie.
  Future<void> setWallpaper(String wallpaperPath) async {
    final normalizedPath = wallpaperPath.trim();
    if (normalizedPath.isEmpty) {
      return;
    }

    final allowedPaths = <String>{
      ...state.builtInWallpaperPaths,
      ...state.customWallpaperPaths,
    };
    if (!allowedPaths.contains(normalizedPath)) {
      return;
    }

    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) => current.copyWith(
        selectedWallpaperPath: normalizedPath,
        updatedAt: DateTime.now(),
      ),
    );

    final size =
        _lastNormalizedDesktopSize ??
        DashboardDesktopGeometry.fallbackDesktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: size,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }

  /// Ustawia docelowy moduł uruchamiany automatycznie po zalogowaniu.
  Future<void> setStartupModule(DashboardStartupModule startupModule) async {
    if (state.startupModule == startupModule) {
      return;
    }

    final savedPreferences = await _repository.updatePreferences(
      readyUserId: _readyUserId,
      update: (current) => current.copyWith(
        startupModule: startupModule,
        updatedAt: DateTime.now(),
      ),
    );

    final size =
        _lastNormalizedDesktopSize ??
        DashboardDesktopGeometry.fallbackDesktopSize;
    final normalizedLayout = DashboardDesktopLayoutEngine.normalize(
      preferences: savedPreferences,
      desktopSize: size,
    );
    _activeLayout = normalizedLayout;
    emit(
      savedPreferences.copyWith(
        widgets: normalizedLayout.widgets,
        shortcuts: normalizedLayout.shortcuts,
      ),
    );
  }
}
