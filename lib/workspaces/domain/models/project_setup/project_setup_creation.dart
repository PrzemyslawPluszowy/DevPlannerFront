import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';

/// Pole kreatora, przy którym pokazujemy błąd walidacji.
///
/// Błąd pola zostaje przy konkretnym polu i nigdy nie jest przenoszony do
/// globalnego bannera ani do SnackBara.
enum ProjectSetupField {
  /// Pole nazwy projektu.
  name,

  /// Wybór szablonu w kroku startu.
  template,

  /// Lista początkowych członków projektu Private.
  members,

  /// Lista jawnych statusów workflow.
  customStatuses,

  /// Pola widoczne na kafelku Kanban.
  boardFields,

  /// Dzienna pojemność workspace.
  capacity,
}

/// Stabilny powód odrzucenia wartości w kreatorze.
///
/// Kody są tłumaczone w UI przez ARB; warstwa stanu nie zawiera tekstów
/// użytkownika i nie zna języka.
enum ProjectSetupValidationError {
  /// Nazwa projektu jest pusta.
  nameRequired,

  /// Nazwa projektu przekracza limit kontraktu.
  nameTooLong,

  /// Opis projektu przekracza limit kontraktu.
  descriptionTooLong,

  /// Projekt z szablonu nie ma wybranego szablonu.
  templateRequired,

  /// Ten sam użytkownik występuje na liście członków więcej niż raz.
  memberDuplicated,

  /// Jawny status workflow nie ma nazwy.
  statusNameRequired,

  /// Nazwa jawnego statusu przekracza limit kontraktu albo się powtarza.
  statusNameInvalid,

  /// Liczba jawnych statusów przekracza limit kreatora.
  statusesLimitExceeded,

  /// Limit WIP jawnego statusu jest poza zakresem 1-999.
  statusWipInvalid,

  /// Pojemność dzienna jest poza zakresem 0-1440 minut.
  capacityOutOfRange,

  /// Kafelek Kanban nie ma wybranego żadnego pola.
  boardFieldsRequired,
}

/// Wynik atomowego utworzenia projektu zwrócony przez Backend.
///
/// Zawiera wyłącznie dane potrzebne do uzupełnienia drzewa odpowiedzią serwera —
/// kreator nigdy nie wstawia projektu z lokalnym identyfikatorem.
final class ProjectSetupCreation {
  /// Tworzy wynik utworzenia projektu.
  const ProjectSetupCreation({
    required this.project,
    required this.replayed,
    required this.memberCount,
    required this.installedRecipeKeys,
    required this.defaultView,
  });

  /// Utworzony projekt w modelu domenowym drzewa.
  final ProjectListItem project;

  /// Czy wynik odtworzono z wcześniej zapisanego wyniku dla tego samego klucza.
  final bool replayed;

  /// Liczba członkostw utworzonych razem z projektem.
  final int memberCount;

  /// Klucze przepisów automatyzacji zainstalowanych razem z projektem.
  final List<String> installedRecipeKeys;

  /// Domyślny widok modułu Zadania zapisany w projekcie.
  final ProjectSetupTaskViewKind defaultView;
}
