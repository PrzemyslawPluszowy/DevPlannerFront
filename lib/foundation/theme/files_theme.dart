import 'package:devplanner/foundation/theme/tasks_theme.dart';
import 'package:flutter/material.dart';

/// Tokeny modułu Files.
///
/// Pliki należą do tej samej rodziny powierzchni danych co Tasks/Kanban, więc
/// geometria (wysokości wierszy chrome'u, promienie kontrolek, odstępy 4 px,
/// role powierzchni i wierszy) pochodzi z [DevPlannerTasksTheme] zamiast być
/// kopiowana. Kopia rozjechałaby się przy pierwszej zmianie gęstości i dała
/// dokładnie ten efekt, który ten pakiet usuwa: moduł wyglądający na obcy.
///
/// To rozszerzenie dokłada wyłącznie to, co specyficzne dla eksploratora
/// plików: rozmiar komórki kafelka, wysokość karty i kciuk miniatury. Wspólne
/// miary czytamy przez [common], więc w kodzie modułu widać, co jest wspólne,
/// a co lokalne.
final class DevPlannerFilesTheme {
  /// Tworzy tokeny Files na bazie wspólnych tokenów modułów danych.
  const DevPlannerFilesTheme({required this.common});

  /// Wspólna gęstość, typografia i role powierzchni modułów danych.
  final DevPlannerTasksTheme common;

  /// Docelowa szerokość kafelka pliku.
  double get gridCardExtent => 200;

  /// Wysokość kafelka pliku razem z paskiem metadanych.
  double get gridCardHeight => 160;

  /// Docelowa szerokość kafelka folderu.
  double get gridFolderExtent => 220;

  /// Wysokość kafelka folderu.
  double get gridFolderHeight => 76;

  /// Kciuk miniatury lub ikony typu w kafelku.
  double get thumbnailSize => 40;

  /// Ikona typu pliku w wierszu i ikona kontekstu w nagłówku.
  double get rowIconSize => 18;
}

/// Odczyt tokenów Files bez kopiowania miar do widgetów.
extension DevPlannerFilesThemeContextX on BuildContext {
  /// Tokeny modułu Files zbudowane z aktywnego motywu.
  ///
  /// Korzysta z zarejestrowanego rozszerzenia Tasks, żeby nie odtwarzać
  /// stylów tekstu przy każdym renderze.
  DevPlannerFilesTheme get filesTheme {
    final theme = Theme.of(this);
    return DevPlannerFilesTheme(
      common:
          theme.extension<DevPlannerTasksTheme>() ??
          DevPlannerTasksTheme.of(theme.textTheme, theme.colorScheme),
    );
  }
}
