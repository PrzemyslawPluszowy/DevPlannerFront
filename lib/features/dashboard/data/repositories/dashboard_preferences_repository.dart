import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/storage/hive_helper.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_ids.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';

/// Repozytorium lokalnych ustawień dashboardu per użytkownik.
abstract class DashboardPreferencesRepository {
  /// Odczytuje ustawienia dashboardu dla wskazanego użytkownika.
  Future<DashboardPreferences> getPreferences({required String readyUserId});

  /// Zapisuje ustawienia dashboardu dla wskazanego użytkownika.
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  );

  /// Aktualizuje ustawienia dashboardu na podstawie aktualnie zapisanego stanu.
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  });

  /// Zamyka otwarte zasoby repozytorium.
  Future<void> close();
}

/// Kontrakt lokalnego repozytorium umożliwiający bezpieczną migrację danych Hive.
// ignore: one_member_abstracts
abstract interface class DashboardPreferencesLocalStore {
  /// Sprawdza, czy dla użytkownika istniał zapis pulpitu przed utworzeniem domyślnego stanu.
  Future<bool> hasStoredPreferences({required String readyUserId});
}

/// Implementacja repozytorium oparta o lokalny storage Hive.
class HiveDashboardPreferencesRepository
    implements DashboardPreferencesRepository, DashboardPreferencesLocalStore {
  /// Tworzy repozytorium ustawień dashboardu.
  HiveDashboardPreferencesRepository();

  static const _boxName = 'dashboard_preferences_box_v2';
  static const _currentDesktopGridVersion = 2;

  @override
  Future<DashboardPreferences> getPreferences({
    required String readyUserId,
  }) async {
    final normalizedUserId = _normalizeReadyUserId(readyUserId);
    final box = await HiveHelper.openBox<DashboardPreferences>(_boxName);
    final stored = box.get(normalizedUserId);
    if (stored != null) {
      final normalized = _normalizePreferences(stored, normalizedUserId);
      if (normalized != stored) {
        await box.put(normalizedUserId, normalized);
      }
      return normalized;
    }

    final defaults = DashboardPreferences.defaults(
      readyUserId: normalizedUserId,
    );
    await box.put(normalizedUserId, defaults);
    return defaults;
  }

  @override
  Future<bool> hasStoredPreferences({required String readyUserId}) async {
    final box = await HiveHelper.openBox<DashboardPreferences>(_boxName);
    return box.containsKey(_normalizeReadyUserId(readyUserId));
  }

  @override
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  ) async {
    final normalizedUserId = _normalizeReadyUserId(preferences.readyUserId);
    final normalized = _sanitizePreferencesForStorage(
      preferences.copyWith(
        readyUserId: normalizedUserId,
        updatedAt: DateTime.now(),
      ),
    );
    final box = await HiveHelper.openBox<DashboardPreferences>(_boxName);
    await box.put(normalized.readyUserId, normalized);
    return normalized;
  }

  @override
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  }) async {
    final current = await getPreferences(readyUserId: readyUserId);
    final next = update(current);
    return savePreferences(next);
  }

  @override
  Future<void> close() async {
    await HiveHelper.closeBox(_boxName);
  }

  String _normalizeReadyUserId(String readyUserId) {
    final normalized = readyUserId.trim();
    return normalized.isEmpty ? 'anonymous' : normalized;
  }

  DashboardPreferences _normalizePreferences(
    DashboardPreferences preferences,
    String normalizedUserId,
  ) {
    return _sanitizePreferencesForStorage(
      preferences.copyWith(readyUserId: normalizedUserId),
    );
  }

  DashboardPreferences _sanitizePreferencesForStorage(
    DashboardPreferences preferences,
  ) {
    const builtInWallpaperPaths = dashboardDefaultWallpaperPaths;
    final customWallpaperPaths = <String>[
      for (final path in preferences.customWallpaperPaths)
        if (path.trim().isNotEmpty) path.trim(),
    ];
    final allowedWallpaperPaths = <String>{
      ...builtInWallpaperPaths,
      ...customWallpaperPaths,
    };
    final fallbackWallpaper = builtInWallpaperPaths.isNotEmpty
        ? builtInWallpaperPaths.first
        : DashboardPreferences.defaults(
            readyUserId: preferences.readyUserId,
          ).selectedWallpaperPath;

    final selectedWallpaperPath =
        allowedWallpaperPaths.contains(preferences.selectedWallpaperPath)
        ? preferences.selectedWallpaperPath
        : fallbackWallpaper;
    final normalizedShortcuts = _normalizeShortcuts(preferences.shortcuts);
    final normalizedWidgets = _normalizeWidgets(preferences.widgets);
    final normalizedStartupModule = _normalizeStartupModule(
      preferences.startupModule,
    );
    final migratedPreferences = _migrateDesktopGrid(
      preferences.copyWith(
        selectedWallpaperPath: selectedWallpaperPath,
        builtInWallpaperPaths: builtInWallpaperPaths,
        customWallpaperPaths: customWallpaperPaths,
        startupModule: normalizedStartupModule,
        widgets: normalizedWidgets,
        shortcuts: normalizedShortcuts,
      ),
    );
    if (preferences.selectedWallpaperPath == selectedWallpaperPath &&
        preferences.desktopGridVersion ==
            migratedPreferences.desktopGridVersion &&
        preferences.startupModule == normalizedStartupModule &&
        _samePaths(preferences.builtInWallpaperPaths, builtInWallpaperPaths) &&
        _samePaths(preferences.customWallpaperPaths, customWallpaperPaths) &&
        _sameShortcutPreferences(
          preferences.shortcuts,
          migratedPreferences.shortcuts,
        ) &&
        _sameWidgetPreferences(
          preferences.widgets,
          migratedPreferences.widgets,
        )) {
      return preferences;
    }

    return preferences.copyWith(
      selectedWallpaperPath: selectedWallpaperPath,
      builtInWallpaperPaths: builtInWallpaperPaths,
      customWallpaperPaths: customWallpaperPaths,
      startupModule: normalizedStartupModule,
      desktopGridVersion: migratedPreferences.desktopGridVersion,
      widgets: migratedPreferences.widgets,
      shortcuts: migratedPreferences.shortcuts,
      updatedAt: DateTime.now(),
    );
  }

  DashboardStartupModule _normalizeStartupModule(
    DashboardStartupModule startupModule,
  ) {
    return AppModulesCatalog.supportsStartupModule(
          startupModule,
          ReadyPermissions.modulePermissions,
        )
        ? startupModule
        : DashboardStartupModule.dashboard;
  }

  List<DashboardWidgetPreference> _normalizeWidgets(
    List<DashboardWidgetPreference> widgets,
  ) {
    final normalized = <DashboardWidgetPreference>[];

    for (final widget in widgets) {
      if (widget.widgetTypeId == 'bhp_summary' ||
          widget.widgetTypeId == 'bhp_dashboard_summary') {
        normalized.addAll(
          [
            widget.copyWith(
              id: '${widget.id}_users',
              widgetTypeId: 'bhp_dashboard_users',
              gridColumn: widget.gridColumn < 0 ? 0 : widget.gridColumn,
              gridRow: widget.gridRow < 0 ? 0 : widget.gridRow,
              width: widget.width < 1 ? 1 : widget.width,
              height: widget.height < 1 ? 1 : widget.height,
            ),
            widget.copyWith(
              id: '${widget.id}_positions',
              widgetTypeId: 'bhp_dashboard_positions',
              gridColumn: (widget.gridColumn < 0 ? 0 : widget.gridColumn) + 4,
              gridRow: widget.gridRow < 0 ? 0 : widget.gridRow,
              width: widget.width < 1 ? 1 : widget.width,
              height: widget.height < 1 ? 1 : widget.height,
            ),
            widget.copyWith(
              id: '${widget.id}_equipment',
              widgetTypeId: 'bhp_dashboard_equipment',
              gridColumn: (widget.gridColumn < 0 ? 0 : widget.gridColumn) + 8,
              gridRow: widget.gridRow < 0 ? 0 : widget.gridRow,
              width: widget.width < 1 ? 1 : widget.width,
              height: widget.height < 1 ? 1 : widget.height,
            ),
            widget.copyWith(
              id: '${widget.id}_overdue',
              widgetTypeId: 'bhp_dashboard_overdue',
              gridColumn: widget.gridColumn < 0 ? 0 : widget.gridColumn,
              gridRow: (widget.gridRow < 0 ? 0 : widget.gridRow) + 4,
              width: widget.width < 1 ? 1 : widget.width,
              height: widget.height < 1 ? 1 : widget.height,
            ),
            widget.copyWith(
              id: '${widget.id}_upcoming',
              widgetTypeId: 'bhp_dashboard_upcoming',
              gridColumn: (widget.gridColumn < 0 ? 0 : widget.gridColumn) + 4,
              gridRow: (widget.gridRow < 0 ? 0 : widget.gridRow) + 4,
              width: widget.width < 1 ? 1 : widget.width,
              height: widget.height < 1 ? 1 : widget.height,
            ),
          ],
        );
        continue;
      }

      normalized.add(
        widget.copyWith(
          gridColumn: widget.gridColumn < 0 ? 0 : widget.gridColumn,
          gridRow: widget.gridRow < 0 ? 0 : widget.gridRow,
          width: widget.width < 1 ? 1 : widget.width,
          height: widget.height < 1 ? 1 : widget.height,
        ),
      );
    }

    return normalized;
  }

  List<DashboardShortcutPreference> _normalizeShortcuts(
    List<DashboardShortcutPreference> shortcuts,
  ) {
    final normalizedById = <String, DashboardShortcutPreference>{};

    for (final shortcut in shortcuts) {
      final normalizedId = shortcut.shortcutId.trim();
      if (!DashboardShortcutIds.values.contains(normalizedId)) {
        continue;
      }
      normalizedById[normalizedId] = shortcut.copyWith(
        shortcutId: normalizedId,
        gridColumn: shortcut.gridColumn < 0 ? 0 : shortcut.gridColumn,
        gridRow: shortcut.gridRow < 0 ? 0 : shortcut.gridRow,
      );
    }

    final orderedShortcuts = normalizedById.values.toList()
      ..sort((left, right) => left.position.compareTo(right.position));

    for (var index = 0; index < DashboardShortcutIds.values.length; index++) {
      final shortcutId = DashboardShortcutIds.values[index];
      if (normalizedById.containsKey(shortcutId)) {
        continue;
      }

      orderedShortcuts.add(
        DashboardShortcutPreference(
          shortcutId: shortcutId,
          isVisible: false,
          position: orderedShortcuts.length,
          gridColumn: 0,
          gridRow: index * 2,
        ),
      );
    }

    return [
      for (var index = 0; index < orderedShortcuts.length; index++)
        orderedShortcuts[index].copyWith(position: index),
    ];
  }

  DashboardPreferences _migrateDesktopGrid(
    DashboardPreferences preferences,
  ) {
    if (preferences.desktopGridVersion >= _currentDesktopGridVersion) {
      return preferences;
    }

    return preferences.copyWith(
      desktopGridVersion: _currentDesktopGridVersion,
      widgets: [
        for (final widget in preferences.widgets)
          widget.copyWith(
            gridColumn: widget.gridColumn * 2,
            gridRow: widget.gridRow * 2,
            width: widget.width * 2,
            height: widget.height * 2,
          ),
      ],
      shortcuts: [
        for (final shortcut in preferences.shortcuts)
          shortcut.copyWith(
            gridColumn: shortcut.gridColumn * 2,
            gridRow: shortcut.gridRow * 2,
          ),
      ],
    );
  }

  bool _samePaths(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }

    return true;
  }

  bool _sameShortcutPreferences(
    List<DashboardShortcutPreference> left,
    List<DashboardShortcutPreference> right,
  ) {
    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }

    return true;
  }

  bool _sameWidgetPreferences(
    List<DashboardWidgetPreference> left,
    List<DashboardWidgetPreference> right,
  ) {
    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }

    return true;
  }
}
