import 'dart:async';

import 'package:flutter/material.dart';

typedef AppContextMenuActionTap = FutureOr<void> Function(BuildContext context);

/// Buduje interaktywną zawartość zachowującą powierzchnię i pozycjonowanie
/// wspólnego menu.
typedef AppContextMenuContentBuilder = Widget Function(
  BuildContext context,
  VoidCallback dismiss,
);

/// Akcja wspólnego menu wywołująca efekt po wybraniu.
class AppContextMenuAction {
  /// Tworzy akcję menu kontekstowego.
  const AppContextMenuAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.foregroundColor,
    this.iconColor,
    this.separatorBefore = false,
    this.sectionTitle,
    this.shortcutLabel,
    this.selected = false,
  });

  /// Etykieta akcji.
  final String label;

  /// Ikona akcji.
  final IconData? icon;

  /// Funkcja wykonywana po wybraniu akcji.
  final AppContextMenuActionTap onTap;

  /// Czy akcja ma charakter destrukcyjny.
  final bool isDestructive;

  /// Czy akcja jest dostępna.
  final bool enabled;

  /// Opcjonalny kolor akcji.
  final Color? foregroundColor;

  /// Opcjonalny kolor samej ikony, np. semantyczny kolor priorytetu.
  final Color? iconColor;

  /// Czy przed akcją ma pojawić się separator.
  final bool separatorBefore;

  /// Nagłówek sekcji poprzedzający tę akcję.
  final String? sectionTitle;

  /// Skrót klawiaturowy pokazywany po prawej stronie wiersza.
  final String? shortcutLabel;

  /// Czy akcja reprezentuje aktualnie wybraną wartość.
  final bool selected;
}

/// Pozycja menu wybierająca wartość i zamykająca menu po kliknięciu.
class AppContextMenuOption<T> {
  /// Tworzy pozycję menu wyboru.
  const AppContextMenuOption({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.selected = false,
    this.iconColor,
    this.leading,
    this.trailing,
    this.separatorBefore = false,
    this.sectionTitle,
    this.shortcutLabel,
  });

  /// Wartość zwracana po wybraniu pozycji.
  final T value;

  /// Etykieta pozycji.
  final String label;

  /// Ikona pozycji.
  final IconData? icon;

  /// Opcjonalny kolor samej ikony, np. semantyczny kolor priorytetu.
  final Color? iconColor;

  /// Widget przed etykietą, gdy sama ikona nie wystarcza (np. awatar).
  final Widget? leading;

  /// Widget po etykiecie, np. licznik albo próbka koloru.
  final Widget? trailing;

  /// Czy pozycja ma charakter destrukcyjny.
  final bool isDestructive;

  /// Czy pozycja jest dostępna.
  final bool enabled;

  /// Czy pozycja reprezentuje aktualnie wybraną wartość.
  final bool selected;

  /// Czy przed pozycją ma pojawić się separator.
  final bool separatorBefore;

  /// Nagłówek sekcji poprzedzający tę pozycję.
  final String? sectionTitle;

  /// Skrót klawiaturowy pokazywany po prawej stronie wiersza.
  final String? shortcutLabel;
}

/// Pozycja menu w jednym modelu dla akcji i wyboru wartości.
class AppContextMenuEntry<T> {
  const AppContextMenuEntry({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.selected = false,
    this.foregroundColor,
    this.iconColor,
    this.leading,
    this.trailing,
    this.separatorBefore = false,
    this.sectionTitle,
    this.shortcutLabel,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool isDestructive;
  final bool enabled;
  final bool selected;
  final Color? foregroundColor;
  final Color? iconColor;
  final Widget? leading;
  final Widget? trailing;
  final bool separatorBefore;
  final String? sectionTitle;
  final String? shortcutLabel;
}
