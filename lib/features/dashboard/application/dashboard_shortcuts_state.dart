import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Bazowy stan modulu skrotow dashboardu.
sealed class DashboardShortcutsState extends Equatable {
  /// Tworzy bazowy stan modulu skrotow dashboardu.
  const DashboardShortcutsState();

  @override
  List<Object?> get props => const [];
}

/// Stan ladowania konfiguracji skrotow dashboardu.
final class DashboardShortcutsLoading extends DashboardShortcutsState {
  /// Tworzy stan ladowania skrotow dashboardu.
  const DashboardShortcutsLoading();
}

/// Gotowy stan skrotow dashboardu.
final class DashboardShortcutsReady extends DashboardShortcutsState {
  /// Tworzy gotowy stan skrotow dashboardu.
  const DashboardShortcutsReady({
    required this.items,
    this.isSaving = false,
  });

  /// Wszystkie skonfigurowane pozycje skrotow.
  final List<DashboardShortcutItemViewModel> items;

  /// Czy trwa zapis preferencji skrotow.
  final bool isSaving;

  /// Widoczne skroty posortowane zgodnie z pozycja.
  List<DashboardShortcutItemViewModel> get visibleItems => [
    for (final item in items)
      if (item.isVisible) item,
  ];

  /// Ukryte skroty, ktore mozna dodac na pulpit.
  List<DashboardShortcutItemViewModel> get hiddenItems => [
    for (final item in items)
      if (!item.isVisible) item,
  ];

  /// Tworzy kopie stanu z podmienionymi polami.
  DashboardShortcutsReady copyWith({
    List<DashboardShortcutItemViewModel>? items,
    bool? isSaving,
  }) {
    return DashboardShortcutsReady(
      items: items ?? this.items,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [items, isSaving];
}

/// Widok pojedynczego skrotu gotowy do renderowania.
final class DashboardShortcutItemViewModel extends Equatable {
  /// Tworzy model widoku pojedynczego skrotu dashboardu.
  const DashboardShortcutItemViewModel({
    required this.shortcutId,
    required this.routePath,
    required this.icon,
    required this.userLabel,
    required this.isVisible,
    required this.position,
    required this.gridColumn,
    required this.gridRow,
    this.exactDx,
    this.exactDy,
  });

  /// Stabilny identyfikator skrotu.
  final String shortcutId;

  /// Docelowa sciezka routera.
  final String routePath;

  /// Ikona skrotu.
  final IconData icon;

  /// Wlasna etykieta uzytkownika.
  final String? userLabel;

  /// Czy skrot jest widoczny na dashboardzie.
  final bool isVisible;

  /// Kolejnosc skrotu na dashboardzie.
  final int position;

  /// Kolumna siatki zajmowana przez skrót.
  final int gridColumn;

  /// Wiersz siatki zajmowany przez skrót.
  final int gridRow;

  /// Dokładna pozycja X, gdy wyłączone jest przyciąganie do siatki.
  final double? exactDx;

  /// Dokładna pozycja Y, gdy wyłączone jest przyciąganie do siatki.
  final double? exactDy;

  /// Czy skrot ma niestandardowa etykiete.
  bool get hasCustomLabel => userLabel != null && userLabel!.trim().isNotEmpty;

  /// Tworzy kopie modelu z podmienionymi polami.
  DashboardShortcutItemViewModel copyWith({
    String? shortcutId,
    String? routePath,
    IconData? icon,
    String? userLabel,
    bool clearUserLabel = false,
    bool? isVisible,
    int? position,
    int? gridColumn,
    int? gridRow,
    double? exactDx,
    bool clearExactDx = false,
    double? exactDy,
    bool clearExactDy = false,
  }) {
    return DashboardShortcutItemViewModel(
      shortcutId: shortcutId ?? this.shortcutId,
      routePath: routePath ?? this.routePath,
      icon: icon ?? this.icon,
      userLabel: clearUserLabel ? null : userLabel ?? this.userLabel,
      isVisible: isVisible ?? this.isVisible,
      position: position ?? this.position,
      gridColumn: gridColumn ?? this.gridColumn,
      gridRow: gridRow ?? this.gridRow,
      exactDx: clearExactDx ? null : exactDx ?? this.exactDx,
      exactDy: clearExactDy ? null : exactDy ?? this.exactDy,
    );
  }

  @override
  List<Object?> get props => [
    shortcutId,
    routePath,
    icon,
    userLabel,
    isVisible,
    position,
    gridColumn,
    gridRow,
    exactDx,
    exactDy,
  ];
}
