import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/settings/data/repositories/local_settings_repository.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';

/// Cubit zarzadzajacy lokalnymi ustawieniami aplikacji.
class LocalSettingsCubit extends Cubit<LocalSettingsModel> {
  /// Tworzy cubit lokalnych ustawien.
  LocalSettingsCubit({
    required this._repository,
    LocalSettingsModel? initialState,
  }) : super(initialState ?? const LocalSettingsModel.defaults());

  final LocalSettingsRepository _repository;

  /// Ładuje zapisane ustawienia z lokalnego storage.
  Future<void> load() async {
    final settings = await _repository.getSettings();
    emit(settings);
  }

  /// Ustawia tryb motywu aplikacji.
  Future<void> setThemeMode(ThemeMode mode) async {
    await _applyUpdate((current) => current.copyWith(themeMode: mode));
  }

  /// Ustawia palete kolorystyczna aplikacji.
  Future<void> setThemePalette(AppThemePalette palette) async {
    await _applyUpdate((current) => current.copyWith(themePalette: palette));
  }

  /// Ustawia seed koloru dla palety Material.
  Future<void> setThemeSeedColor(AppThemeSeedColor seedColor) async {
    await _applyUpdate(
      (current) => current.copyWith(themeSeedColor: seedColor),
    );
  }

  /// Ustawia jezyk interfejsu aplikacji.
  Future<void> setLanguage(AppLanguage language) async {
    await _applyUpdate((current) => current.copyWith(language: language));
  }

  /// Zwraca kolejnosc elementow menu po uwzglednieniu zapisu lokalnego.
  ///
  /// Algorytm jest odporny na zmiany backendu/frontendu:
  /// - usuwa ID, ktore nie istnieja juz w domyslnej liscie,
  /// - dopina nowe elementy na koncu, zachowujac domyslna kolejnosc.
  List<String> orderedMenuIds({
    required String menuId,
    required List<String> defaultOrder,
  }) {
    final normalizedDefaults = _normalizeIds(defaultOrder);
    if (normalizedDefaults.isEmpty) {
      return const [];
    }

    final saved = state.sideMenuOrders[menuId];
    if (saved == null || saved.isEmpty) {
      return normalizedDefaults;
    }

    final defaultSet = normalizedDefaults.toSet();
    final merged = <String>[
      for (final id in _normalizeIds(saved))
        if (defaultSet.contains(id)) id,
    ];

    for (final id in normalizedDefaults) {
      if (!merged.contains(id)) {
        merged.add(id);
      }
    }

    return merged;
  }

  /// Zapisuje kolejnosc pozycji dla konkretnego menu.
  Future<void> setMenuOrder({
    required String menuId,
    required List<String> orderedIds,
  }) async {
    if (menuId.isEmpty) {
      return;
    }

    final normalized = _normalizeIds(orderedIds);
    final nextOrders = Map<String, List<String>>.from(state.sideMenuOrders);

    if (normalized.isEmpty) {
      nextOrders.remove(menuId);
    } else {
      nextOrders[menuId] = normalized;
    }

    await _applyUpdate(
      (current) => current.copyWith(sideMenuOrders: nextOrders),
    );
  }

  /// Odczytuje zapisany stan panelu nawigacyjnego.
  ///
  /// Brak wpisu oznacza wartość domyślną przekazaną przez właściciela panelu.
  bool isNavigationPanelExpanded(
    String preferenceKey, {
    bool defaultExpanded = true,
  }) {
    if (preferenceKey.isEmpty) {
      return defaultExpanded;
    }

    final collapsed = state.sideMenuCollapsed[preferenceKey];
    return collapsed == null ? defaultExpanded : !collapsed;
  }

  /// Zapisuje stan panelu nawigacyjnego dla konkretnego widoku i użytkownika.
  Future<void> setNavigationPanelExpanded({
    required String preferenceKey,
    required bool expanded,
  }) async {
    if (preferenceKey.isEmpty) {
      return;
    }

    final nextCollapsed = Map<String, bool>.from(state.sideMenuCollapsed)
      ..[preferenceKey] = !expanded;
    await _applyUpdate(
      (current) => current.copyWith(sideMenuCollapsed: nextCollapsed),
    );
  }

  /// Zapisuje wyłącznie lokalne preferencje globalnego panelu Chat.
  Future<void> setGlobalChatPanelPreferences({
    required bool pinned,
    required double width,
    String? lastConversationId,
  }) async {
    await _applyUpdate(
      (current) => current.copyWith(
        globalChatPinned: pinned,
        globalChatWidth: width.clamp(320, 560).toDouble(),
        globalChatLastConversationId: lastConversationId,
      ),
    );
  }

  List<String> _normalizeIds(List<String> ids) {
    final seen = <String>{};
    final normalized = <String>[];

    for (final id in ids) {
      if (id.isEmpty || !seen.add(id)) {
        continue;
      }
      normalized.add(id);
    }

    return normalized;
  }

  Future<void> _applyUpdate(
    LocalSettingsModel Function(LocalSettingsModel current) update,
  ) async {
    final nextState = update(state);
    emit(nextState);
    await _repository.saveSettings(nextState);
  }
}
