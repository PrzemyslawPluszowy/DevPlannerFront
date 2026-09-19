import 'package:devplanner/l10n/app_localizations.dart';

/// Stabilne kody błędów mutacji tablicy Kanban.
///
/// Cubit nie zna `BuildContext`, więc publikuje kod, a nie prozę; warstwa
/// prezentacji tłumaczy kod na tekst użytkownika przez ARB.
abstract final class TasksBoardErrorCodes {
  /// Próba przeniesienia karty do kolumny, której zawartość ukrywa filtr.
  ///
  /// Backend waliduje pozycję względem pełnej kolumny i odrzuca przeniesienie
  /// bez wskazanych sąsiadów, a filtr może ukryć wszystkie karty kolumny.
  static const String moveBlockedByFilter = 'kanban.move_blocked_by_filter';
}

/// Zamienia kod błędu mutacji na tekst dla użytkownika.
///
/// Kody spoza tej mapy są już gotowymi komunikatami i wracają bez zmian.
String tasksBoardMutationErrorText(AppLocalizations l10n, String code) =>
    switch (code) {
      TasksBoardErrorCodes.moveBlockedByFilter =>
        l10n.tasksBoardMoveBlockedByFilter,
      _ => code,
    };
