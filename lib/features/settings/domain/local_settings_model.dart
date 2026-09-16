import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Dostepne palety kolorystyczne aplikacji.
enum AppThemePalette { classic, material }

/// Dostepne kolory seed dla palety Material.
enum AppThemeSeedColor {
  blue,
  emerald,
  amber,
  rose,
  violet,
  teal,
  indigo,
  orange,
  crimson,
}

/// Dostepne jezyki interfejsu aplikacji.
enum AppLanguage { pl, en }

/// Lokalna konfiguracja aplikacji zapisywana po stronie klienta.
///
/// Model jest celowo prosty i gotowy do dalszej rozbudowy
/// (np. jezyk, format daty, preferencje widokow).
class LocalSettingsModel extends Equatable {
  /// Tworzy model lokalnych ustawien.
  const LocalSettingsModel({
    required this.themeMode,
    required this.themePalette,
    required this.themeSeedColor,
    required this.language,
    required this.sideMenuOrders,
    this.sideMenuCollapsed = const {},
    this.globalChatPinned = false,
    this.globalChatWidth = 384,
    this.globalChatLastConversationId,
  });

  /// Domyslne ustawienia po pierwszym uruchomieniu.
  const LocalSettingsModel.defaults()
    : themeMode = ThemeMode.light,
      themePalette = AppThemePalette.classic,
      themeSeedColor = AppThemeSeedColor.blue,
      language = AppLanguage.pl,
      sideMenuOrders = const {},
      sideMenuCollapsed = const {},
      globalChatPinned = false,
      globalChatWidth = 384,
      globalChatLastConversationId = null;

  static const _notProvided = Object();

  final ThemeMode themeMode;
  final AppThemePalette themePalette;
  final AppThemeSeedColor themeSeedColor;
  final AppLanguage language;
  final Map<String, List<String>> sideMenuOrders;

  /// Stan rozwinięcia paneli nawigacyjnych zapisany per klucz użytkownika.
  ///
  /// Klucz powinien zawierać identyfikator widoku oraz identyfikator konta
  /// (np. `workspaces.home:user-123`), dzięki czemu kilka kont korzystających
  /// z tego samego urządzenia nie nadpisuje sobie preferencji.
  final Map<String, bool> sideMenuCollapsed;
  final bool globalChatPinned;
  final double globalChatWidth;
  final String? globalChatLastConversationId;

  /// Zwraca kopie modelu z nadpisanymi polami.
  LocalSettingsModel copyWith({
    ThemeMode? themeMode,
    AppThemePalette? themePalette,
    AppThemeSeedColor? themeSeedColor,
    AppLanguage? language,
    Map<String, List<String>>? sideMenuOrders,
    Map<String, bool>? sideMenuCollapsed,
    bool? globalChatPinned,
    double? globalChatWidth,
    Object? globalChatLastConversationId = _notProvided,
  }) {
    return LocalSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      themePalette: themePalette ?? this.themePalette,
      themeSeedColor: themeSeedColor ?? this.themeSeedColor,
      language: language ?? this.language,
      sideMenuOrders: sideMenuOrders ?? this.sideMenuOrders,
      sideMenuCollapsed: sideMenuCollapsed ?? this.sideMenuCollapsed,
      globalChatPinned: globalChatPinned ?? this.globalChatPinned,
      globalChatWidth: globalChatWidth ?? this.globalChatWidth,
      globalChatLastConversationId:
          identical(globalChatLastConversationId, _notProvided)
          ? this.globalChatLastConversationId
          : globalChatLastConversationId as String?,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    themePalette,
    themeSeedColor,
    language,
    sideMenuOrders,
    sideMenuCollapsed,
    globalChatPinned,
    globalChatWidth,
    globalChatLastConversationId,
  ];
}
