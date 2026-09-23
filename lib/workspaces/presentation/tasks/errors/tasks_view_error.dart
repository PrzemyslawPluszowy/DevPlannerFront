import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';

/// Stabilne kody błędów widoku Tasks wspólne dla Listy i Kanbana.
///
/// Cubit nie zna `BuildContext`, więc publikuje kod, a nie prozę; prezentacja
/// tłumaczy kod przez ARB. Kody specyficzne dla jednego widoku żyją w swoim
/// module (np. kody `kanban.*` w `TasksBoardErrorCodes`).
abstract final class TasksViewErrorCodes {
  /// Ktoś inny — albo ta sama osoba w innej karcie przeglądarki — zapisał
  /// nowszą wersję ustawień widoku, więc zapis został odrzucony.
  static const String versionConflict = 'tasks.view.version_conflict';

  /// Nie udało się wczytać osobistych ustawień widoku.
  static const String loadFailed = 'tasks.view.preferences_load_failed';
}

/// Błąd operacji widoku Tasks gotowy do pokazania w trwałym bannerze.
///
/// Błąd jest częścią stanu, a nie jednorazowym zdarzeniem: SnackBar znika razem
/// z przebudową drzewa, więc komunikat o nieudanym zapisie ginął, zanim
/// użytkownik zdążył go przeczytać.
@immutable
final class TasksViewError {
  const TasksViewError({
    required this.code,
    this.traceId,
    this.canRetry = true,
  });

  /// Kod ze [TasksViewErrorCodes], kod widoku albo gotowy komunikat z Backendu.
  final String code;

  /// Identyfikator korelacji z Backendu, jeżeli go opublikował.
  final String? traceId;

  /// Czy ponowienie ma sens.
  ///
  /// Po drugim konflikcie ta sama intencja zostanie odrzucona ponownie, więc
  /// banner zostawia wtedy samo „Odśwież” zamiast zapraszać do pętli.
  final bool canRetry;

  @override
  bool operator ==(Object other) =>
      other is TasksViewError &&
      other.code == code &&
      other.traceId == traceId &&
      other.canRetry == canRetry;

  @override
  int get hashCode => Object.hash(code, traceId, canRetry);

  @override
  String toString() => 'TasksViewError($code, traceId: $traceId)';
}

/// Tłumaczy kod wspólnego błędu modułu Tasks.
///
/// Zwraca `null`, gdy kod jest komunikatem z Backendu albo kodem spoza tej
/// mapy — wtedy prezentacja sięga po tłumaczenie właściwe dla widoku.
String? tasksViewErrorText(AppLocalizations l10n, String code) =>
    switch (code) {
      TasksViewErrorCodes.versionConflict => l10n.tasksListPreferencesConflict,
      TasksViewErrorCodes.loadFailed => l10n.tasksViewPreferencesLoadFailed,
      _ => null,
    };

/// Buduje błąd widoku z odpowiedzi API, zachowując identyfikator korelacji.
TasksViewError tasksViewErrorFrom(ApiError error) =>
    TasksViewError(code: error.message, traceId: error.traceId);

/// Czy błąd oznacza konflikt wersji ustawień widoku.
///
/// Backend zwraca stabilny kod (`task_list.version_conflict`,
/// `kanban.version_conflict`), a klient nie może zgadywać konfliktu z samego
/// HTTP 409: tym kodem odpowiada też np. `project.membership_conflict`, którego
/// ponawianie nie ma sensu. Sam status zostaje wyłącznie jako zapas dla
/// odpowiedzi bez kodu domenowego.
bool isTaskSettingsVersionConflict(ApiError error) {
  final code = error.apiCode;
  if (code != null) return code.endsWith('.version_conflict');
  return error.statusCode == 409;
}
