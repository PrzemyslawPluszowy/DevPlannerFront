// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get storageNewDocument => 'Nowy dokument';

  @override
  String get storageRouteUnavailableTitle => 'Pliki niedostępne';

  @override
  String get storageRouteInvalidWorkspaceId =>
      'Adres workspace jest nieprawidłowy.';

  @override
  String get storageRouteNotConfigured =>
      'Pliki nie są skonfigurowane dla tej sesji.';

  @override
  String get storageCreateDocumentDialogTitle => 'Utwórz dokument';

  @override
  String get storageDocumentName => 'Nazwa';

  @override
  String get storageDocumentNameHint => 'Na przykład: notatki ze spotkania';

  @override
  String get storageDocumentFormat => 'Format';

  @override
  String get storageCreateDocumentButton => 'Utwórz';

  @override
  String get storageCreateDocumentSuccess => 'Dokument został utworzony.';

  @override
  String get storageFormatTxt => 'Plik tekstowy (.txt)';

  @override
  String get storageFormatOdt => 'Dokument OpenDocument (.odt)';

  @override
  String get storageFormatOds => 'Arkusz OpenDocument (.ods)';

  @override
  String get storageFormatOdp => 'Prezentacja OpenDocument (.odp)';

  @override
  String get storageFormatDocx => 'Dokument Word (.docx)';

  @override
  String get storageFormatXlsx => 'Arkusz Excel (.xlsx)';

  @override
  String get storageFormatPptx => 'Prezentacja PowerPoint (.pptx)';

  @override
  String get appName => 'DevPlanner';

  @override
  String get loginSubtitle => 'Zaloguj się, aby przejść do modułów.';

  @override
  String get loginUsernameLabel => 'Login';

  @override
  String get loginUsernameRequired => 'Wpisz login.';

  @override
  String get loginPasswordLabel => 'Hasło';

  @override
  String get loginPasswordRequired => 'Wpisz hasło.';

  @override
  String get loginRememberCredentials => 'Zapamiętaj login i hasło';

  @override
  String get loginSubmit => 'Zaloguj';

  @override
  String get loginSubmitting => 'Logowanie...';

  @override
  String get loginRedirecting =>
      'Przekierowywanie do bezpiecznego logowania...';

  @override
  String get loginBffDescription =>
      'Logowanie odbywa się w bezpiecznej stronie serwera DevPlanner. Hasło nie jest wpisywane ani przechowywane w aplikacji.';

  @override
  String get loginBffSubmit => 'Przejdź do bezpiecznego logowania';

  @override
  String get loginDesktopUnavailable =>
      'Logowanie desktopowe przez systemową przeglądarkę nie jest jeszcze skonfigurowane.';

  @override
  String get authContractPending =>
      'Uwierzytelnianie czeka na kontrakt backendu standalone.';

  @override
  String get authActivationTitle => 'Aktywacja konta';

  @override
  String get authActivationTokenLabel => 'Token aktywacyjny';

  @override
  String get authActivationPasswordLabel => 'Nowe hasło';

  @override
  String get authResetTitle => 'Reset hasła';

  @override
  String get authResetLoginLabel => 'Login lub e-mail';

  @override
  String get authMfaTitle => 'Weryfikacja MFA';

  @override
  String get authMfaCodeLabel => 'Kod weryfikacyjny';

  @override
  String get authFieldRequired => 'Wpisz wartość.';

  @override
  String get globalUserFallback => 'Użytkownik';

  @override
  String get adminUsersTitle => 'Użytkownicy';

  @override
  String get adminUsersSubtitle => 'Zarządzanie lokalnymi kontami DevPlanner';

  @override
  String get adminUsersUnavailableTitle =>
      'Administracja użytkownikami niedostępna';

  @override
  String get adminUsersUnavailableMessage =>
      'Transport administracji nie został jeszcze skonfigurowany. Ekran nie wyświetla danych zastępczych.';

  @override
  String get adminUsersAccessDeniedTitle => 'Brak uprawnień';

  @override
  String get adminUsersAccessDeniedMessage =>
      'Twoja sesja nie ma uprawnienia do odczytu kont.';

  @override
  String get adminUsersSearchHint => 'Szukaj po loginie, e-mailu lub nazwie';

  @override
  String get adminUsersRefresh => 'Odśwież';

  @override
  String get adminUsersCreate => 'Utwórz konto';

  @override
  String get adminUsersEmptyTitle => 'Brak kont';

  @override
  String get adminUsersEmptyMessage =>
      'Nie znaleziono kont pasujących do bieżących filtrów.';

  @override
  String get adminUsersLoadFailureTitle => 'Nie udało się pobrać kont';

  @override
  String get adminUsersRetry => 'Spróbuj ponownie';

  @override
  String get adminUsersLogin => 'Login';

  @override
  String get adminUsersEmail => 'E-mail';

  @override
  String get adminUsersDisplayName => 'Nazwa wyświetlana';

  @override
  String get adminUsersRoles => 'Role';

  @override
  String get adminUsersStatus => 'Status';

  @override
  String get adminUsersCreateTitle => 'Nowe konto';

  @override
  String get adminUsersEditTitle => 'Edytuj konto';

  @override
  String get adminUsersSave => 'Zapisz';

  @override
  String get adminUsersCancel => 'Anuluj';

  @override
  String get adminUsersRequired => 'Wypełnij wymagane pola.';

  @override
  String get adminUsersRoleSystemAdmin => 'Administrator systemu';

  @override
  String get adminUsersRoleUser => 'Użytkownik';

  @override
  String get adminUsersRoleSave => 'Zapisz role';

  @override
  String get adminUsersReactivate => 'Reaktywuj';

  @override
  String get adminUsersDeactivate => 'Dezaktywuj';

  @override
  String get adminUsersSelfRoleBlocked =>
      'Nie można nadać sobie uprawnienia administratora.';

  @override
  String get adminUsersStatusPendingActivation => 'Oczekuje na aktywację';

  @override
  String get adminUsersStatusActive => 'Aktywne';

  @override
  String get adminUsersStatusDeactivated => 'Dezaktywowane';

  @override
  String get adminUsersStatusLocked => 'Zablokowane';

  @override
  String get adminUsersConfirmAction => 'Potwierdź operację';

  @override
  String get adminUsersConfirmActionMessage => 'Ta operacja zmieni stan konta.';

  @override
  String get globalModuleDashboard => 'Dashboard';

  @override
  String get globalModuleInventory => 'Inwentaryzacja';

  @override
  String get globalModuleBhp => 'BHP';

  @override
  String get globalModuleWorkspaces => 'Workspaces';

  @override
  String get appShellChangelogTitle => 'Dziennik zmian';

  @override
  String get appShellChangelogLoadError =>
      'Nie udało się wczytać dziennika zmian.';

  @override
  String get appShellChangelogEmpty => 'Brak wpisów w dzienniku zmian.';

  @override
  String get appShellChangelogShowAll => 'Pokaż wszystkie wpisy';

  @override
  String get appShellBrandName => 'DevPlanner';

  @override
  String get appShellCommandPaletteUnavailable =>
      'Wyszukiwanie globalne wkrótce dostępne';

  @override
  String get appModalDismiss => 'Zamknij okno';

  @override
  String get workspacesMenuTitle => 'Workspaces';

  @override
  String get workspacesMenuSubtitle => 'Przestrzenie, projekty i współpraca';

  @override
  String get workspacesSectionOverview => 'Przegląd';

  @override
  String get workspacesSectionProjects => 'Projekty';

  @override
  String get workspacesNoProjects => 'Brak projektów';

  @override
  String get workspacesMenuCreateProject => 'Utwórz pierwszy projekt';

  @override
  String get workspacesMenuAdd => 'Dodaj';

  @override
  String get workspacesTaskList => 'Lista';

  @override
  String get workspacesMenuCreateTask => 'Dodaj zadanie';

  @override
  String get workspacesTaskKanban => 'Kanban';

  @override
  String get workspacesTaskAutomations => 'Automatyzacje';

  @override
  String get workspacesProjectCorkboard => 'Tablica korkowa';

  @override
  String get workspaceShellTitle => 'Workspace';

  @override
  String get workspaceShellSubtitle => 'Przestrzeń robocza';

  @override
  String get workspaceShellCollapseMenu => 'Zwiń menu';

  @override
  String get workspaceShellExpandMenu => 'Rozwiń menu';

  @override
  String get workspaceNavigationCollapseBranch => 'Zwiń gałąź';

  @override
  String get workspaceNavigationExpandBranch => 'Rozwiń gałąź';

  @override
  String get workspaceShellNavigationTitle => 'Workspace';

  @override
  String get workspaceShellDashboard => 'Dashboard';

  @override
  String get workspaceShellProjects => 'Projekty';

  @override
  String get workspaceShellProjectsPlaceholder =>
      'Lista projektów pojawi się tutaj';

  @override
  String get workspaceShellDashboardDescription =>
      'Szkielet dashboardu — dane i widgety podłączymy po ustaleniu kontraktów.';

  @override
  String get workspaceShellWidgetProjects => 'Projekty';

  @override
  String get workspaceShellWidgetTasks => 'Zadania';

  @override
  String get workspaceShellWidgetActivity => 'Aktywność';

  @override
  String get workspaceShellBackToDirectory => 'Wróć do katalogu workspace’ów';

  @override
  String get workspacesSectionTasks => 'Zadania';

  @override
  String get workspacesSectionFiles => 'Pliki i dokumenty';

  @override
  String get workspacesSectionChat => 'Chat';

  @override
  String get workspacesSectionWhiteboards => 'Whiteboardy';

  @override
  String get workspacesSectionWiki => 'Wiki';

  @override
  String get workspacesSectionNotifications => 'Powiadomienia';

  @override
  String get workspacesSectionPending =>
      'Struktura sekcji jest gotowa. Kolejny ekran zostanie podłączony do właściwego kontraktu backendu Workspaces.';

  @override
  String get workspacesEmptyTitle => 'Nie masz jeszcze żadnego workspace’u';

  @override
  String get workspacesEmptyMessage =>
      'Workspace’y dostępne dla Twojego konta pojawią się tutaj.';

  @override
  String get workspacesErrorTitle => 'Nie udało się pobrać workspace’ów';

  @override
  String get workspacesForbiddenTitle => 'Brak dostępu do workspace’ów';

  @override
  String get workspacesSessionTitle => 'Sesja wymaga ponownego zalogowania';

  @override
  String get workspacesTransportUnavailableTitle =>
      'Transport workspace niedostępny';

  @override
  String get workspacesTransportUnavailableMessage =>
      'Transport workspace nie został jeszcze skonfigurowany.';

  @override
  String get workspacesSessionMessage =>
      'Zaloguj się ponownie, aby pobrać swoje workspace’y.';

  @override
  String get workspacesForbiddenMessage =>
      'Nie masz uprawnień do odczytu workspace’ów.';

  @override
  String get workspacesRequestFailedMessage =>
      'Serwer nie zwrócił listy workspace’ów. Spróbuj ponownie.';

  @override
  String get workspacesInvalidResponseMessage =>
      'Serwer zwrócił nieprawidłowe dane workspace’ów.';

  @override
  String workspacesHttpStatus(int statusCode) {
    return 'Kod HTTP: $statusCode';
  }

  @override
  String get workspacesRefresh => 'Odśwież';

  @override
  String get workspacesRetry => 'Spróbuj ponownie';

  @override
  String get workspacesCreatePrivateWorkspace => 'Utwórz prywatny workspace';

  @override
  String get workspacesCreateWorkspace => 'Utwórz workspace';

  @override
  String get workspacesCreateWorkspaceTitle => 'Nowy workspace';

  @override
  String get workspacesCreateWorkspaceSubtitle =>
      'Wpisz nazwę i utwórz nową przestrzeń roboczą.';

  @override
  String get workspacesEditWorkspaceTitle => 'Edytuj workspace';

  @override
  String get workspacesEditWorkspaceSubtitle =>
      'Wpisz nową nazwę i dostosuj wygląd przestrzeni roboczej.';

  @override
  String get workspacesNameFieldLabel => 'Nazwa workspace’u';

  @override
  String get workspacesNameFieldPlaceholder =>
      'np. Marketing, Projekt A, Finanse';

  @override
  String get workspacesNameRequiredError => 'Nazwa nie może być pusta';

  @override
  String get workspacesPickIconLabel => 'Wybierz ikonę';

  @override
  String get workspacesAccentColorLabel => 'Kolor akcentu';

  @override
  String get workspacesCancelButton => 'Anuluj';

  @override
  String get workspacesCreateButton => 'Utwórz';

  @override
  String get workspacesSaveButton => 'Zapisz';

  @override
  String get workspacesCreateProjectTitle => 'Nowy projekt';

  @override
  String get workspacesCreateProjectSubtitle =>
      'Utwórz projekt i zorganizuj pracę zespołu.';

  @override
  String get workspacesProjectNameLabel => 'Nazwa projektu *';

  @override
  String get workspacesProjectNameHint =>
      'np. Rozwój Aplikacji Mobilnej, Wdrożenie ERP...';

  @override
  String get workspacesProjectNameRequired => 'Wprowadź nazwę projektu';

  @override
  String get workspacesProjectDescriptionLabel => 'Opis projektu (opcjonalnie)';

  @override
  String get workspacesProjectDescriptionHint =>
      'Cel projektu, zakres lub założenia...';

  @override
  String get workspacesProjectVisibilityLabel => 'Widoczność projektu';

  @override
  String get workspacesProjectVisibilityShared =>
      'Dla wszystkich w przestrzeni';

  @override
  String get workspacesProjectVisibilityPrivate => 'Prywatny';

  @override
  String get workspacesCreateWhiteboardTitle => 'Nowa tablica interaktywna';

  @override
  String get workspacesCreateWhiteboardSubtitle =>
      'Utwórz Whiteboard do szkicowania, diagramów i burzy mózgów.';

  @override
  String get workspacesWhiteboardNameLabel => 'Nazwa tablicy *';

  @override
  String get workspacesWhiteboardNameHint =>
      'np. Architektura systemu, User Journey Map...';

  @override
  String get workspacesWhiteboardNameRequired => 'Wprowadź nazwę tablicy';

  @override
  String get workspacesWhiteboardFormatLabel => 'Format tablicy';

  @override
  String get workspacesWhiteboardFormatCanvas => 'Nieskończony Canvas';

  @override
  String get workspacesWhiteboardFormatA4 => 'Dokument A4';

  @override
  String get workspacesMenuCreateWhiteboard => 'Utwórz tablicę';

  @override
  String get workspacesMenuAddAnotherWhiteboard => 'Dodaj kolejną tablicę';

  @override
  String get workspacesCreateTaskTitle => 'Nowe zadanie';

  @override
  String get workspacesCreateTaskSubtitle =>
      'Dodaj zadanie do workflow projektu.';

  @override
  String get workspacesTaskTitleLabel => 'Tytuł zadania *';

  @override
  String get workspacesTaskTitleHint => 'Tytuł zadania...';

  @override
  String get workspacesTaskTitleRequired => 'Wprowadź tytuł zadania';

  @override
  String get workspacesTaskDescriptionLabel => 'Opis zadania (opcjonalnie)';

  @override
  String get workspacesTaskDescriptionHint =>
      'Dodaj szczegóły, kroki reprodukcji lub kryteria...';

  @override
  String get workspacesTaskPriorityLabel => 'Priorytet';

  @override
  String get workspacesTaskPriorityLow => 'Niski';

  @override
  String get workspacesTaskPriorityNormal => 'Normalny';

  @override
  String get workspacesTaskPriorityHigh => 'Wysoki';

  @override
  String get workspacesTaskPriorityCritical => 'Krytyczny';

  @override
  String get workspacesTaskStatusLabel => 'Status początkowy';

  @override
  String get workspacesTaskStatusTodo => 'Do zrobienia';

  @override
  String get workspacesTaskStatusInProgress => 'W toku';

  @override
  String get workspacesTaskStatusBacklog => 'Backlog';

  @override
  String get workspacesCreateWikiTitle => 'Nowa strona Wiki';

  @override
  String get workspacesCreateWikiSubtitle =>
      'Dodaj artykuł do bazy wiedzy projektu.';

  @override
  String get workspacesWikiTitleLabel => 'Tytuł strony *';

  @override
  String get workspacesWikiTitleHint =>
      'np. Wymagania techniczne, Standardy kodu...';

  @override
  String get workspacesWikiTitleRequired => 'Wprowadź tytuł strony';

  @override
  String get workspacesCreateCorkboardTitle => 'Przypnij notatkę';

  @override
  String get workspacesCreateCorkboardSubtitle =>
      'Dodaj karteczkę na tablicę korkową projektu.';

  @override
  String get workspacesCorkboardTitleLabel => 'Nagłówek notatki *';

  @override
  String get workspacesCorkboardTitleHint => 'Krótki tytuł...';

  @override
  String get workspacesCorkboardTitleRequired => 'Wprowadź nagłówek';

  @override
  String get workspacesCorkboardContentLabel => 'Treść notatki (opcjonalnie)';

  @override
  String get workspacesCorkboardContentHint =>
      'Wpisz treść notatki lub przypomnienia...';

  @override
  String get workspacesCorkboardColorLabel => 'Kolor karteczki';

  @override
  String get workspacesCreateFolderTitle => 'Nowy folder';

  @override
  String get workspacesCreateFolderSubtitle =>
      'Utwórz folder w repozytorium plików projektu.';

  @override
  String get workspacesFolderNameLabel => 'Nazwa folderu *';

  @override
  String get workspacesFolderNameHint =>
      'np. Dokumentacja, Załączniki, Makiety...';

  @override
  String get workspacesFolderNameRequired => 'Wprowadź nazwę folderu';

  @override
  String get workspacesEditAction => 'Edytuj';

  @override
  String get workspacesPinAction => 'Przypnij do ulubionych';

  @override
  String get workspacesUnpinAction => 'Odepnij z ulubionych';

  @override
  String get workspacesHideAction => 'Ukryj z listy';

  @override
  String get workspacesShowAction => 'Przywróć na listę';

  @override
  String get workspacesMyTasksLabel => 'Moje zadania';

  @override
  String get workspacesMyFilesLabel => 'Moje pliki';

  @override
  String get workspacesMyPrivateSectionLabel => 'Prywatne';

  @override
  String get workspacesMyWorkspacesSection => 'Moje workspace’y';

  @override
  String workspacesFavoritesSection(int count) {
    return 'Ulubione ($count)';
  }

  @override
  String workspacesTeamWorkspacesSection(int count) {
    return 'Przestrzenie zespołowe ($count)';
  }

  @override
  String get workspacesAllWorkspacesSection => 'Wszystkie workspace’y';

  @override
  String get workspacesHiddenWorkspacesLabel => 'Ukryte workspace’y';

  @override
  String get workspacesOwnerBadge => 'Właściciel';

  @override
  String get workspacesSharedBadge => 'Współdzielony';

  @override
  String get workspacesPersonalBadge => 'Prywatny';

  @override
  String get globalModuleOther => 'Inne';

  @override
  String get globalModuleOrders => 'Zamówienia';

  @override
  String get globalModuleSettings => 'Ustawienia';

  @override
  String get globalActionSettings => 'Ustawienia';

  @override
  String get globalActionLogout => 'Wyloguj';

  @override
  String get appDashboardTitle => 'Dashboard';

  @override
  String get appDashboardSubtitle =>
      'Główny ekran aplikacji agregujący moduły i przyszłe obszary systemu.';

  @override
  String get appDashboardPlaceholderTitle => 'Nowy moduł główny';

  @override
  String get appDashboardPlaceholderMessage =>
      'To jest nowy, nadrzędny dashboard aplikacji. W kolejnym kroku można tu zaprojektować wspólny widok dla Inwentaryzacji, BHP i przyszłych modułów.';

  @override
  String get dashboardContextMenuChangeWallpaper => 'Zmień tapetę';

  @override
  String get dashboardContextMenuManageShortcuts => 'Zarządzaj skrótami';

  @override
  String get dashboardContextMenuAddWidget => 'Dodaj widget';

  @override
  String get dashboardContextMenuAutoArrange => 'Automatyczne rozmieszczenie';

  @override
  String get dashboardContextMenuSnapToGrid => 'Wyrównuj do siatki';

  @override
  String get dashboardCollapsedTrayTitle => 'Zasobnik pulpitu';

  @override
  String get dashboardCollapsedTraySubtitle =>
      'Elementy ukryte z powodu małego rozmiaru okna. Zwiększ rozmiar okna, aby automatycznie przywrócić je na pulpit.';

  @override
  String dashboardCollapsedTrayWidgets(int count) {
    return 'Widgety ($count)';
  }

  @override
  String dashboardCollapsedTrayShortcuts(int count) {
    return 'Skróty ($count)';
  }

  @override
  String get dashboardCollapsedTrayNoItems =>
      'Wszystkie elementy mieszczą się na ekranie.';

  @override
  String get dashboardWidgetRefreshTooltip => 'Odśwież';

  @override
  String get dashboardWidgetResizeTitle => 'Zmień rozmiar';

  @override
  String dashboardWidgetResizeLabel(Object size) {
    return 'Rozmiar $size';
  }

  @override
  String get dashboardWidgetRemoveAction => 'Usuń z pulpitu';

  @override
  String get dashboardWidgetBringToFront => 'Przesuń na wierzch';

  @override
  String get dashboardWidgetSendToBack => 'Przesuń pod spód';

  @override
  String get dashboardWidgetCategoryAll => 'Wszystkie';

  @override
  String get dashboardWidgetCategoryGeneral => 'Ogólne';

  @override
  String get dashboardWidgetPickerTitle => 'Dodaj widget';

  @override
  String get dashboardWidgetPickerCloseTooltip => 'Zamknij';

  @override
  String get dashboardWidgetPickerAddButton => 'Dodaj widget';

  @override
  String get dashboardWidgetPickerNoSpaceMessage =>
      'Brak wolnego miejsca na pulpicie.';

  @override
  String get dashboardWidgetPickerPreviewTitle => 'PODGLĄD WIDGETU';

  @override
  String get dashboardWallpaperPickerTitle => 'Zmień tapetę';

  @override
  String get dashboardWallpaperPickerSubtitle =>
      'Wybierz jedną z dostępnych tapet pulpitu.';

  @override
  String get dashboardShortcutRenameTitle => 'Zmień nazwę skrótu';

  @override
  String get dashboardShortcutRenameSubtitle =>
      'Nowy podpis będzie widoczny pod ikoną na pulpicie.';

  @override
  String get dashboardShortcutRenameFieldLabel => 'Nowa nazwa';

  @override
  String get dashboardShortcutRenameCancel => 'Anuluj';

  @override
  String get dashboardShortcutRenameSave => 'Zapisz';

  @override
  String get dashboardShortcutsPanelTitle => 'Dostępne moduły';

  @override
  String get dashboardShortcutsPanelCloseTooltip => 'Zamknij';

  @override
  String get dashboardShortcutsPanelSubtitle =>
      'Kliknij moduł, aby dodać go w wolne miejsce na pulpicie, lub przeciągnij jego ikonę bezpośrednio na tapetę.';

  @override
  String get dashboardShortcutsPanelRenameAction => 'Zmień nazwę';

  @override
  String get dashboardShortcutsPanelRemoveAction => 'Usuń z pulpitu';

  @override
  String get dashboardShortcutsPickerTitle => 'Dostępne moduły';

  @override
  String get dashboardShortcutsPickerCloseTooltip => 'Zamknij';

  @override
  String get dashboardShortcutsPickerInstruction =>
      'Kliknij moduł, aby dodać go w wolne miejsce na pulpicie, lub przeciągnij jego ikonę bezpośrednio na tapetę.';

  @override
  String get dashboardShortcutsPickerVisibleLabel => 'Widoczny';

  @override
  String get dashboardShortcutsPickerDragHint => 'Kliknij / przeciągnij ikonę';

  @override
  String get dashboardQuickActionsName => 'Szybkie akcje';

  @override
  String get dashboardQuickActionsDescription =>
      'Umożliwia błyskawiczne przejście do kluczowych formularzy i funkcji systemu.';

  @override
  String get dashboardQuickActionsCategory => 'Ogólne';

  @override
  String get dashboardQuickActionsInventoryAction => 'Inwentaryzacja';

  @override
  String get dashboardQuickActionsBhpAction => 'Zgłoszenie BHP';

  @override
  String get dashboardQuickActionsSettingsAction => 'Ustawienia';

  @override
  String get dashboardStartupModuleName => 'Autostart aplikacji';

  @override
  String get dashboardStartupModuleDescription =>
      'Wybierz, który moduł ma się otworzyć automatycznie po włączeniu aplikacji.';

  @override
  String get dashboardStartupModuleCategory => 'Ogólne';

  @override
  String get dashboardActiveInventoriesName => 'Inwentaryzacje w toku';

  @override
  String get dashboardActiveInventoriesDescription =>
      'Lista aktywnych inwentaryzacji, które są obecnie w toku na oddziałach.';

  @override
  String get dashboardActiveInventoriesCategory => 'Inwentaryzacja';

  @override
  String get dashboardActiveInventoriesErrorTitle => 'Błąd pobierania danych';

  @override
  String get dashboardActiveInventoriesRetryLabel => 'Spróbuj ponownie';

  @override
  String get dashboardActiveInventoriesEmptyTitle =>
      'Brak inwentaryzacji w toku';

  @override
  String dashboardActiveInventoriesSheetsLabel(int count) {
    return 'Arkusze: $count';
  }

  @override
  String get dashboardBhpUsersName => 'BHP: pracownicy';

  @override
  String get dashboardBhpUsersDescription =>
      'Szybki podgląd pracowników BHP z przejściem do modułu listy pracowników.';

  @override
  String get dashboardBhpUsersCategory => 'BHP';

  @override
  String get dashboardBhpUsersErrorTitle => 'Nie udało się pobrać pracowników';

  @override
  String get dashboardBhpUsersSectionTitle => 'Pracownicy BHP';

  @override
  String get dashboardBhpUsersEmptyTitle => 'Brak pracowników';

  @override
  String get dashboardBhpUsersEmptyMessage =>
      'Nie znaleziono żadnych aktywnych pracowników.';

  @override
  String get dashboardBhpUsersNoPositionLabel => 'Bez stanowiska';

  @override
  String dashboardBhpUsersDeadlineOverdueLabel(int days) {
    return 'po $days dni';
  }

  @override
  String get dashboardBhpUsersDeadlineTodayLabel => 'dziś';

  @override
  String dashboardBhpUsersDeadlineUpcomingLabel(int days) {
    return 'za $days dni';
  }

  @override
  String dashboardBhpUsersDeadlineOverdueCountLabel(int count) {
    return '$count po terminie';
  }

  @override
  String dashboardBhpUsersDeadlineUpcomingCountLabel(int count) {
    return '$count wkrótce';
  }

  @override
  String get dashboardBhpUsersDeadlineOkLabel => 'ok';

  @override
  String get dashboardBhpPositionsName => 'BHP: stanowiska';

  @override
  String get dashboardBhpPositionsDescription =>
      'Szybki podgląd stanowisk BHP z wejściem do pełnej listy stanowisk.';

  @override
  String get dashboardBhpPositionsCategory => 'BHP';

  @override
  String get dashboardBhpPositionsErrorTitle =>
      'Nie udało się pobrać stanowisk';

  @override
  String get dashboardBhpPositionsSectionTitle => 'Stanowiska BHP';

  @override
  String get dashboardBhpPositionsEmptyTitle => 'Brak stanowisk';

  @override
  String get dashboardBhpPositionsEmptyMessage =>
      'Nie znaleziono aktywnych stanowisk.';

  @override
  String get dashboardBhpPositionsNoNotesLabel => 'Bez uwag';

  @override
  String get dashboardBhpPositionsActiveLabel => 'aktywne';

  @override
  String get dashboardBhpPositionsInactiveLabel => 'nieaktywne';

  @override
  String get dashboardBhpEquipmentName => 'BHP: wyposażenie';

  @override
  String get dashboardBhpEquipmentDescription =>
      'Szybki podgląd katalogu wyposażenia BHP z wejściem do pełnej listy.';

  @override
  String get dashboardBhpEquipmentCategory => 'BHP';

  @override
  String get dashboardBhpEquipmentErrorTitle =>
      'Nie udało się pobrać wyposażenia';

  @override
  String get dashboardBhpEquipmentSectionTitle => 'Wyposażenie BHP';

  @override
  String get dashboardBhpEquipmentEmptyTitle => 'Brak wyposażenia';

  @override
  String get dashboardBhpEquipmentEmptyMessage =>
      'Nie znaleziono aktywnego wyposażenia.';

  @override
  String get dashboardBhpEquipmentNoPeriodLabel => 'Brak okresu';

  @override
  String get dashboardBhpEquipmentActiveLabel => 'aktywne';

  @override
  String get dashboardBhpUpcomingName => 'BHP: nadchodzące';

  @override
  String get dashboardBhpUpcomingDescription =>
      'Lista alertów BHP, które zbliżają się do terminu i wymagają przygotowania.';

  @override
  String get dashboardBhpUpcomingCategory => 'BHP';

  @override
  String get dashboardBhpUpcomingErrorTitle =>
      'Nie udało się pobrać alertów nadchodzących';

  @override
  String get dashboardBhpUpcomingRefreshLabel => 'Odśwież';

  @override
  String get dashboardBhpUpcomingSectionTitle => 'Nadchodzące';

  @override
  String get dashboardBhpUpcomingEmptyTitle => 'Brak alertów nadchodzących';

  @override
  String get dashboardBhpUpcomingEmptyMessage =>
      'Nie ma pozycji zbliżających się do terminu.';

  @override
  String get dashboardBhpOverdueName => 'BHP: po terminie';

  @override
  String get dashboardBhpOverdueDescription =>
      'Lista najbardziej pilnych alertów BHP, które są już po terminie.';

  @override
  String get dashboardBhpOverdueCategory => 'BHP';

  @override
  String get dashboardBhpOverdueErrorTitle =>
      'Nie udało się pobrać alertów po terminie';

  @override
  String get dashboardBhpOverdueRefreshLabel => 'Odśwież';

  @override
  String get dashboardBhpOverdueSectionTitle => 'Po terminie';

  @override
  String get dashboardBhpOverdueEmptyTitle => 'Brak alertów po terminie';

  @override
  String get dashboardBhpOverdueEmptyMessage =>
      'Wszystkie pozycje BHP mieszczą się w terminach.';

  @override
  String get dashboardInventorySummaryName => 'Statystyki inwentaryzacji';

  @override
  String get dashboardInventorySummaryDescription =>
      'Podgląd postępu inwentaryzacji, aktywnych arkuszy i ostatnich odczytów.';

  @override
  String get dashboardInventorySummaryCategory => 'Inwentaryzacja';

  @override
  String get dashboardInventorySummaryActiveSheetsLabel => 'Aktywne arkusze';

  @override
  String get dashboardInventorySummaryCompletedLabel => 'Ukończone';

  @override
  String get dashboardInventorySummaryProgressLabel => 'Postęp całkowity';

  @override
  String get settingsHeaderTitle => 'Ustawienia aplikacji';

  @override
  String get settingsHeaderSubtitle =>
      'Lokalna konfiguracja wspólna dla wszystkich modułów. To miejsce będzie rozszerzane o język, preferencje i ustawienia modułowe.';

  @override
  String get settingsCategoriesTitle => 'Kategorie';

  @override
  String get settingsCategoriesSubtitle => 'Wybierz obszar konfiguracji';

  @override
  String get settingsSectionAppearanceTitle => 'Wygląd';

  @override
  String get settingsSectionAppearanceSubtitle => 'Motyw i kolorystyka';

  @override
  String get settingsSectionLanguageTitle => 'Język';

  @override
  String get settingsSectionLanguageSubtitle => 'Język aplikacji';

  @override
  String get settingsSectionModulesTitle => 'Moduły';

  @override
  String get settingsSectionModulesSubtitle =>
      'Start i zachowanie po logowaniu';

  @override
  String get settingsStartupModuleTitle => 'Auto start modułu';

  @override
  String get settingsStartupModuleSubtitle =>
      'Po zalogowaniu aplikacja zawsze pokaże dashboard, a następnie automatycznie przejdzie do wybranego modułu.';

  @override
  String get settingsStartupModuleDashboardSubtitle =>
      'Zostań na dashboardzie po zalogowaniu';

  @override
  String get settingsStartupModuleInventorySubtitle =>
      'Po dashboardzie otwórz moduł inwentaryzacji';

  @override
  String get settingsStartupModuleBhpSubtitle =>
      'Po dashboardzie otwórz moduł BHP';

  @override
  String get settingsStartupModuleSettingsSubtitle =>
      'Po dashboardzie otwórz ustawienia aplikacji';

  @override
  String get settingsLanguageTitle => 'Język';

  @override
  String get settingsLanguageSubtitle => 'Wybierz główny język interfejsu.';

  @override
  String get settingsLanguagePolish => 'Polski';

  @override
  String get settingsLanguagePolishSubtitle => 'Domyślny język dla organizacji';

  @override
  String get settingsLanguageEnglish => 'Angielski (English)';

  @override
  String get settingsLanguageEnglishSubtitle =>
      'Drugi język dla użytkowników międzynarodowych';

  @override
  String get settingsAppearanceModeTitle => 'Tryb motywu';

  @override
  String get settingsAppearanceModeSubtitle =>
      'Wybierz sposób przełączania jasnego i ciemnego widoku.';

  @override
  String get settingsThemeSystem => 'Systemowy';

  @override
  String get settingsThemeSystemSubtitle => 'Dopasowanie do ustawienia systemu';

  @override
  String get settingsThemeLight => 'Jasny';

  @override
  String get settingsThemeLightSubtitle => 'Stały jasny interfejs';

  @override
  String get settingsThemeDark => 'Ciemny';

  @override
  String get settingsThemeDarkSubtitle => 'Stały ciemny interfejs';

  @override
  String get settingsPaletteTitle => 'Kolorystyka';

  @override
  String get settingsPaletteSubtitle => 'Wariant palety dla całej aplikacji.';

  @override
  String get settingsPaletteClassicTitle => 'Classic';

  @override
  String get settingsPaletteClassicSubtitle =>
      'Neutralny niebieski, najbardziej domyślny';

  @override
  String get settingsPaletteMaterialTitle => 'Material';

  @override
  String get settingsPaletteMaterialSubtitle =>
      'Systemowy Material 3 generowany przez ColorScheme.fromSeed';

  @override
  String get settingsSeedColorTitle => 'Kolor bazowy Material';

  @override
  String get settingsSeedColorSubtitle =>
      'Wybierz seed color dla palety Material.';

  @override
  String get settingsSeedColorBlueTitle => 'Blue';

  @override
  String get settingsSeedColorBlueSubtitle =>
      'Najbliżej obecnego stylu aplikacji';

  @override
  String get settingsSeedColorEmeraldTitle => 'Emerald';

  @override
  String get settingsSeedColorEmeraldSubtitle =>
      'Chłodny zielono-turkusowy wariant';

  @override
  String get settingsSeedColorAmberTitle => 'Amber';

  @override
  String get settingsSeedColorAmberSubtitle =>
      'Ciepły pomarańczowo-złoty wariant';

  @override
  String get settingsSeedColorRoseTitle => 'Rose';

  @override
  String get settingsSeedColorRoseSubtitle => 'Delikatny malinowy akcent';

  @override
  String get settingsSeedColorVioletTitle => 'Violet';

  @override
  String get settingsSeedColorVioletSubtitle => 'Chłodny fioletowy wariant';

  @override
  String get settingsSeedColorTealTitle => 'Teal';

  @override
  String get settingsSeedColorTealSubtitle =>
      'Morski, bardziej nasycony wariant';

  @override
  String get settingsSeedColorIndigoTitle => 'Indigo';

  @override
  String get settingsSeedColorIndigoSubtitle =>
      'Głęboki granatowo-fioletowy wariant';

  @override
  String get settingsSeedColorOrangeTitle => 'Orange';

  @override
  String get settingsSeedColorOrangeSubtitle =>
      'Energetyczny pomarańczowy wariant';

  @override
  String get settingsSeedColorCrimsonTitle => 'Crimson';

  @override
  String get settingsSeedColorCrimsonSubtitle => 'Mocny karmazynowy akcent';

  @override
  String get close => 'Zamknij';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get inventoryModuleTitle => 'Inwentaryzacja';

  @override
  String get inventorySectionInventories => 'Inwentaryzacje';

  @override
  String get inventoryInventoriesSubtitle =>
      'Lista aktywnych i archiwalnych rekordów.';

  @override
  String get inventoryNew => 'Nowa';

  @override
  String get inventorySectionAssetState => 'Stan ST';

  @override
  String get inventoryCurrentState => 'Aktualny stan';

  @override
  String get inventorySectionLocations => 'Miejsca';

  @override
  String get inventorySectionCompanies => 'Firmy';

  @override
  String get inventorySidebarSubtitle => 'Zarządzaj zasobami i spisami';

  @override
  String get inventoryUiGallery => 'UI Gallery';

  @override
  String get inventoryRefresh => 'Odśwież';

  @override
  String get inventoryNoNumber => 'Bez numeru';

  @override
  String get inventoryDateRangeLabel => 'Zakres';

  @override
  String inventoryPeopleCount(int count) {
    return '$count osób';
  }

  @override
  String get inventoryFetchErrorTitle => 'Błąd pobierania';

  @override
  String inventoryActionNotConnected(Object label) {
    return 'Akcja \"$label\" zostanie podpięta do API.';
  }

  @override
  String get inventoryOverviewTitle => 'Stan ST';

  @override
  String get inventoryOverviewSubtitle =>
      'Szybkie filtrowanie i lista środków trwałych.';

  @override
  String get inventorySearch => 'Szukaj';

  @override
  String get inventoryLoadingErrorTitle => 'Błąd ładowania';

  @override
  String get inventoryOverviewSearchHintName =>
      'Wpisz nazwę środka trwałego...';

  @override
  String get inventoryOverviewSearchHintRegisterNumber =>
      'Wpisz numer ewidencyjny...';

  @override
  String get inventoryOverviewSearchHintBarcode => 'Wpisz kod kreskowy...';

  @override
  String get inventoryOverviewSearchHintGlobal =>
      'Nazwa, nr ewid., osoba, miejsce lub kod...';

  @override
  String get inventoryCompany => 'Firmy/Oddziały';

  @override
  String get inventoryAll => 'Wszystkie';

  @override
  String get inventoryAllCompanies => 'Wszystkie firmy';

  @override
  String get inventorySearchBy => 'Szukaj po';

  @override
  String get inventorySearchSheetsAction => 'Przeszukaj arkusze';

  @override
  String get inventorySearchSheetsTitle => 'Wyszukiwanie w arkuszach';

  @override
  String inventorySearchSheetsSubtitle(Object number) {
    return 'Inwentaryzacja $number';
  }

  @override
  String get inventorySearchSheetsHint =>
      'Nr ewidencyjny, nazwa, osoba lub kod...';

  @override
  String get inventorySearchSheetsSortByRegisterNumber => 'Nr ewid.';

  @override
  String get inventorySearchSheetsSortByName => 'Nazwa';

  @override
  String get inventorySearchSheetsSortByMatches => 'Liczba trafień';

  @override
  String get inventorySearchSheetsStartTitle => 'Zacznij wyszukiwanie';

  @override
  String get inventorySearchSheetsStartMessage =>
      'Wpisz co najmniej 2 znaki, aby przeszukać wszystkie arkusze tej inwentaryzacji.';

  @override
  String inventorySearchSheetsResultsCount(int groups, int matches) {
    return 'Grupy: $groups, trafienia: $matches';
  }

  @override
  String inventorySearchSheetsMatchesCount(int count) {
    return '$count trafień';
  }

  @override
  String get inventorySearchSheetsCurrentSheet => 'Bieżący arkusz';

  @override
  String get inventorySearchSheetsFocusCurrentAction => 'Pokaż w arkuszu';

  @override
  String get inventorySearchSheetsOpenSheetAction => 'Otwórz arkusz';

  @override
  String get inventorySearchSheetsToDisposeStatus => 'Do likwidacji';

  @override
  String get inventoryPresenceConflictsTitle => 'Konflikty obecności';

  @override
  String inventoryPresenceConflictsSubtitle(Object number) {
    return 'Inwentaryzacja $number';
  }

  @override
  String get inventoryPresenceConflictsLoadingLabel => 'Sprawdzam konflikty';

  @override
  String get inventoryPresenceConflictsRetryLabel => 'Pokaż konflikty';

  @override
  String get inventoryPresenceConflictsEmptyBadge =>
      'Brak wykrytych konfliktów';

  @override
  String inventoryPresenceConflictsDetectedAction(int count) {
    return '$count konfliktów';
  }

  @override
  String inventoryPresenceConflictsResultsCount(int count) {
    return 'Konflikty: $count';
  }

  @override
  String inventoryPresenceConflictsArkuszeCount(int count) {
    return '$count arkusze';
  }

  @override
  String get inventoryPresenceConflictsEmptyTitle =>
      'Brak wykrytych konfliktów';

  @override
  String get inventoryPresenceConflictsEmptyMessage =>
      'Ta inwentaryzacja nie ma obecnie żadnych środków trwałych wykrytych w wielu arkuszach jako nie-brak.';

  @override
  String get inventorySurplusConflictsTitle => 'Konflikty nadwyżek';

  @override
  String inventorySurplusConflictsSubtitle(Object number) {
    return 'Inwentaryzacja $number';
  }

  @override
  String get inventorySurplusConflictsLoadingLabel => 'Sprawdzam nadwyżki';

  @override
  String get inventorySurplusConflictsRetryLabel => 'Pokaż nadwyżki';

  @override
  String get inventorySurplusConflictsEmptyBadge => 'Brak konfliktów nadwyżek';

  @override
  String inventorySurplusConflictsDetectedAction(int count) {
    return '$count nadwyżek bez pary';
  }

  @override
  String inventorySurplusConflictsResultsCount(int count) {
    return 'Nadwyżki bez pary: $count';
  }

  @override
  String get inventorySurplusConflictsEmptyTitle => 'Brak konfliktów nadwyżek';

  @override
  String get inventorySurplusConflictsEmptyMessage =>
      'Ta inwentaryzacja nie ma obecnie żadnych nadwyżek bez odpowiadającego braku w innych arkuszach.';

  @override
  String get inventorySurplusConflictsMatchBasisLabel => 'Parowanie po';

  @override
  String get inventorySurplusConflictsMatchBasisRegisterNumber =>
      'Nr ewidencyjny';

  @override
  String get inventorySurplusConflictsMatchBasisBarcode => 'Kod kreskowy';

  @override
  String get inventoryDuplicateConflictsTitle =>
      'Duplikaty numerów ewidencyjnych';

  @override
  String get inventoryDuplicateConflictsSubtitle =>
      'Wykryte duplikaty numerów ewidencyjnych w stan_st.';

  @override
  String get inventoryDuplicateConflictsRetryLabel => 'Pokaż duplikaty';

  @override
  String inventoryDuplicateConflictsSummary(Object groups, Object records) {
    return 'Grupy: $groups • Rekordy: $records';
  }

  @override
  String inventoryDuplicateConflictsDetected(int count) {
    return 'Wykryto $count grup duplikatów';
  }

  @override
  String inventoryDuplicateConflictsVisibleResults(int groups, int records) {
    return 'Widoczne: $groups grup • $records rekordów';
  }

  @override
  String get inventoryDuplicateConflictsFetchError =>
      'Nie udało się pobrać duplikatów stan_st.';

  @override
  String get inventoryDuplicateConflictsEmptyTitle =>
      'Brak duplikatów numerów ewidencyjnych';

  @override
  String get inventoryDuplicateConflictsEmptyMessage =>
      'W aktualnym snapshotcie stan_st nie znaleziono duplikatów numerów ewidencyjnych.';

  @override
  String inventoryDuplicateGroupRecordsCount(int count) {
    return '$count rekordy';
  }

  @override
  String inventoryDuplicateCompaniesLabel(Object list) {
    return 'Firmy: $list';
  }

  @override
  String inventoryDuplicateVariantsLabel(Object variants) {
    return 'Warianty: $variants';
  }

  @override
  String get inventoryDuplicateCopiedRegisterToast =>
      'Skopiowano numer ewidencyjny.';

  @override
  String get inventoryImport => 'Import';

  @override
  String get inventoryName => 'Nazwa';

  @override
  String get inventoryRegisterNumber => 'Nr ewidencyjny';

  @override
  String get inventoryRegisterNumberShort => 'Nr ewid.';

  @override
  String get inventoryBarcode => 'Kod kreskowy';

  @override
  String get inventoryNoName => 'Bez nazwy';

  @override
  String get inventoryPerson => 'Osoba';

  @override
  String get inventoryLocation => 'Miejsce';

  @override
  String get inventoryState => 'Stan';

  @override
  String inventoryUnknownWithCode(Object code) {
    return 'Nieznany ($code)';
  }

  @override
  String get inventoryPurchaseDate => 'Data zakupu';

  @override
  String get inventoryValueP => 'Wartość P';

  @override
  String get inventoryAssetDetailsTitle => 'Szczegóły środka trwałego';

  @override
  String get inventoryBasicInfoSection => 'Informacje podstawowe';

  @override
  String get inventoryLocationSection => 'Lokalizacja';

  @override
  String get inventoryFinancialSection => 'Dane finansowe i zakupowe';

  @override
  String get inventoryLevel => 'Poziom';

  @override
  String get inventoryValueA => 'Wartość A';

  @override
  String get inventoryImportedAt => 'Zaimportowano';

  @override
  String get inventoryNoData => 'Brak danych';

  @override
  String get inventoryLocationsTitle => 'Miejsca';

  @override
  String get inventoryLocationsSubtitle => 'Lista miejsc';

  @override
  String get inventoryTable => 'Tabela';

  @override
  String get inventoryTree => 'Drzewo';

  @override
  String get inventoryLocationsSearchHint => 'Kod, nazwa, poziom...';

  @override
  String get inventoryLocationsTreeSearchHint => 'Firma, kod, nazwa, poziom...';

  @override
  String get inventoryNoResultsTitle => 'Brak wyników';

  @override
  String get inventoryLocationsNoResultsMessage =>
      'Nie znaleziono gałęzi spełniających filtr.';

  @override
  String inventoryCompanyWithId(int id) {
    return 'Oddział $id';
  }

  @override
  String inventoryLocationsCount(int count) {
    return '$count miejsc';
  }

  @override
  String get inventoryCode => 'Kod';

  @override
  String get inventoryCompaniesTitle => 'Firmy';

  @override
  String get inventoryCompaniesSubtitle =>
      'Lista zarejestrowanych firm w słowniku inwentaryzacji.';

  @override
  String get inventoryCompaniesEmptyTitle => 'Brak firm';

  @override
  String get inventoryCompaniesEmptyMessage =>
      'Nie znaleziono żadnych firm w słowniku.';

  @override
  String inventoryCompanyIdLabel(int id) {
    return 'ID firmy: $id';
  }

  @override
  String get inventoryCompanyDeletedMessage => 'Firma została usunięta.';

  @override
  String get inventoryDetailsTitle => 'Szczegóły inwentaryzacji';

  @override
  String inventoryNumberLabel(Object number) {
    return 'Numer: $number';
  }

  @override
  String get inventoryDetailsLoadErrorTitle =>
      'Nie udało się pobrać szczegółów inwentaryzacji';

  @override
  String get retry => 'Ponów próbę';

  @override
  String get save => 'Zapisz';

  @override
  String get create => 'Utwórz';

  @override
  String get id => 'ID';

  @override
  String get inventorySheetsLabel => 'Arkusze';

  @override
  String get inventoryWarehouseLabel => 'Skład';

  @override
  String get inventoryActionsLabel => 'Akcje';

  @override
  String get inventoryReportsTitle => 'Raporty';

  @override
  String inventoryReportsSubtitle(Object number) {
    return 'Inwentaryzacja $number';
  }

  @override
  String get inventoryReportsIntro =>
      'Raporty liczone są na wszystkich elementach arkuszy przypiętych do wybranej inwentaryzacji.';

  @override
  String get inventoryReportsListTitle => 'Lista raportów';

  @override
  String get inventoryReportsBundleTitle => 'Komplet PDF';

  @override
  String get inventoryReportsBundleDescription =>
      'Scalony dokument zgodny z dawnym zestawem raportów Delphi.';

  @override
  String get inventoryReportsPreview => 'Podgląd';

  @override
  String get inventoryReportsDownload => 'Pobierz';

  @override
  String get inventoryReportsPrint => 'Drukuj';

  @override
  String get inventoryReportsPreviewPdf => 'Podgląd PDF';

  @override
  String get inventoryReportsBundleSubtitle => 'Komplet raportów';

  @override
  String get inventoryReportsSortLabel => 'Sortuj';

  @override
  String get inventoryReportsSortDirectionLabel => 'Kierunek';

  @override
  String get inventoryReportsSortById => 'ID';

  @override
  String get inventoryReportsSortByRegisterNumber => 'Nr ewid.';

  @override
  String get inventoryReportsSortByLocation => 'Miejsce';

  @override
  String get inventoryReportsSortByStatus => 'Status spisu';

  @override
  String get inventoryReportsSortByInventoryState => 'Stan inwent.';

  @override
  String get inventoryReportsRefresh => 'Odśwież';

  @override
  String get inventoryReportsDownloadPdf => 'Pobierz PDF';

  @override
  String get inventoryReportsDownloadReportPdf => 'Pobierz raport PDF';

  @override
  String get inventoryReportsDownloadProtocol => 'Pobierz protokół';

  @override
  String get inventoryReportsPrintPdf => 'Drukuj PDF';

  @override
  String get inventoryReportsPrintReportPdf => 'Drukuj raport PDF';

  @override
  String get inventoryReportsPrintProtocol => 'Drukuj protokół';

  @override
  String get inventoryReportsElements => 'Elementy';

  @override
  String get inventoryReportsGeneratedAt => 'Wygenerowano';

  @override
  String get inventoryReportsNotesLabel => 'Uwagi w komplecie';

  @override
  String get inventoryReportsEnabled => 'Włączone';

  @override
  String get inventoryReportsDisabled => 'Wyłączone';

  @override
  String get inventoryReportsPreviewOpenError =>
      'Nie udało się otworzyć podglądu kompletu PDF.';

  @override
  String get inventoryReportsSortAscending => 'Rosnąco';

  @override
  String get inventoryReportsSortDescending => 'Malejąco';

  @override
  String get inventoryReportNoDataTitle => 'Brak danych dla tego raportu';

  @override
  String get inventoryReportNoDataMessage =>
      'Backend nie zwrócił żadnych pozycji dla wybranego typu.';

  @override
  String get inventoryReportFetchErrorTitle => 'Nie udało się pobrać raportu';

  @override
  String get inventoryReportInternalBannerTitle => 'Raport wewnętrzny';

  @override
  String get inventoryReportSearchHint =>
      'Szukaj po nr ewid., nazwie, miejscu, osobie lub kodzie kreskowym';

  @override
  String get inventoryReportRegisterNumberLabel => 'Nr ewidencyjny';

  @override
  String get inventoryReportNameLabel => 'Nazwa';

  @override
  String get inventoryReportLocationLabel => 'Miejsce';

  @override
  String get inventoryReportPersonLabel => 'Osoba';

  @override
  String get inventoryReportBarcodeLabel => 'Kod kreskowy';

  @override
  String get inventoryReportGrossValueLabel => 'Wartość brutto';

  @override
  String get inventoryReportNetValueLabel => 'Wartość netto';

  @override
  String get inventoryReportPurchaseDateLabel => 'Data zakupu';

  @override
  String get inventoryReportUwagiLabel => 'Uwagi';

  @override
  String get inventoryReportMissingLocationLabel => 'Miejsce braku';

  @override
  String get inventoryReportMissingPersonLabel => 'Osoba braku';

  @override
  String get inventoryReportExcessLocationLabel => 'Miejsce nadwyżki';

  @override
  String get inventoryReportExcessPersonLabel => 'Osoba nadwyżki';

  @override
  String get inventoryCountStatusMissing => 'Brak';

  @override
  String get inventoryCountStatusPresent => 'Jest';

  @override
  String get inventoryCountStatusTransferred => 'Jest (niezgodność)';

  @override
  String get inventoryCountStatusExcess => 'Nadwyżka';

  @override
  String get inventoryCountStatusNew => 'Nowy';

  @override
  String get inventoryCountStatusFoundInOtherCompany =>
      'Znaleziony w innej firmie';

  @override
  String get inventoryCountStatusAmbiguousCode => 'Niejednoznaczny kod';

  @override
  String get inventoryCountStatusSoldDuringInventory => 'Sprzedany w trakcie';

  @override
  String get inventoryCountStatusPurchasedDuringInventory =>
      'Zakupiony w trakcie';

  @override
  String get inventoryCountStatusExcessDescription =>
      'Element znaleziony podczas spisu, ale nie należy do arkusza.';

  @override
  String get inventoryCountStatusNewDescription =>
      'Element dopisany jako nowy, bo nie występował w danych wyjściowych.';

  @override
  String get inventoryCountStatusFoundInOtherCompanyDescription =>
      'Element odnaleziony fizycznie, ale przypisany do innej firmy.';

  @override
  String get inventoryCountStatusAmbiguousCodeDescription =>
      'Kod kreskowy lub identyfikator nie pozwala jednoznacznie wskazać elementu.';

  @override
  String get inventoryCountStatusSoldDuringInventoryDescription =>
      'Element został sprzedany w trakcie trwania inwentaryzacji.';

  @override
  String get inventoryCountStatusPurchasedDuringInventoryDescription =>
      'Element został kupiony w trakcie trwania inwentaryzacji.';

  @override
  String get inventoryAssetStateMissingDescription =>
      'Brak informacji o aktualnym stanie elementu.';

  @override
  String get inventoryAssetStateUnapprovedDescription =>
      'Status elementu nie został jeszcze zatwierdzony.';

  @override
  String get inventoryAssetStateInUseDescription =>
      'Element jest aktualnie używany.';

  @override
  String get inventoryAssetStateDisposedDescription =>
      'Element został zlikwidowany.';

  @override
  String get inventoryAssetStateSoldDescription => 'Element został sprzedany.';

  @override
  String get inventoryAssetStateTransferredDescription =>
      'Element został przeniesiony.';

  @override
  String get inventoryAssetStateNotInAssetsDescription =>
      'Element nie występuje w aktualnej ewidencji.';

  @override
  String get inventoryCreateTitle => 'Nowa inwentaryzacja';

  @override
  String get inventoryCreateSubtitle =>
      'Utwórz nowy rekord spisu inwentaryzacyjnego.';

  @override
  String get inventoryCreatedMessage => 'Utworzono inwentaryzację.';

  @override
  String get inventoryLoadCompaniesErrorTitle => 'Nie udało się załadować firm';

  @override
  String get inventoryCompaniesListEmptyMessage => 'Lista firm jest pusta.';

  @override
  String get inventorySelectCompanyHint => 'Wybierz firmy/oddziały';

  @override
  String get inventoryNumber => 'Numer';

  @override
  String get inventoryNumberRequired => 'Numer jest wymagany.';

  @override
  String get inventorySearchPersonHint => 'Wyszukaj osobę...';

  @override
  String get inventoryRemarks => 'Uwagi';

  @override
  String get inventoryFoundInOtherSheet => 'Znaleziono w innym arkuszu';

  @override
  String get inventoryOptionalRemarks => 'Opcjonalne uwagi';

  @override
  String get inventoryCreateDatesInfo =>
      'Data od i data do ustawiają się automatycznie na dzisiaj. Status pozostaje domyślny po stronie backendu.';

  @override
  String get inventorySelectCompanyError =>
      'Wybierz co najmniej jeden oddział.';

  @override
  String get inventorySelectMinTwoCommissionUsers =>
      'Wybierz przynajmniej dwóch użytkowników komisji.';

  @override
  String get inventoryCommissionSavedMessage => 'Zapisano komisję.';

  @override
  String get inventoryNewSheet => 'Nowy arkusz';

  @override
  String get inventorySheetCreatedMessage => 'Arkusz został utworzony.';

  @override
  String get inventoryCommissionTitle => 'Komisja inwentaryzacji';

  @override
  String get inventoryEditSheetDatesTitle => 'Edytuj daty arkusza';

  @override
  String get inventoryEditSheetDatesSubtitle =>
      'Zmień daty rozpoczęcia i zakończenia bez otwierania szczegółów.';

  @override
  String get inventoryStartDateLabel => 'Data rozpoczęcia';

  @override
  String get inventoryStartDateHelper =>
      'Ustaw dzień i godzinę rozpoczęcia arkusza.';

  @override
  String get inventoryStartTimeLabel => 'Godzina rozpoczęcia';

  @override
  String get inventoryEndDateLabel => 'Data zakończenia';

  @override
  String get inventoryEndDateHelper =>
      'Ustaw dzień i godzinę zakończenia arkusza.';

  @override
  String get inventoryEndTimeLabel => 'Godzina zakończenia';

  @override
  String get inventoryStartDateRequiredError =>
      'Data rozpoczęcia jest wymagana.';

  @override
  String get inventoryEndDateBeforeStartError =>
      'Data zakończenia nie może być wcześniejsza niż data rozpoczęcia.';

  @override
  String get inventoryPrint => 'Drukuj';

  @override
  String get inventoryDates => 'Daty';

  @override
  String get inventoryStatusSpisuFieldLabel => 'Status spisu (opcje)';

  @override
  String get inventoryStatusSpisuNoOptions => 'Brak wybranych opcji';

  @override
  String get inventoryStatusSpisuYesMismatch => 'Jest (niezgodność)';

  @override
  String get inventoryStatusSpisuExcess => 'Nadwyżka';

  @override
  String get inventoryChooseCompanyTitle => 'Wybierz firmę';

  @override
  String get inventoryChooseCompanyOutsideMessage =>
      'Wybierz firmę spoza zakresu tej inwentaryzacji, a potem konkretne miejsce.';

  @override
  String get inventoryChooseCompanyInsideMessage =>
      'Wybierz firmę objętą inwentaryzacją, a potem konkretne miejsce.';

  @override
  String get inventoryInventoryStateAvailable => 'Dostępny';

  @override
  String get inventoryChangeItemStatusTitle => 'Status spisu';

  @override
  String get inventoryChangeItemResultTitle => 'Wynik spisu';

  @override
  String get inventoryChangeItemResultLabel => 'Wynik';

  @override
  String get inventoryChangeItemAdditionalTitle => 'Dodatkowe ustalenia';

  @override
  String get inventoryChangeItemMismatchDataTitle => 'Dane niezgodności';

  @override
  String get inventoryChangeItemCorrectionTitle => 'Korekta danych';

  @override
  String get inventoryChangeItemChooseResultHint => 'Wybierz wynik spisu';

  @override
  String get inventoryChangeItemTypeLabel => 'Typ zmiany';

  @override
  String get inventoryDeleteItemTitle => 'Usuń element arkusza';

  @override
  String get inventoryDeleteItemSubtitle =>
      'Operacja usuwa wskazany element z aktualnego arkusza.';

  @override
  String inventoryDeleteItemDetailsMessage(
    Object id,
    Object register,
    Object name,
  ) {
    return 'Element ID: $id\nNumer ewidencyjny: $register\nNazwa: $name';
  }

  @override
  String get inventoryDeleteItemSuccessMessage =>
      'Element arkusza został usunięty.';

  @override
  String get inventoryDeleteItemUnlockLabel => 'Potwierdzenie usunięcia';

  @override
  String get inventoryDeleteStockTitle => 'Usuń środek trwały';

  @override
  String get inventoryDeleteStockSubtitle =>
      'Operacja usuwa rekord ze snapshotu stanów środków trwałych.';

  @override
  String get inventoryDeleteStockConfirmTitle =>
      'Czy na pewno chcesz usunąć ten rekord?';

  @override
  String inventoryDeleteStockConfirmBody(int id, Object register, Object name) {
    return 'Rekord ID: $id\nNumer ewidencyjny: $register\nNazwa: $name';
  }

  @override
  String get inventoryDeleteStockHelper =>
      'Przepisz numer ewidencyjny i pełną nazwę. Wielkość liter nie ma znaczenia.';

  @override
  String get inventoryDeleteStockRegisterLabel => 'Numer ewidencyjny';

  @override
  String get inventoryDeleteStockNameLabel => 'Pełna nazwa';

  @override
  String get inventoryDeleteStockSuccessMessage =>
      'Środek trwały został usunięty ze snapshotu.';

  @override
  String get inventorySheetDatesSavedMessage =>
      'Daty arkusza zostały zapisane.';

  @override
  String get inventorySheetDateSearchHint => 'nazwa arkusza, miejsce';

  @override
  String get inventorySheetStatusesTitle => 'Statusy arkusza';

  @override
  String get inventorySheetStatusesCommissionTitle => 'Komisja';

  @override
  String get inventorySheetStatusesCommissionEmpty => 'Brak';

  @override
  String get inventorySheetManagementTitle => 'Edytuj daty arkusza';

  @override
  String get inventorySheetManagementSubtitle =>
      'Zmień daty rozpoczęcia i zakończenia bez edycji komisji.';

  @override
  String get inventorySheetStartTimeLabel => 'Godzina rozpoczęcia';

  @override
  String get inventorySheetEndTimeLabel => 'Godzina zakończenia';

  @override
  String get frameworkGalleryTitle => 'Galeria komponentów frameworka';

  @override
  String frameworkActionToast(Object label) {
    return 'Akcja: $label';
  }

  @override
  String get frameworkNewDocumentTitle => 'Nowy dokument';

  @override
  String get frameworkNewDocumentSubtitle =>
      'Wariant side sheet z prawej strony.';

  @override
  String get frameworkClose => 'Zamknij';

  @override
  String get frameworkError => 'Błąd';

  @override
  String get frameworkSave => 'Zapisz';

  @override
  String get frameworkNewDocumentTemplateTitle => 'Nowy dokument';

  @override
  String get frameworkNewDocumentTemplateSubtitle =>
      'Szablon pod BLoC initial/loading/loaded/error.';

  @override
  String get frameworkDocumentDataTitle => 'Dane dokumentu';

  @override
  String get frameworkDocumentNameHint => 'np. Inwentaryzacja Q2';

  @override
  String get frameworkDocumentStatusOpen => 'W toku';

  @override
  String get frameworkDocumentStatusClosed => 'Zamknięty';

  @override
  String get frameworkDataTableTitle => 'Data Table';

  @override
  String get frameworkDataTableSubtitle =>
      'Tabela z sortowaniem i stanami loading/error/empty.';

  @override
  String get frameworkStressTest => 'Stress test 100x4000';

  @override
  String get frameworkLoadingDataTitle => 'Ładowanie danych';

  @override
  String get frameworkLoadingDataMessage =>
      'Pobieramy rekordy, chwilę to potrwa.';

  @override
  String get frameworkLoadErrorTitle => 'Nie udało się pobrać danych';

  @override
  String get frameworkName => 'Nazwa';

  @override
  String get frameworkStatus => 'Status';

  @override
  String get frameworkItems => 'Pozycje';

  @override
  String get frameworkOwner => 'Właściciel';

  @override
  String get frameworkListTilesTitle => 'List Tiles';

  @override
  String get frameworkListTilesSubtitle =>
      'Wspólny AppListTile i AppExpansionListTile pod menu/listy.';

  @override
  String get frameworkInbox => 'Skrzynka';

  @override
  String get frameworkReports => 'Raporty';

  @override
  String get frameworkDaily => 'Dzienny';

  @override
  String get frameworkNewItemsCount => '12 nowych pozycji';

  @override
  String get frameworkFavorites => 'Ulubione';

  @override
  String get frameworkAnalytics => 'Widoki analityczne';

  @override
  String get frameworkDailyReport => 'Raport dzienny';

  @override
  String get frameworkMonthlyReport => 'Raport miesięczny';

  @override
  String get frameworkDropdownTitle => 'Dropdown';

  @override
  String get frameworkDropdownSubtitle =>
      'Podstawowy dropdown oparty o theme i wspólne style.';

  @override
  String get frameworkDropdownLabel => 'Zakres';

  @override
  String get frameworkToday => 'Dzisiaj';

  @override
  String get frameworkThisWeek => 'Ten tydzień';

  @override
  String get frameworkOuterLabel => 'Etykieta zewnętrzna';

  @override
  String get frameworkStatusLabel => 'Status';

  @override
  String get frameworkChoose => 'Wybierz';

  @override
  String get frameworkToggleLoading => 'Pokaż loading';

  @override
  String get frameworkHideLoading => 'Wyłącz loading';

  @override
  String get frameworkShowError => 'Pokaż błąd';

  @override
  String get frameworkHideError => 'Ukryj błąd';

  @override
  String get frameworkShowTable => 'Pokaż tabelę';

  @override
  String get frameworkRetry => 'Spróbuj ponownie';

  @override
  String get frameworkLoadingText => 'Ładowanie danych';

  @override
  String get frameworkLoadingMessage => 'Pobieramy rekordy, chwilę to potrwa.';

  @override
  String get frameworkErrorTitle => 'Nie udało się pobrać danych';

  @override
  String get frameworkSearchApiError =>
      'Błąd API: timeout podczas pobierania listy.';

  @override
  String get frameworkListTileInboxCount => '12 nowych pozycji';

  @override
  String get frameworkListTileFavorites => 'Ulubione';

  @override
  String get frameworkListTileAnalytics => 'Widoki analityczne';

  @override
  String get frameworkListTileDailyReport => 'Raport dzienny';

  @override
  String get frameworkListTileMonthlyReport => 'Raport miesięczny';

  @override
  String frameworkTableRowHover(Object name) {
    return 'Hover: $name';
  }

  @override
  String frameworkTableRowTap(
    int index,
    Object name,
    Object status,
    Object count,
    Object owner,
  ) {
    return 'Kliknięto wiersz #$index: $name | $status | $count | $owner';
  }

  @override
  String get frameworkTableName => 'Nazwa';

  @override
  String get frameworkTableStatus => 'Status';

  @override
  String get frameworkTableItems => 'Pozycje';

  @override
  String get frameworkTableOwner => 'Właściciel';

  @override
  String get ordersTitle => 'Zamówienia';

  @override
  String get ordersBody =>
      'To jest drugi feature uruchamiany z tej samej aplikacji.';

  @override
  String get ordersInitialRoute => 'Initial route: /orders';

  @override
  String get ordersUserId => 'User ID: n/d';

  @override
  String get ordersUser => 'User: n/d';

  @override
  String get ordersBearerPassed => 'Bearer przekazany: n/d';

  @override
  String get bhpModuleTitle => 'BHP';

  @override
  String get bhpSidebarSubtitle =>
      'Workflow pracowników, stanowisk i wyposażenia';

  @override
  String get bhpSectionDashboard => 'Dashboard';

  @override
  String get bhpSectionOperations => 'Historia operacji';

  @override
  String get bhpSectionUsers => 'Pracownicy';

  @override
  String get bhpSectionPositions => 'Stanowiska';

  @override
  String get bhpSectionEquipment => 'Wyposażenie';

  @override
  String get bhpRefreshAction => 'Odśwież';

  @override
  String get bhpDashboardSectionTitle => 'Dashboard BHP';

  @override
  String get bhpDashboardSectionSubtitle =>
      'Alerty terminów i podstawowe sygnały operacyjne z backendu BHP.';

  @override
  String get bhpDashboardErrorTitle => 'Nie udało się załadować dashboardu';

  @override
  String get bhpDashboardRefreshingLabel => 'Odświeżanie';

  @override
  String get bhpDashboardRefreshInProgress => 'Trwa odświeżanie danych.';

  @override
  String get bhpDashboardRetryLabel => 'Spróbuj ponownie';

  @override
  String get bhpDashboardOverdueTitle => 'Po terminie';

  @override
  String get bhpDashboardOverdueSubtitle =>
      'Aktywne wydania wymagające reakcji.';

  @override
  String get bhpDashboardUpcomingTitle => 'Nadchodzące';

  @override
  String bhpDashboardUpcomingSubtitle(int months) {
    return 'Alerty w najbliższych $months mies.';
  }

  @override
  String get bhpDashboardSnapshotTitle => 'Snapshot';

  @override
  String get bhpDashboardSnapshotSubtitle =>
      'Czas wygenerowania danych dashboardu.';

  @override
  String get bhpDashboardOverdueTableTitle => 'Wydania po terminie';

  @override
  String get bhpDashboardOverdueTableSubtitle =>
      'Lista rekordów, które przekroczyły termin użytkowania.';

  @override
  String get bhpDashboardNoOverdueTitle => 'Brak przeterminowanych wydań';

  @override
  String get bhpDashboardNoOverdueMessage =>
      'Na ten moment nie ma pozycji po terminie.';

  @override
  String get bhpDashboardUpcomingTableTitle =>
      'Wydania zbliżające się do terminu';

  @override
  String get bhpDashboardUpcomingTableSubtitle =>
      'Pozycje, które wkrótce będą wymagały wymiany lub zamknięcia.';

  @override
  String get bhpDashboardNoUpcomingTitle => 'Brak nadchodzących alertów';

  @override
  String get bhpDashboardNoUpcomingMessage =>
      'Na ten moment nie ma alertów w najbliższym oknie czasowym.';

  @override
  String get bhpUsersTitle => 'Pracownicy BHP';

  @override
  String get bhpUsersSectionSubtitle =>
      'Lista kart pracowników i ich aktualnego statusu.';

  @override
  String bhpUsersSubtitle(int active, int archived) {
    return 'Aktywni: $active, archiwalni: $archived';
  }

  @override
  String get bhpUsersErrorTitle => 'Nie udało się załadować pracowników';

  @override
  String get bhpUsersEmptyTitle => 'Brak pracowników';

  @override
  String get bhpUsersEmptyMessage => 'Lista pracowników BHP jest pusta.';

  @override
  String get bhpUsersNoSearchResultsTitle => 'Brak wyników';

  @override
  String get bhpUsersNoSearchResultsMessage =>
      'Żaden pracownik nie pasuje do bieżącej frazy. Wyczyść wyszukiwanie albo zmień zapytanie.';

  @override
  String get bhpUsersNoActiveMessage =>
      'Na liście nie ma teraz aktywnych pracowników.';

  @override
  String get bhpUsersNoArchivedMessage =>
      'Na liście nie ma teraz zarchiwizowanych pracowników.';

  @override
  String bhpUsersSearchResultsSummary(Object visible, Object total) {
    return 'Wyniki: $visible z $total';
  }

  @override
  String get bhpUsersClearSearchAction => 'Wyczyść wyszukiwanie';

  @override
  String get bhpUsersBulkSelectLabel => 'Masowe akcje';

  @override
  String bhpUsersBulkSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wybrano $count pracowników',
      one: 'Wybrano 1 pracownika',
    );
    return '$_temp0';
  }

  @override
  String get bhpUsersBulkChangePositionAction => 'Zmień stanowisko';

  @override
  String get bhpUsersBulkChangePositionTitle => 'Masowa zmiana stanowiska';

  @override
  String bhpUsersBulkChangePositionConfirm(int count) {
    return 'Zmień stanowisko dla $count pracowników';
  }

  @override
  String bhpUsersBulkSuccessMessage(int count) {
    return 'Pomyślnie zmieniono stanowisko dla $count pracowników.';
  }

  @override
  String get bhpUsersDataQualityLabel => 'Dane';

  @override
  String get bhpUsersDataQualityComplete => 'Komplet';

  @override
  String get bhpUsersDataQualityMissingPosition => 'Brak stanowiska';

  @override
  String get bhpUsersDataQualityMissingPesel => 'Brak PESEL';

  @override
  String get bhpUsersDataQualityMissingPhone => 'Brak telefonu';

  @override
  String get bhpUsersSearchHint =>
      'Szukaj po imieniu, nazwisku, numerze ewidencyjnym...';

  @override
  String get bhpPositionsTitle => 'Stanowiska BHP';

  @override
  String get bhpPositionsSectionSubtitle =>
      'Słownik stanowisk wykorzystywany w kartach pracowników.';

  @override
  String bhpPositionsSubtitle(int active, int total) {
    return 'Aktywne: $active, wszystkie: $total';
  }

  @override
  String get bhpPositionsErrorTitle => 'Nie udało się załadować stanowisk';

  @override
  String get bhpPositionsEmptyTitle => 'Brak stanowisk';

  @override
  String get bhpPositionsEmptyMessage =>
      'Słownik stanowisk nie zawiera jeszcze danych.';

  @override
  String get bhpPositionsSearchHint => 'Szukaj po nazwie lub uwagach...';

  @override
  String get bhpPositionsFilterAll => 'Wszystkie';

  @override
  String get bhpPositionsFilterInactive => 'Nieaktywne';

  @override
  String get bhpPositionsRestoreAction => 'Przywróć';

  @override
  String get bhpPositionsRestoreTitle => 'Przywróć stanowisko';

  @override
  String bhpPositionsRestoreMessage(Object name) {
    return 'Stanowisko $name zostanie ponownie włączone do aktywnego słownika.';
  }

  @override
  String bhpPositionsRestoreSuccess(Object name) {
    return 'Przywrócono stanowisko $name.';
  }

  @override
  String get bhpPositionsAddAndStandardAction => 'Dodaj i standard';

  @override
  String get bhpPositionsEditStandardAction => 'Edytuj standard';

  @override
  String get bhpPositionsOpenStandardAction => 'Standard wyposażenia';

  @override
  String get bhpPositionStandardsTitle => 'Standard wyposażenia stanowiska';

  @override
  String get bhpPositionStandardsLoadErrorTitle =>
      'Nie udało się załadować standardu stanowiska';

  @override
  String get bhpPositionStandardsPositionLabel => 'Stanowisko';

  @override
  String bhpPositionStandardsItemsCount(int count) {
    return 'Pozycji: $count';
  }

  @override
  String bhpPositionStandardsActiveCount(int count) {
    return 'Aktywne: $count';
  }

  @override
  String bhpPositionStandardsEquipmentPoolCount(int count) {
    return 'Kart do wyboru: $count';
  }

  @override
  String get bhpPositionStandardsEmptyTitle => 'Brak pozycji standardu';

  @override
  String get bhpPositionStandardsEmptyMessage =>
      'To stanowisko nie ma jeszcze przypisanego wyposażenia.';

  @override
  String get bhpPositionStandardsAddAction => 'Dodaj pozycję';

  @override
  String get bhpPositionStandardsArchiveAction => 'Ustaw nieaktywne';

  @override
  String get bhpPositionStandardsArchiveTitle =>
      'Ustaw pozycję standardu jako nieaktywną';

  @override
  String bhpPositionStandardsArchiveMessage(Object symbol) {
    return 'Pozycja $symbol zostanie ustawiona jako nieaktywna tylko na tej karcie standardu stanowiska.';
  }

  @override
  String get bhpPositionStandardsArchiveSuccess =>
      'Pozycja standardu została ustawiona jako nieaktywna.';

  @override
  String get bhpPositionStandardsRestoreAction => 'Ustaw aktywne';

  @override
  String get bhpPositionStandardsRestoreTitle =>
      'Ustaw pozycję standardu jako aktywną';

  @override
  String bhpPositionStandardsRestoreMessage(Object symbol) {
    return 'Pozycja $symbol zostanie ustawiona jako aktywna tylko na tej karcie standardu stanowiska.';
  }

  @override
  String get bhpPositionStandardsRestoreSuccess =>
      'Pozycja standardu została ustawiona jako aktywna.';

  @override
  String get bhpPositionStandardsDeleteTitle => 'Usuń pozycję standardu';

  @override
  String bhpPositionStandardsDeleteMessage(Object symbol) {
    return 'Pozycja $symbol zostanie trwale usunięta tylko z tej karty standardu stanowiska.';
  }

  @override
  String get bhpPositionStandardsDeleteSuccess => 'Usunięto pozycję standardu.';

  @override
  String get bhpPositionStandardEditorCreateTitle => 'Dodaj pozycję standardu';

  @override
  String get bhpPositionStandardEditorEditTitle => 'Edytuj pozycję standardu';

  @override
  String get bhpPositionStandardEditorEquipmentLabel => 'Karta wyposażenia';

  @override
  String get bhpPositionStandardEditorEquipmentHint =>
      'Szukaj karty wyposażenia...';

  @override
  String get bhpPositionStandardEditorEquipmentRequired =>
      'Karta wyposażenia jest wymagana.';

  @override
  String get bhpPositionStandardEditorPeriodLabel => 'Okres (miesiące)';

  @override
  String get bhpPositionStandardEditorQuantityLabel => 'Ilość';

  @override
  String get bhpPositionStandardEditorCreateSuccess =>
      'Dodano pozycję standardu.';

  @override
  String get bhpPositionStandardEditorEditSuccess =>
      'Zapisano pozycję standardu.';

  @override
  String get bhpEquipmentTitle => 'Katalog wyposażenia';

  @override
  String get bhpEquipmentSectionSubtitle =>
      'Pozycje katalogowe używane w standardach i wydaniach BHP.';

  @override
  String get bhpEquipmentFilterActiveTooltip =>
      'Pokazuje tylko aktywne karty wyposażenia.';

  @override
  String get bhpEquipmentFilterInactiveTooltip =>
      'Pokazuje tylko nieaktywne karty wyposażenia.';

  @override
  String get bhpEquipmentFilterAllTooltip =>
      'Pokazuje wszystkie karty wyposażenia.';

  @override
  String get bhpEquipmentStatusActiveTooltip =>
      'Karta wyposażenia jest aktywna i może być używana w standardach.';

  @override
  String get bhpEquipmentStatusInactiveTooltip =>
      'Karta wyposażenia jest nieaktywna i nie trafia do nowych wydań.';

  @override
  String bhpEquipmentSubtitle(int active, int total) {
    return 'Aktywne: $active, wszystkie: $total';
  }

  @override
  String get bhpEquipmentErrorTitle => 'Nie udało się załadować wyposażenia';

  @override
  String get bhpEquipmentEmptyTitle => 'Brak wyposażenia';

  @override
  String get bhpEquipmentEmptyMessage =>
      'Katalog wyposażenia nie zawiera jeszcze danych.';

  @override
  String get bhpEquipmentSearchHint =>
      'Szukaj po symbolu, nazwie lub jednostce...';

  @override
  String get bhpEquipmentSetInactiveAction => 'Ustaw nieaktywne';

  @override
  String get bhpEquipmentSetInactiveTitle => 'Ustaw kartę jako nieaktywną';

  @override
  String bhpEquipmentSetInactiveMessage(Object symbol) {
    return 'Karta $symbol zostanie wyłączona z aktywnego katalogu wyposażenia.';
  }

  @override
  String bhpEquipmentSetInactiveSuccess(Object symbol) {
    return 'Karta $symbol została ustawiona jako nieaktywna.';
  }

  @override
  String get bhpEquipmentSetActiveAction => 'Ustaw aktywne';

  @override
  String get bhpEquipmentSetActiveTitle => 'Ustaw kartę jako aktywną';

  @override
  String bhpEquipmentSetActiveMessage(Object symbol) {
    return 'Karta $symbol wróci do aktywnego katalogu wyposażenia.';
  }

  @override
  String bhpEquipmentSetActiveSuccess(Object symbol) {
    return 'Karta $symbol została ustawiona jako aktywna.';
  }

  @override
  String get bhpEquipmentImpactSetInactiveDescription =>
      'Zmiana statusu tej karty na nieaktywną wyłączy wszystkie aktywne przypisania tego wyposażenia na stanowiskach.';

  @override
  String get bhpEquipmentImpactSetActiveDescription =>
      'Możesz tylko aktywować kartę globalnie albo dodatkowo zaznaczyć, które nieaktywne przypisania stanowisk mają zostać przywrócone.';

  @override
  String bhpEquipmentImpactActiveLinksCount(int count) {
    return 'Aktywne przypisania: $count';
  }

  @override
  String bhpEquipmentImpactInactiveLinksCount(int count) {
    return 'Nieaktywne przypisania: $count';
  }

  @override
  String bhpEquipmentImpactSelectedLinksCount(int count) {
    return 'Do przywrócenia: $count';
  }

  @override
  String get bhpEquipmentImpactInactiveSection =>
      'Stanowiska, które zostaną wyłączone';

  @override
  String get bhpEquipmentImpactActiveSection =>
      'Nieaktywne przypisania możliwe do przywrócenia';

  @override
  String get bhpEquipmentImpactActiveHint =>
      'Zaznacz tylko te przypisania, które mają wrócić razem z aktywacją karty globalnej.';

  @override
  String get bhpEquipmentImpactInactiveEmptyTitle => 'Brak aktywnych powiązań';

  @override
  String get bhpEquipmentImpactInactiveEmptyMessage =>
      'Ta karta nie ma obecnie aktywnych przypisań standardów, więc zmiana statusu dotknie tylko katalog globalny.';

  @override
  String get bhpEquipmentImpactActiveEmptyTitle =>
      'Brak przypisań do przywrócenia';

  @override
  String get bhpEquipmentImpactActiveEmptyMessage =>
      'Kartę można aktywować globalnie bez przywracania żadnych przypisań stanowisk.';

  @override
  String get bhpSearchAlertsHint =>
      'Szukaj po pracowniku, stanowisku lub wyposażeniu...';

  @override
  String get bhpTableRegistryNumber => 'Nr ewid.';

  @override
  String get bhpTableEmployee => 'Pracownik';

  @override
  String get bhpTablePosition => 'Stanowisko';

  @override
  String get bhpTableEquipment => 'Wyposażenie';

  @override
  String get bhpTableEmploymentStart => 'Zatrudniony od';

  @override
  String get bhpTableEmploymentEnd => 'Zatrudniony do';

  @override
  String get bhpTableDueDate => 'Termin';

  @override
  String get bhpTableDaysToDue => 'Dni';

  @override
  String get bhpTableStatus => 'Status';

  @override
  String get bhpTableNotes => 'Uwagi';

  @override
  String get bhpTableSymbol => 'Symbol';

  @override
  String get bhpTableUnit => 'JM';

  @override
  String get bhpTablePeriod => 'Okres';

  @override
  String get bhpTableDefaultQuantity => 'Ilość dom.';

  @override
  String get bhpTablePrice => 'Cena';

  @override
  String get bhpStatusActive => 'Aktywny';

  @override
  String get bhpStatusActiveTooltip =>
      'Status oznacza, że element jest aktywny i dostępny w bieżących widokach.';

  @override
  String get bhpStatusInactive => 'Nieaktywny';

  @override
  String get bhpStatusInactiveTooltip =>
      'Status oznacza, że element jest nieaktywny i nie powinien trafiać do nowych operacji.';

  @override
  String get bhpStatusArchived => 'Archiwalny';

  @override
  String get bhpUserIssuesTitle => 'Wydania pracownika';

  @override
  String bhpUserIssuesSubtitle(String name) {
    return 'Historia wydań BHP i ekwiwalentów dla: $name';
  }

  @override
  String get bhpUserIssuesEmptyTitle => 'Brak wydań';

  @override
  String get bhpUserIssuesEmptyMessage =>
      'Pracownik nie posiada żadnych zarejestrowanych wydań wyposażenia.';

  @override
  String get bhpUserIssuesErrorTitle => 'Nie udało się załadować wydań';

  @override
  String get bhpUserIssuesSectionSubtitle =>
      'Ewidencja wydań wyposażenia pracownika.';

  @override
  String get bhpUserIssuesHideInactive => 'Ukryj nieaktywne';

  @override
  String get bhpUserIssuesEmployeeLabel => 'Pracownik:';

  @override
  String get bhpUserIssuesPositionLabel => 'Stanowisko:';

  @override
  String get bhpUserIssuesNoPosition => 'Brak stanowiska';

  @override
  String get bhpUserIssuesEditEmployeeTooltip => 'Edytuj dane pracownika';

  @override
  String get bhpUserIssuesSearchHint => 'Szukaj sprzętu (symbol, nazwa)...';

  @override
  String get bhpUserIssuesRowNumber => 'Lp.';

  @override
  String get bhpUserIssuesNoEquipmentName => 'Brak nazwy';

  @override
  String get bhpUserIssuesTooltipEquipmentInfo =>
      'Pokaż informacje o wyposażeniu';

  @override
  String get bhpUserIssuesTooltipEditQuantity => 'Edytuj ilość';

  @override
  String get bhpUserIssuesTooltipEditIssueDate => 'Edytuj datę przydziału';

  @override
  String get bhpUserIssuesAddEquivalent => 'Dodaj';

  @override
  String get bhpUserIssuesTooltipAddEquivalent => 'Dodaj ekwiwalent';

  @override
  String get bhpUserIssuesTooltipEditEquivalent => 'Edytuj ekwiwalent';

  @override
  String get bhpUserIssuesTooltipEditEquivalentDate =>
      'Edytuj datę ekwiwalentu';

  @override
  String get bhpUserIssuesActionDeleteEquivalent => 'Usuń ekwiwalent';

  @override
  String get bhpUserIssuesTooltipDeleteEquivalent => 'Usuń ekwiwalent';

  @override
  String get bhpUserIssuesAddNote => 'Dodaj uwagę';

  @override
  String get bhpUserIssuesTooltipAddNote => 'Dodaj uwagę do wydania';

  @override
  String get bhpUserIssuesActiveStatusTooltip =>
      'Sprzęt jest aktualnie używany przez pracownika.\nZajmuje on normę przypisaną do stanowiska.';

  @override
  String get bhpUserIssuesInactiveStatusTooltip =>
      'Wydanie zostało zakończone.\nSprzęt nie jest już w użyciu i zwalnia normę na stanowisku.';

  @override
  String get bhpUserIssuesRepeatAction => 'Dodaj ponownie';

  @override
  String bhpUserIssuesActionsForSymbol(Object symbol) {
    return 'Akcje dla: $symbol';
  }

  @override
  String get bhpUserIssuesActionsForIssue => 'Akcje dla wydania';

  @override
  String get bhpUserIssuesDeleteIssueTitle => 'Usuń wydanie';

  @override
  String bhpUserIssuesDeleteIssueMessage(Object item) {
    return 'Czy na pewno chcesz usunąć wydanie $item? Operacja jest nieodwracalna.';
  }

  @override
  String get bhpUserIssuesDeleteIssueSuccess => 'Wydanie zostało usunięte.';

  @override
  String get bhpUserIssuesRepeatIssueTitle => 'Dodaj ponownie';

  @override
  String bhpUserIssuesRepeatIssueMessage(Object item) {
    return 'Czy na pewno chcesz automatycznie powtórzyć wydanie $item?';
  }

  @override
  String get bhpUserIssuesRepeatIssueSuccess => 'Wydanie zostało powtórzone.';

  @override
  String get bhpUserIssuesBulkRepeatAction => 'Wydaj ponownie zaznaczone';

  @override
  String get bhpUserIssuesBulkRepeatTitle => 'Potwierdź ponowne wydanie';

  @override
  String get bhpUserIssuesBulkRepeatSubtitle =>
      'Nowe wydania zostaną utworzone dla pozycji zaznaczonych na aktywnej liście.';

  @override
  String get bhpUserIssuesBulkRepeatDescription =>
      'Sprawdź zaznaczone pozycje i wybierz wspólną datę przydziału dla nowych wydań.';

  @override
  String get bhpUserIssuesBulkRepeatDateHelper =>
      'Domyślnie ustawiona jest dzisiejsza data, ale możesz ją zmienić przed zapisaniem operacji.';

  @override
  String get bhpUserIssuesBulkRepeatSelectAll => 'Zaznacz wszystkie';

  @override
  String get bhpUserIssuesBulkRepeatClearSelection => 'Wyczyść wybór';

  @override
  String get bhpUserIssuesBulkRepeatEmptyTitle =>
      'Brak pozycji do ponownego wydania';

  @override
  String get bhpUserIssuesBulkRepeatEmptyMessage =>
      'Nie zaznaczono żadnych aktywnych pozycji do ponownego wydania.';

  @override
  String bhpUserIssuesBulkRepeatSelectedCount(Object count) {
    return 'Zaznaczono: $count';
  }

  @override
  String get bhpUserIssuesBulkRepeatSubmitAction => 'Wydaj ponownie';

  @override
  String get bhpUserIssuesBulkRepeatSelectionRequired =>
      'Zaznacz przynajmniej jedną aktywną pozycję do ponownego wydania.';

  @override
  String bhpUserIssuesBulkRepeatSuccess(Object count) {
    return 'Ponownie wydano $count pozycji.';
  }

  @override
  String bhpUserIssuesBulkRepeatItemSubtitle(
    Object assignedAt,
    Object closedAt,
    Object quantity,
  ) {
    return 'Przydział: $assignedAt • Zamknięcie: $closedAt • Ilość: $quantity';
  }

  @override
  String get bhpUserIssuesOpenPositionDetails => 'Otwórz szczegóły stanowiska';

  @override
  String bhpUserIssuesPrintCardError(Object error) {
    return 'Błąd podczas generowania wydruku karty: $error';
  }

  @override
  String get bhpUserIssuesActionAdd => 'Dodaj wydanie';

  @override
  String get bhpUserIssuesActionFromStandard => 'Generuj ze standardu';

  @override
  String get bhpUserIssuesActionClose => 'Zakończ wydanie';

  @override
  String get bhpUserIssuesActionEquivalent => 'Ekwiwalent';

  @override
  String get bhpUserIssuesPrint => 'Drukuj';

  @override
  String get bhpUserIssuesPrintOptionsTitle => 'Opcje wydruku';

  @override
  String get bhpUserIssuesPrintOptionsIncludeInactive =>
      'Uwzględnij pozycje nieaktywne (zakończone)';

  @override
  String get bhpUserIssuesPrintOptionsAction => 'Generuj wydruk';

  @override
  String get bhpTableEquipmentSymbol => 'Symbol';

  @override
  String get bhpTableEquipmentName => 'Nazwa wyposażenia';

  @override
  String get bhpTableIssueDate => 'Data przydziału';

  @override
  String get bhpTableEndDate => 'Data zakończenia';

  @override
  String get bhpTableQuantity => 'Ilość';

  @override
  String get bhpTableEquivalentDate => 'Data ekwiw.';

  @override
  String get bhpTableEquivalentAmount => 'Kwota ekwiw.';

  @override
  String get bhpIssueFormAddTitle => 'Nowe wydanie wyposażenia';

  @override
  String get bhpIssueFormCloseTitle => 'Zakończenie wydania';

  @override
  String get bhpIssueFormEquivalentTitle => 'Wypłata ekwiwalentu';

  @override
  String get bhpIssueFormEquipmentLabel => 'Pozycja wyposażenia';

  @override
  String get bhpIssueFormEquipmentHint => 'Wybierz wyposażenie z katalogu';

  @override
  String get bhpIssueFormDateLabel => 'Data przydziału';

  @override
  String get bhpIssueFormQuantityLabel => 'Ilość';

  @override
  String get bhpIssueFormNotesLabel => 'Uwagi';

  @override
  String get bhpIssueFormEndDateLabel => 'Data zakończenia';

  @override
  String get bhpIssueFormEquivalentDateLabel => 'Data ekwiwalentu';

  @override
  String get bhpIssueFormEquivalentAmountLabel => 'Kwota ekwiwalentu';

  @override
  String get bhpIssueFormSuccessAdd => 'Dodano nowe wydanie wyposażenia.';

  @override
  String get bhpIssueFormSuccessClose =>
      'Pomyślnie zamknięto wydanie wyposażenia.';

  @override
  String get bhpIssueFormSuccessEquivalent => 'Zarejestrowano ekwiwalent.';

  @override
  String get bhpIssueFormSuccessStandard =>
      'Pomyślnie dopisano brakujące wyposażenie ze standardu.';

  @override
  String get bhpIssueEditTitle => 'Edytuj wydanie';

  @override
  String get bhpIssueEditDateTitle => 'Edytuj datę przydziału';

  @override
  String get bhpIssueEditEndDateTitle => 'Edytuj datę zakończenia';

  @override
  String get bhpIssueEditEndDateHelperText =>
      'Nie może być wcześniejsza niż data przydziału.';

  @override
  String get bhpIssueEditQuantityTitle => 'Edytuj ilość';

  @override
  String get bhpIssueEditNotesTitle => 'Edytuj uwagi';

  @override
  String get bhpIssueEditSuccess => 'Wydanie zostało zaktualizowane.';

  @override
  String get bhpIssueEquivalentEditTitle => 'Edytuj ekwiwalent';

  @override
  String get bhpIssueEquivalentEditSuccess =>
      'Ekwiwalent został zaktualizowany.';

  @override
  String get bhpIssueEquivalentDeleteTitle => 'Usuń ekwiwalent';

  @override
  String get bhpIssueEquivalentDeleteAction => 'Usuń ekwiwalent';

  @override
  String get bhpIssueEquivalentDeleteSuccess => 'Ekwiwalent został usunięty.';

  @override
  String bhpIssueEquivalentDeleteMessage(Object item) {
    return 'Czy usunąć ekwiwalent dla: $item? Operacja wyczyści datę i kwotę ekwiwalentu, ale nie usunie samego wydania.';
  }

  @override
  String get bhpIssueValidationPositiveQuantity =>
      'Podaj poprawną ilość większą od 0.';

  @override
  String get bhpAssignFromStandardTitle => 'Dopisz ze standardu';

  @override
  String get bhpAssignFromStandardLoadErrorTitle =>
      'Nie udało się wczytać standardu';

  @override
  String get bhpAssignFromStandardDescription =>
      'Poniżej widzisz pozycje ze standardu stanowiska. Zaznaczone pozycje zostaną dopisane, a pozycje już aktywne są zablokowane.';

  @override
  String bhpAssignFromStandardSelectedCount(int count) {
    return 'Do dodania: $count';
  }

  @override
  String bhpAssignFromStandardLockedCount(int count) {
    return 'Już aktywne: $count';
  }

  @override
  String bhpAssignFromStandardInactiveCount(int count) {
    return 'Nieaktywne: $count';
  }

  @override
  String get bhpAssignFromStandardSectionAddable => 'Do dodania';

  @override
  String get bhpAssignFromStandardSectionLocked => 'Już aktywne';

  @override
  String get bhpAssignFromStandardSectionInactive => 'Nieaktywne';

  @override
  String get bhpAssignFromStandardSubmitAction => 'Dopisz pozycje';

  @override
  String get bhpAssignFromStandardBlockedTitle => 'Brak możliwości dopisania';

  @override
  String get bhpAssignFromStandardBlockedMessage =>
      'Ten pracownik nie ma aktywnego stanowiska albo nie może otrzymywać wydań.';

  @override
  String get bhpAssignFromStandardBadgeAddable => 'Do dodania';

  @override
  String get bhpAssignFromStandardBadgeLocked => 'Już aktywne';

  @override
  String get bhpAssignFromStandardBadgeInactive => 'Nieaktywne';

  @override
  String get bhpAssignFromStandardBadgeInfo => 'Informacja';

  @override
  String get bhpAssignFromStandardBadgeWarning => 'Uwaga';

  @override
  String get bhpPositionStandardTitle => 'Stanowisko i standard';

  @override
  String get bhpPositionStandardSaveAction => 'Zapisz stanowisko';

  @override
  String get bhpPositionStandardSaveSuccess => 'Stanowisko zostało zapisane.';

  @override
  String get bhpPositionStandardLoadErrorTitle =>
      'Nie udało się wczytać stanowiska';

  @override
  String get bhpPositionStandardCurrentTitle => 'Aktualne stanowisko';

  @override
  String get bhpPositionStandardNoPosition => 'Brak stanowiska';

  @override
  String get bhpPositionStandardDescriptionTitle => 'Opis stanowiska';

  @override
  String get bhpPositionStandardChangeTitle => 'Zmiana stanowiska';

  @override
  String get bhpPositionStandardSelectHint => 'Wybierz stanowisko';

  @override
  String get bhpPositionStandardSelectedStatus => 'Pozycja wybrana';

  @override
  String get bhpPositionStandardUnselectedStatus => 'Brak wyboru';

  @override
  String get bhpPositionStandardLoadingStandard => 'Wczytywanie standardu...';

  @override
  String bhpPositionStandardStandardCount(int count) {
    return 'Pozycji standardu: $count';
  }

  @override
  String bhpPositionStandardPreviewLabel(Object name) {
    return 'Podgląd standardu: $name';
  }

  @override
  String get bhpPositionStandardEmptyStandardTitle => 'Brak standardu';

  @override
  String get bhpPositionStandardEmptyStandardMessage =>
      'Dla wybranego stanowiska nie ma jeszcze przypisanych pozycji.';

  @override
  String get bhpAddUserTitle => 'Dodaj pracownika';

  @override
  String get bhpAddUserSubtitle =>
      'Nowa karta pracownika BHP z przypisanym stanowiskiem.';

  @override
  String get bhpAddUserLoadErrorTitle => 'Nie udało się przygotować formularza';

  @override
  String bhpAddUserSuccessMessage(Object name) {
    return 'Pracownik $name został dodany.';
  }

  @override
  String get bhpAddUserBaseSectionTitle => 'Dane podstawowe';

  @override
  String get bhpAddUserBaseSectionDescription =>
      'Pola wymagane do utworzenia karty pracownika.';

  @override
  String get bhpAddUserFirstNameLabel => 'Imię';

  @override
  String get bhpAddUserLastNameLabel => 'Nazwisko';

  @override
  String get bhpAddUserPeselLabel => 'PESEL';

  @override
  String get bhpAddUserPhoneLabel => 'Numer telefonu';

  @override
  String get bhpAddUserSelectPositionHint => 'Wybierz stanowisko';

  @override
  String get bhpAddUserPositionRequiredError => 'Stanowisko jest wymagane.';

  @override
  String get bhpAddUserResidenceLabel => 'Miejsce zamieszkania';

  @override
  String get bhpAddUserDimensionsSectionTitle => 'Dane BHP';

  @override
  String get bhpAddUserDimensionsSectionDescription =>
      'Wymiary używane przy przypisaniu wyposażenia.';

  @override
  String get bhpAddUserHeightLabel => 'Wzrost';

  @override
  String get bhpAddUserChestLabel => 'Obwód klatki piersiowej';

  @override
  String get bhpAddUserWaistLabel => 'Obwód pasa';

  @override
  String get bhpAddUserHeadLabel => 'Obwód głowy';

  @override
  String get bhpAddUserFootLabel => 'Długość stopy';

  @override
  String get bhpAddUserSubmitAction => 'Dodaj';

  @override
  String get bhpAddUserPotentialDuplicateTitle =>
      'Podobny pracownik już istnieje';

  @override
  String get bhpAddUserPotentialDuplicateMessage =>
      'Znaleziono pracowników o takich samych danych podstawowych. Sprawdź listę przed zapisem.';

  @override
  String bhpAddUserPotentialDuplicateBannerMessage(Object users) {
    return 'Podobne rekordy: $users. Możesz zapisać dalej, ale warto to sprawdzić.';
  }

  @override
  String get bhpAddUserPotentialDuplicateConfirmAction => 'Dodaj mimo to';

  @override
  String get bhpAddUserPotentialDuplicateCancelAction => 'Wróć do formularza';

  @override
  String get bhpAddUserInvalidEmploymentDatesMessage =>
      'Data zakończenia pracy nie może być wcześniejsza niż data rozpoczęcia.';

  @override
  String get bhpUserEmploymentEndDatePastWarning =>
      'Wybrana data zakończenia pracy jest w przeszłości. Po zapisie pracownik zostanie oznaczony jako nieaktywny.';

  @override
  String get bhpUserIssuesReadOnlyArchivedMessage =>
      'Pracownik jest zarchiwizowany, więc karta wydań działa tylko w trybie podglądu. Przywróć pracownika, aby odblokować edycję.';

  @override
  String get bhpEditUserTitle => 'Edytuj pracownika';

  @override
  String get bhpEditUserLoadErrorTitle =>
      'Nie udało się przygotować formularza edycji';

  @override
  String get bhpEditUserBaseSectionTitle => 'Dane pracownika';

  @override
  String get bhpEditUserBaseSectionDescription =>
      'Zaktualizuj dane podstawowe i parametry używane w wydaniach BHP.';

  @override
  String get bhpEditUserSubmitAction => 'Zapisz zmiany';

  @override
  String bhpEditUserSuccessMessage(Object name) {
    return 'Pracownik $name został zaktualizowany.';
  }

  @override
  String get bhpPreviewNoAssignedPosition => 'Brak przypisanego stanowiska';

  @override
  String get bhpPreviewDescription =>
      'To jest tymczasowy modal pod workflow pracownika. Następny krok to pełny detal z wydaniami.';

  @override
  String get bhpPreviewIssuesAction => 'Wydania';

  @override
  String get bhpPreviewEditPendingMessage =>
      'Edycja pracownika nie jest jeszcze podłączona.';

  @override
  String bhpPreviewArchivedMessage(Object name) {
    return 'Pracownik $name został zarchiwizowany.';
  }

  @override
  String get bhpPreviewRestoreAction => 'Przywróć';

  @override
  String get bhpPreviewRestoreEmployeeMessage =>
      'Przywrócenie odblokuje pracownika. Jeśli ma przeszłą datę zakończenia pracy, zostanie ona wyczyszczona.';

  @override
  String bhpPreviewRestoredMessage(Object name) {
    return 'Pracownik $name został przywrócony.';
  }

  @override
  String get bhpPreviewForceDeleteAction => 'Usuń z bazy';

  @override
  String get bhpForceDeleteUserConfirmTitle => 'Usuń pracownika z bazy';

  @override
  String bhpForceDeleteUserConfirmBody(Object name, Object id) {
    return 'Ta operacja fizycznie i nieodwracalnie usunie pracownika $name (ID: $id) wraz ze wszystkimi powiązanymi wydaniami wyposażenia z bazy danych.';
  }

  @override
  String get bhpForceDeleteUnlockLabel =>
      'Aby odblokować usunięcie, wpisz: Excellent2026';

  @override
  String get bhpForceDeleteUnlockHint =>
      'Wpisz Excellent2026, aby odblokować usunięcie.';

  @override
  String bhpPreviewForceDeletedMessage(Object name) {
    return 'Pracownik $name został usunięty z bazy danych.';
  }

  @override
  String get bhpIssueConfirmStandardTitle =>
      'Generowanie wyposażenia ze standardu';

  @override
  String get bhpIssueConfirmStandardMessage =>
      'Czy na pewno chcesz wygenerować wyposażenie BHP ze standardu stanowiska dla tego pracownika?\n\nSystem sprawdzi przypisane normy dla jego stanowiska i automatycznie utworzy brakujące, aktywne wydania. Istniejące, niezakończone wydania nie zostaną zdublowane.';

  @override
  String get bhpIssueConfirmStandardAction => 'Generuj';

  @override
  String get inneTitle => 'Moduł Inne';

  @override
  String get edit => 'Edytuj';

  @override
  String get inventoryEditCommissionTitle => 'Edytuj komisje';

  @override
  String inventoryCommissionForInventory(Object number) {
    return 'Komisja inwentaryzacji $number';
  }

  @override
  String get inventoryNoAssignedCommissionTitle => 'Brak przypisanej komisji';

  @override
  String get inventoryNoAssignedCommissionMessage =>
      'Do tej inwentaryzacji nie przypisano jeszcze komisji.';

  @override
  String inventoryUserWithId(int id) {
    return 'Użytkownik #$id';
  }

  @override
  String get inventoryNoSheetsTitle => 'Brak arkuszy';

  @override
  String get inventoryNoSheetsMessage =>
      'Dodaj pierwszy arkusz dla tej inwentaryzacji.';

  @override
  String inventorySheetWithId(int id) {
    return 'Arkusz #$id';
  }

  @override
  String inventoryCommissionForSheet(Object label) {
    return 'Komisja arkusza $label';
  }

  @override
  String get inventoryNoAssignedLocation => 'Brak przypisanego miejsca';

  @override
  String get inventoryItemsLabel => 'Elementy';

  @override
  String get inventoryLocationLevelLabel => 'Lvl miejsca';

  @override
  String get start => 'Start';

  @override
  String get end => 'Koniec';

  @override
  String get inventorySheetCommissionNone => 'Komisja arkusza: brak';

  @override
  String inventorySheetCommissionWithMembers(Object members) {
    return 'Komisja arkusza: $members';
  }

  @override
  String get inventoryDeleteCompanyTitle => 'Usuń firmę';

  @override
  String get inventoryDeleteCompanySubtitle =>
      'Operacja usunięcia firmy jest nieodwracalna.';

  @override
  String get inventoryDeleteCompanyConfirmTitle =>
      'Czy na pewno chcesz usunąć tę firmę?';

  @override
  String inventoryDeleteCompanyConfirmBody(Object name, int id) {
    return 'Firma: $name\nID firmy: $id\nTej operacji nie można cofnąć.';
  }

  @override
  String get inventoryDeleteTitle => 'Usuń inwentaryzację';

  @override
  String get inventoryDeleteSubtitle =>
      'Operacja usunięcia inwentaryzacji jest nieodwracalna.';

  @override
  String get inventoryDeleteConfirmTitle =>
      'Czy na pewno chcesz usunąć tę inwentaryzację?';

  @override
  String inventoryDeleteConfirmBody(Object number, int id) {
    return 'Inwentaryzacja: $number\nID: $id\nTej operacji nie można cofnąć.';
  }

  @override
  String get inventoryDeleteUnlockLabel => 'Potwierdzenie';

  @override
  String get inventoryDeleteUnlockHint =>
      'Wpisz Excellent, aby odblokować usunięcie.';

  @override
  String get inventoryDeletedMessage => 'Inwentaryzacja została usunięta.';

  @override
  String get inventorySnapshotRefreshButton => 'Odswiez snapshot';

  @override
  String get inventorySnapshotRefreshTitle => 'Odswiezenie snapshotu ST';

  @override
  String get inventorySnapshotRefreshSubtitle =>
      'Synchronizacja danych ST dla wszystkich baz.';

  @override
  String get inventorySnapshotRefreshConfirmTitle => 'Odswiezenie snapshotu';

  @override
  String get inventorySnapshotRefreshConfirmSubtitle =>
      'Potwierdzenie operacji';

  @override
  String get inventorySnapshotRefreshConfirmQuestion =>
      'Czy na pewno uruchomić odświeżenie snapshotu ST? Operacja może potrwać kilkadziesiąt sekund.';

  @override
  String get inventorySnapshotRefreshUnlockLabel =>
      'Aby odblokować odświeżenie, wpisz: Excellent';

  @override
  String get inventorySnapshotRefreshUnlockHint => 'Wpisz frazę odblokowującą';

  @override
  String get inventorySnapshotRefreshAction => 'Odśwież';

  @override
  String get inventorySnapshotRefreshInProgressTitle =>
      'Trwa odświeżanie snapshotu ST';

  @override
  String get inventorySnapshotRefreshInProgressMessage =>
      'Operacja jest wykonywana. To może potrwać kilkadziesiąt sekund.';

  @override
  String get inventorySnapshotRefreshBlockedTitle =>
      'Nie można odświeżyć snapshotu';

  @override
  String get inventorySnapshotRefreshBlockedMessage =>
      'Istnieje aktywna inwentaryzacja. Zamknij ją i spróbuj ponownie.';

  @override
  String get inventorySnapshotRefreshFailureTitle =>
      'Odświeżenie nie powiodło się';

  @override
  String get inventorySnapshotRefreshSuccessTitle => 'Odświeżenie zakończone';

  @override
  String inventorySnapshotRefreshSuccessMessage(int okCount, int errorCount) {
    return 'Zakończono odświeżanie. Sukces: $okCount, błędy: $errorCount.';
  }

  @override
  String get inventorySnapshotRefreshProcessingAction => 'Przetwarzanie...';

  @override
  String get inventoryCloseTitle => 'Zamknij inwentaryzację';

  @override
  String get inventoryCloseSubtitle =>
      'Po zamknięciu nie będzie już można edytować danych.';

  @override
  String get inventoryCloseConfirmTitle =>
      'Czy na pewno chcesz zamknąć tę inwentaryzację?';

  @override
  String inventoryCloseConfirmBody(Object number, int id) {
    return 'Inwentaryzacja: $number\nID: $id\nStatus zostanie zmieniony na zakończona (2).';
  }

  @override
  String get inventoryCloseDateLabel => 'Data zakończenia (data_do)';

  @override
  String get inventoryCloseUnlockLabel => 'Potwierdzenie zamknięcia';

  @override
  String get inventoryCloseUnlockHint =>
      'Wpisz Excellent, aby odblokować zamknięcie.';

  @override
  String get inventoryCloseBlockedStatusMessage =>
      'Inwentaryzację można zamknąć tylko ze statusu W toku (1).';

  @override
  String get inventoryCloseDateValidationMessage =>
      'Data zakończenia musi być większa lub równa dacie rozpoczęcia.';

  @override
  String get inventoryClosedMessage => 'Inwentaryzacja została zamknięta.';

  @override
  String get inventoryDeleteSheetTitle => 'Usuń arkusz';

  @override
  String get inventoryDeleteSheetSubtitle =>
      'Operacja usunięcia arkusza jest nieodwracalna.';

  @override
  String get inventoryDeleteSheetConfirmTitle =>
      'Czy na pewno chcesz usunąć ten arkusz?';

  @override
  String inventoryDeleteSheetConfirmBody(Object number, int id) {
    return 'Arkusz: $number\nID: $id\nTej operacji nie można cofnąć.';
  }

  @override
  String get inventoryDeleteSheetBlockedMessage =>
      'Nie można usunąć arkusza zakończonej inwentaryzacji (status=2).';

  @override
  String get inventorySheetDeletedMessage => 'Arkusz został usunięty.';

  @override
  String get inventoryArchiveTitle => 'Archiwum';

  @override
  String get inventoryArchiveSubtitle => 'Archiwalne widoki i dane pomocnicze.';

  @override
  String get inventoryCommissionLabel => 'Komisja';

  @override
  String get inventoryReportsShowNotesLabel => 'Pokaż uwagi';

  @override
  String get inventoryReportsDisposalProtocolLabel => 'Protokół kasacji';

  @override
  String get inventoryReportsMacOSWorkaroundPrefix =>
      'macOS workaround: dynamicLayout wyłączony • ';

  @override
  String get inventoryReportsPrintStatusAvailable => 'dostępne';

  @override
  String get inventoryReportsPrintStatusUnavailable => 'niedostępne';

  @override
  String get inventoryReportsShareStatusAvailable => 'dostępne';

  @override
  String get inventoryReportsShareStatusUnavailable => 'niedostępne';

  @override
  String get inventorySearchUserHint => 'Wyszukaj użytkownika...';

  @override
  String get inventorySearching => 'Wyszukiwanie...';

  @override
  String get inventoryTypeMinTwoChars => 'Wpisz min. 2 znaki';

  @override
  String get inventoryNoResults => 'Brak wyników';

  @override
  String get inventoryNoSelectedPeopleTitle => 'Brak wybranych osób';

  @override
  String get inventoryNoSelectedPeopleMessage =>
      'Dodaj użytkowników do komisji z wyszukiwarki.';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get inventoryEditSheetItemTitle => 'Edytuj element arkusza';

  @override
  String inventoryEditSheetItemSubtitle(
    Object name,
    Object register,
    Object barcode,
  ) {
    return '$name ($register) | KK: $barcode';
  }

  @override
  String get inventoryItemSavedMessage => 'Zapisano zmiany elementu.';

  @override
  String get inventoryInventoryStateShort => 'Stan inwent.';

  @override
  String get inventoryInventoryStateNone => 'Brak';

  @override
  String get inventoryInventoryStateMatching => 'Zgodny';

  @override
  String get inventoryInventoryStateTransferred => 'Przeniesiony';

  @override
  String get inventoryScan => 'Skan';

  @override
  String get inventoryScannerNotRead => 'Niewczytane skanerem';

  @override
  String get inventoryScannerRead => 'Wczytane skanerem';

  @override
  String get inventoryLiquidation => 'Likwidacja';

  @override
  String get inventorySurplus => 'Nadwyżka';

  @override
  String get inventoryNewBarcode => 'Nowy kod kreskowy';

  @override
  String get inventoryNewPerson => 'Nowa osoba';

  @override
  String get inventoryNewName => 'Nowa nazwa';

  @override
  String get inventoryLocalRemarksHint => 'Uwagi';

  @override
  String get inventoryNewBarcodeMaxLengthError =>
      'Nowy kod kreskowy może mieć maksymalnie 64 znaki.';

  @override
  String inventoryAddSheetToInventory(int inventoryId) {
    return 'Dodaj arkusz do inwentaryzacji #$inventoryId';
  }

  @override
  String get inventoryLoadLocationsErrorTitle =>
      'Nie udało się załadować miejsc';

  @override
  String get inventoryOptionalCommission => 'Komisja (opcjonalnie)';

  @override
  String get inventorySearchByNameOrLoginHint =>
      'Wyszukaj osobę po nazwie lub loginie...';

  @override
  String get inventorySelectLocationFromTree => 'Wybierz miejsce z drzewa.';

  @override
  String get inventoryScopeAutoSet => 'Arkusz obejmie tylko wybrane miejsce.';

  @override
  String get inventoryNoLocationsTitle => 'Brak miejsc';

  @override
  String get inventoryLocationsBackendEmptyMessage =>
      'Backend nie zwrócił miejsc dla tej inwentaryzacji.';

  @override
  String inventoryIdWithValue(int id) {
    return 'ID $id';
  }

  @override
  String inventoryLocationWithId(int id) {
    return 'Miejsce: $id';
  }

  @override
  String get inventorySelectLocationBeforeCreateError =>
      'Wybierz miejsce w drzewie przed utworzeniem arkusza.';

  @override
  String get inventoryInvalidCommissionFormatError =>
      'Lista komisji ma niepoprawny format.';

  @override
  String get inventorySheetDetailsTitle => 'Szczegóły arkusza';

  @override
  String get inventorySheetDetailsLoadErrorTitle =>
      'Nie udało się pobrać szczegółów arkusza';

  @override
  String get inventorySheetItemsTitle => 'Elementy arkusza';

  @override
  String get inventorySearchSheetItemsHint =>
      'Szukaj po ID, nr ewid., nazwie, osobie, miejscu lub kodzie kreskowym';

  @override
  String get inventoryAdd => 'Dodaj';

  @override
  String get inventoryAddByRegisterNumberShort => 'Dodaj po nr ewid.';

  @override
  String get inventoryAddSheetItemTitle => 'Dodaj element arkusza';

  @override
  String get inventoryAddSheetItemSubtitle =>
      'Dodaj ręcznie nowy element do aktualnego arkusza.';

  @override
  String get inventoryAddSheetItemBarcodeOptionalHelper =>
      'Pole opcjonalne. Jeśli zostawisz puste, backend zapisze 0.';

  @override
  String get inventoryAddSheetItemAtLeastOneFieldError =>
      'Uzupełnij przynajmniej jedno pole identyfikujące element.';

  @override
  String get inventoryAddSheetItemByRegisterNumberTitle =>
      'Dodaj po nr ewidencyjnym';

  @override
  String get inventoryAddSheetItemByRegisterNumberSubtitle =>
      'Wyszukaj i dodaj element do arkusza na podstawie numeru ewidencyjnego.';

  @override
  String get inventorySheetItemAddedMessage => 'Element arkusza został dodany.';

  @override
  String get inventorySheetItemAddedByRegisterNumberMessage =>
      'Element po numerze ewidencyjnym został dodany do arkusza.';

  @override
  String get inventoryBarcodeRequiredError => 'Kod kreskowy jest wymagany.';

  @override
  String get inventoryBarcodePositiveIntegerError =>
      'Podaj poprawny kod kreskowy jako liczbę całkowitą > 0.';

  @override
  String get inventoryRegisterNumberRequiredError =>
      'Nr ewidencyjny jest wymagany.';

  @override
  String get inventoryAssetStateLabel => 'Status ST';

  @override
  String inventoryResultsCount(int filtered, int total) {
    return 'Wyniki: $filtered/$total';
  }

  @override
  String get inventoryNoItemsTitle => 'Brak elementów';

  @override
  String get inventoryNoSearchResultsTitle => 'Brak wyników wyszukiwania';

  @override
  String get inventoryHideFinished => 'Ukryj zakończone';

  @override
  String get inventoryHideFinishedEmptyMessage =>
      'Wszystkie inwentaryzacje są zakończone lub ukryte przez filtr.';

  @override
  String get inventorySheetNoItemsMessage => 'Arkusz nie zawiera elementów.';

  @override
  String get inventoryTryAnotherPhraseMessage => 'Spróbuj wpisać inną frazę.';

  @override
  String get inventorySheetLabel => 'Arkusz spisu';

  @override
  String get inventoryEditSheetNumberAction => 'Zmień numer arkusza';

  @override
  String get inventoryAssetStatusNone => 'Brak';

  @override
  String get inventoryAssetStatusUnconfirmed => 'Niezatwierdzone';

  @override
  String get inventoryAssetStatusInUse => 'W użytkowaniu';

  @override
  String get inventoryAssetStatusDisposed => 'Zlikwidowany';

  @override
  String get inventoryAssetStatusSold => 'Sprzedane';

  @override
  String get inventoryAssetStatusTransferred => 'Przeniesiony';

  @override
  String get inventoryAssetStatusMissingInAssets =>
      'Nie występuje w środkach trwałych';

  @override
  String get inventoryStatusNew => 'Nowa';

  @override
  String get inventoryStatusInProgress => 'W toku';

  @override
  String get inventoryStatusFinished => 'Zakończona';

  @override
  String get inventoryStatusUnknown => 'Nieznany';

  @override
  String get inventorySheetNumberSavedMessage =>
      'Numer arkusza został zapisany.';

  @override
  String get inventoryNumberExampleHint => 'np. INV/2026/04/001';

  @override
  String get inventoryModuleStatusTitle => 'Status modułu';

  @override
  String get inventoryModuleStatusSubtitle =>
      'Bieżące parametry uruchomienia modułu.';

  @override
  String get inventoryModuleInitialRoute => 'Initial route';

  @override
  String get inventoryModuleSession => 'Sesja';

  @override
  String get inventoryModuleSessionNoAuthContext =>
      'UI nie wymaga kontekstu auth';

  @override
  String get bhpUsersFilterActive => 'Aktywni';

  @override
  String get bhpUsersFilterArchived => 'Zarchiwizowani';

  @override
  String get bhpUsersFilterAll => 'Wszyscy';

  @override
  String get bhpUsersRowNumber => 'Lp.';

  @override
  String get bhpUsersOverdueLabel => 'Po terminie';

  @override
  String get bhpUsersUpcomingLabel => 'Zbliża się';

  @override
  String get bhpUsersDaysSuffix => 'dni';

  @override
  String get bhpUserIssuesViewActive => 'Aktywne';

  @override
  String get bhpUserIssuesViewHistory => 'Historia';

  @override
  String get bhpUserIssuesViewStandard => 'Do standardu';

  @override
  String get bhpSectionStatistics => 'Statystyki';

  @override
  String get bhpOperationsTitle => 'Historia operacji';

  @override
  String get bhpOperationsSubtitle =>
      'Pełna lista operacji BHP dla wybranego roku.';

  @override
  String get bhpOperationsEmptyTitle => 'Brak operacji';

  @override
  String get bhpOperationsEmptyMessage =>
      'W wybranym roku nie znaleziono żadnych operacji BHP.';

  @override
  String get bhpStatisticsTitle => 'Statystyki operacji';

  @override
  String get bhpStatisticsSubtitle => 'Miesięczne podsumowanie operacji BHP.';

  @override
  String get bhpStatisticsEmptyTitle => 'Brak danych statystycznych';

  @override
  String get bhpStatisticsEmptyMessage =>
      'W wybranym roku nie ma jeszcze operacji, z których da się policzyć statystyki.';

  @override
  String get bhpStatisticsOperationsTab => 'Operacje';

  @override
  String get bhpStatisticsMonthLabel => 'Miesiąc';

  @override
  String get bhpStatisticsMonthlyTitle => 'Statystyki miesięczne';

  @override
  String get bhpStatisticsOperationsCountLabel => 'Operacje';

  @override
  String get bhpStatisticsItemsCountLabel => 'Sztuki';

  @override
  String get bhpStatisticsUsersCountLabel => 'Pracownicy';

  @override
  String get bhpStatisticsDominantTypeLabel => 'Dominujący typ';

  @override
  String get bhpStatisticsOperationsCaption => 'Zdarzenia w wybranym miesiącu';

  @override
  String get bhpStatisticsItemsCaption => 'Łączna ilość z operacji';

  @override
  String get bhpStatisticsUsersCaption => 'Unikalne osoby objęte ruchem';

  @override
  String get bhpStatisticsDominantTypeCaptionNone => 'Brak danych';

  @override
  String bhpStatisticsDominantTypeCaptionMany(int count) {
    return '$count razy';
  }

  @override
  String get bhpStatisticsTopEquipmentTitle => 'Najczęściej wydawane elementy';

  @override
  String get bhpStatisticsTopUsersTitle => 'Najbardziej aktywni pracownicy';

  @override
  String get bhpStatisticsMonthEmptyMessage =>
      'Brak danych dla wybranego miesiąca.';

  @override
  String get bhpStatisticsIssuesTab => 'Wydania';

  @override
  String get bhpStatisticsStructureTab => 'Struktura';

  @override
  String get bhpStatisticsMissingTab => 'Braki';

  @override
  String get bhpStatisticsComparisonsTab => 'Porównania';

  @override
  String get bhpStatisticsStructurePlaceholderTitle => 'Struktura';

  @override
  String get bhpStatisticsStructurePlaceholderMessage =>
      'Tutaj zbudujemy przekroje typów operacji, stanowisk i kart wyposażenia.';

  @override
  String get bhpStatisticsStructureSummaryTitle => 'Struktura operacji';

  @override
  String get bhpStatisticsStructureSummarySubtitle =>
      'Przekroje pokazują, które rzeczy, stanowiska i osoby generowały najwięcej operacji w wybranym roku.';

  @override
  String get bhpStatisticsStructureEquipmentLabel => 'Różne elementy';

  @override
  String get bhpStatisticsStructurePositionsLabel => 'Różne stanowiska';

  @override
  String get bhpStatisticsStructureTypesTitle => 'Typy operacji';

  @override
  String get bhpStatisticsStructureTypesSubtitle =>
      'Udział poszczególnych typów w całym rocznym feedzie operacji.';

  @override
  String get bhpStatisticsStructureShareLabel => 'Udział';

  @override
  String get bhpStatisticsStructureEquipmentSubtitle =>
      'Zestawienie kart wyposażenia według liczby operacji i wydanej ilości.';

  @override
  String get bhpStatisticsStructurePositionsTitle => 'Stanowiska';

  @override
  String get bhpStatisticsStructurePositionsSubtitle =>
      'Na których stanowiskach wykonano najwięcej operacji i wydano najwięcej sztuk.';

  @override
  String get bhpStatisticsStructureUsersSubtitle =>
      'Kliknięcie w pracownika otwiera jego kartę wydań.';

  @override
  String get bhpStatisticsStructureIssuedCountTooltip =>
      'Suma wszystkich jednostkowych zdarzeń wydania artykułów BHP w tym roku.';

  @override
  String get bhpStatisticsStructureIssuedQuantityTooltip =>
      'Łączna liczba sztuk lub par artykułów BHP wydanych pracownikom.';

  @override
  String get bhpStatisticsStructureEquipmentTooltip =>
      'Liczba różnych typów artykułów BHP, które były wydawane w tym roku.';

  @override
  String get bhpStatisticsStructureUsersTooltip =>
      'Liczba unikalnych pracowników, którzy otrzymali przynajmniej jedno wydanie w tym roku.';

  @override
  String get bhpStatisticsMissingPlaceholderTitle => 'Braki';

  @override
  String get bhpStatisticsMissingPlaceholderMessage =>
      'Tutaj zbudujemy globalny widok osób z niepełnym wyposażeniem.';

  @override
  String get bhpStatisticsMissingSummaryTitle => 'Braki względem standardu';

  @override
  String get bhpStatisticsMissingSummarySubtitle =>
      'Ta zakładka pokaże, komu i czego brakuje względem przypisanego standardu wyposażenia.';

  @override
  String get bhpStatisticsMissingPeopleLabel => 'Osoby z brakami';

  @override
  String get bhpStatisticsMissingItemsLabel => 'Brakujące pozycje';

  @override
  String get bhpStatisticsMissingTopItemLabel => 'Najczęstszy brak';

  @override
  String get bhpStatisticsMissingPeopleTooltip =>
      'To liczba aktywnych pracowników, którym brakuje przynajmniej jednej wymaganej rzeczy ze standardu stanowiska.';

  @override
  String get bhpStatisticsMissingItemsTooltip =>
      'To suma wszystkich pozycji standardu, dla których dziś nie ma aktywnego wydania u pracowników.';

  @override
  String get bhpStatisticsMissingTopItemTooltip =>
      'To element wyposażenia, który najczęściej pojawia się dziś na liście braków.';

  @override
  String get bhpStatisticsMissingBackendTitle => 'Co będzie tutaj widoczne';

  @override
  String get bhpStatisticsMissingBackendMessage =>
      'Po podłączeniu danych pokażemy listę osób z niepełnym wyposażeniem, liczbę braków na osobę i najczęściej brakujące elementy.';

  @override
  String get bhpStatisticsMissingTableTitle => 'Lista osób z brakami';

  @override
  String get bhpStatisticsMissingTableMessage =>
      'Ta tabela będzie służyć do pracy operacyjnej: sortowanie po liczbie braków, osobie i stanowisku.';

  @override
  String get bhpStatisticsMissingTableItemsLabel => 'Czego brakuje';

  @override
  String get bhpStatisticsMissingTableLatestIssueLabel => 'Ostatnie zamknięcie';

  @override
  String get bhpStatisticsMissingNoDataTitle => 'Braki nie występują';

  @override
  String get bhpStatisticsMissingNoDataMessage =>
      'W tej chwili wszyscy aktywni pracownicy mają komplet aktywnych wydań względem standardu.';

  @override
  String get bhpStatisticsMissingEndpointTitle => 'Wymagane dane backendowe';

  @override
  String get bhpStatisticsMissingEndpointMessage =>
      'Do tej zakładki potrzebny jest osobny, globalny endpoint braków. Obecne dane wydań nie wystarczają do policzenia tego widoku dla wszystkich pracowników.';

  @override
  String get bhpStatisticsComparisonsPlaceholderTitle => 'Porównania';

  @override
  String get bhpStatisticsComparisonsPlaceholderMessage =>
      'Tutaj zbudujemy porównania rok do roku i miesiąc do miesiąca.';

  @override
  String get bhpStatisticsIssuesSummaryTitle => 'Dokładne statystyki wydań';

  @override
  String get bhpStatisticsIssuesSummarySubtitle =>
      'Pokazuję bieżący rok, a poprzedni rok jest w nawiasie.';

  @override
  String get bhpStatisticsIssuesTableTitle => 'Lista wydanych rzeczy';

  @override
  String get bhpStatisticsIssuesTableSubtitle =>
      'Sortowanie po łącznej ilości wydanej w wybranym roku.';

  @override
  String get bhpStatisticsIssuesNoDataTitle => 'Brak danych';

  @override
  String get bhpStatisticsIssuesNoDataMessage =>
      'Nie ma wydań dla wybranego roku.';

  @override
  String get bhpStatisticsIssuesIssuedQuantityLabel => 'Łączna ilość wydana';

  @override
  String get bhpStatisticsIssuesIssuedCountLabel => 'Liczba wydań';

  @override
  String get bhpStatisticsIssuesClosedCountLabel => 'Liczba zamknięć';

  @override
  String get bhpStatisticsIssuesEquivalentCountLabel => 'Liczba ekwiwalentów';

  @override
  String get bhpStatisticsIssuesOperationsTooltip =>
      'To wszystkie zdarzenia zapisane w tym roku: wydania, zamknięcia i ekwiwalenty.';

  @override
  String get bhpStatisticsIssuesIssuedQuantityTooltip =>
      'To łączna liczba sztuk, które zostały wydane pracownikom w tym roku.';

  @override
  String get bhpStatisticsIssuesIssuedCountTooltip =>
      'To liczba wszystkich wydań wykonanych w tym roku, niezależnie od ilości sztuk w każdym wydaniu.';

  @override
  String get bhpStatisticsIssuesClosedCountTooltip =>
      'To liczba wydań, które zostały zamknięte albo zwrócone w tym roku.';

  @override
  String get bhpStatisticsIssuesEquivalentCountTooltip =>
      'To liczba przypadków, w których zamiast wydania zarejestrowano ekwiwalent.';

  @override
  String get bhpStatisticsIssuesComparisonLoading =>
      'Trwa pobieranie porównania...';

  @override
  String bhpStatisticsIssuesTableOperationsSuffix(int count) {
    return '$count operacji';
  }

  @override
  String get bhpIssueOperationsTabOperations => 'Operacje';

  @override
  String get bhpIssueOperationsTabStatistics => 'Statystyki';

  @override
  String get bhpIssueOperationsStatisticsTitle => 'Statystyki miesięczne';

  @override
  String get bhpIssueOperationsStatisticsYearLabel => 'Rok';

  @override
  String get bhpIssueOperationsStatisticsNoDataTitle =>
      'Brak danych miesięcznych';

  @override
  String get bhpIssueOperationsStatisticsNoDataMessage =>
      'W wybranym roku nie ma jeszcze operacji, z których da się policzyć statystyki.';

  @override
  String get bhpIssueOperationsStatisticsOperationsLabel => 'Operacje';

  @override
  String get bhpIssueOperationsStatisticsItemsLabel => 'Sztuki';

  @override
  String get bhpIssueOperationsStatisticsUsersLabel => 'Pracownicy';

  @override
  String get bhpIssueOperationsStatisticsDominantTypeLabel => 'Dominujący typ';

  @override
  String get bhpIssueOperationsStatisticsOperationsCaption =>
      'Zdarzenia w wybranym miesiącu';

  @override
  String get bhpIssueOperationsStatisticsItemsCaption =>
      'Łączna ilość z operacji';

  @override
  String get bhpIssueOperationsStatisticsUsersCaption =>
      'Unikalne osoby objęte ruchem';

  @override
  String get bhpIssueOperationsStatisticsDominantTypeCaptionNone =>
      'Brak danych';

  @override
  String bhpIssueOperationsStatisticsDominantTypeCaptionMany(int count) {
    return '$count razy';
  }

  @override
  String get bhpIssueOperationsStatisticsTopEquipmentTitle =>
      'Najczęściej wydawane elementy';

  @override
  String get bhpIssueOperationsStatisticsTopUsersTitle =>
      'Najbardziej aktywni pracownicy';

  @override
  String get bhpIssueOperationsStatisticsNoMonthItemsMessage =>
      'Brak danych dla wybranego miesiąca.';

  @override
  String get bhpOperationsSearchHint =>
      'Szukaj pracownika, sprzętu lub opisu...';

  @override
  String get bhpUserIssuesStandardTitle => 'Do wydania wg standardu';

  @override
  String get bhpUserIssuesStandardSubtitle =>
      'Brakujące pozycje standardu stanowiska bez aktywnego wydania.';

  @override
  String get bhpUserIssuesStandardEmptyTitle => 'Brak brakujących pozycji';

  @override
  String get bhpUserIssuesStandardEmptyMessage =>
      'Wszystkie aktywne pozycje standardu są już pokryte aktywnymi wydaniami.';

  @override
  String get bhpUserIssuesStandardSearchHint => 'Szukaj braków standardu...';

  @override
  String get bhpUserIssuesHistoryTitle => 'Historia wydań';

  @override
  String get bhpUserIssuesHistorySubtitle =>
      'Zakończone wydania. Możesz z nich ponowić wydanie, jeśli pracownik nie ma już aktywnej tej samej karty.';

  @override
  String get bhpUserIssuesHistoryEmptyTitle => 'Brak historii wydań';

  @override
  String get bhpUserIssuesHistoryEmptyMessage =>
      'Ten pracownik nie ma jeszcze żadnych zakończonych wydań.';

  @override
  String get bhpUserIssuesActiveTitle => 'Aktywne wydania';

  @override
  String get bhpUserIssuesActiveSubtitle =>
      'Wyposażenie aktualnie wydane pracownikowi. Tu zamykasz lub wydajesz ponownie.';

  @override
  String get bhpUserIssuesActiveEmptyTitle => 'Brak aktywnych wydań';

  @override
  String get bhpUserIssuesActiveEmptyMessage =>
      'Pracownik nie ma obecnie żadnego aktywnego wydania.';

  @override
  String get bhpUserIssuesBlockedBannerTitle => 'Wydania zablokowane';

  @override
  String get bhpUserIssuesBlockedBannerMessage =>
      'Pracownik nie może obecnie otrzymywać wydań. Sprawdź status pracownika i stanowiska.';

  @override
  String get bhpUserIssuesCompliantBannerTitle => 'Zgodne ze standardem';

  @override
  String bhpUserIssuesCompliantBannerMessage(int count) {
    return 'Wszystkie aktywne pozycje standardu są pokryte aktywnymi wydaniami. Aktywnych wydań: $count.';
  }

  @override
  String get bhpUserIssuesMissingBannerTitle => 'Braki względem standardu';

  @override
  String bhpUserIssuesMissingBannerMessage(int count) {
    return 'Brakuje $count pozycji wymaganych przez standard stanowiska. Uzupełnij je w sekcji \"Do wydania wg standardu\".';
  }

  @override
  String get bhpUserIssuesNoNameFallback => 'Brak nazwy';

  @override
  String get bhpUserIssuesRenewAction => 'Wydaj ponownie';

  @override
  String get bhpUserIssuesIssueStandardConfirmTitle =>
      'Wydać pozycję standardu';

  @override
  String bhpUserIssuesIssueStandardConfirmMessage(Object item) {
    return 'Czy chcesz wydać pozycję $item zgodnie ze standardem stanowiska?';
  }

  @override
  String get bhpUserIssuesIssueStandardConfirmAction => 'Wydaj';

  @override
  String get bhpUserIssuesIssueStandardSuccess =>
      'Pozycja została wydana zgodnie ze standardem.';

  @override
  String get bhpUserIssuesRenewActiveTitle => 'Wydaj ponownie';

  @override
  String bhpUserIssuesRenewActiveMessage(Object item) {
    return 'Poprzednie aktywne wydanie $item zostanie automatycznie zamknięte, a nowe wydanie zostanie utworzone od dziś. Kontynuować?';
  }

  @override
  String get bhpUserIssuesRenewActiveAction => 'Wydaj ponownie';

  @override
  String get bhpUserIssuesRenewActiveSuccess =>
      'Utworzono nowe wydanie, a poprzednie zostało zamknięte.';

  @override
  String get bhpUserIssuesPrintSelectTitle => 'Wybierz pozycje do wydruku';

  @override
  String get bhpUserIssuesPrintOnlyActive => 'Tylko aktywne';

  @override
  String get bhpUserIssuesPrintOnlyInactive => 'Tylko nieaktywne';

  @override
  String get bhpUserIssuesPrintAll => 'Wszystkie';

  @override
  String get bhpUserIssuesPrintEmptyTitle => 'Brak pozycji do wydruku';

  @override
  String get bhpUserIssuesPrintEmptyMessage =>
      'Dla tego pracownika nie ma jeszcze wydań do zaznaczenia.';

  @override
  String get bhpUserIssuesPrintSelectedAction => 'Drukuj zaznaczone';

  @override
  String bhpUserIssuesPrintIssueLabelFallback(int id) {
    return 'Pozycja #$id';
  }

  @override
  String get bhpUserIssuesLastIssueLabel => 'Ostatnie wydanie';

  @override
  String get bhpUserIssueInfoSubtitle => 'Karta wyposażenia';

  @override
  String get bhpUserIssueInfoNoEquipmentTitle => 'Brak karty wyposażenia';

  @override
  String get bhpUserIssueInfoNoEquipmentMessage =>
      'To wydanie nie ma przypisanej karty wyposażenia.';

  @override
  String get bhpUserIssueInfoLoadErrorTitle =>
      'Nie udało się pobrać szczegółów wyposażenia';

  @override
  String get bhpUserIssueInfoRetryAction => 'Spróbuj ponownie';

  @override
  String get bhpUserIssueInfoDescription =>
      'Dane karty wyposażenia z katalogu BHP.';

  @override
  String get bhpUserIssueInfoSymbolLabel => 'Symbol';

  @override
  String get bhpUserIssueInfoNameLabel => 'Nazwa';

  @override
  String get bhpUserIssueInfoUnitLabel => 'Jednostka';

  @override
  String get bhpUserIssueInfoPeriodLabel => 'Okres używalności';

  @override
  String get bhpUserIssueInfoDefaultQuantityLabel => 'Ilość domyślna';

  @override
  String get bhpUserIssueInfoEvidenceNumberLabel => 'Nr dowodu wydania';

  @override
  String get bhpUserIssueInfoEquivalentLabel => 'Ekwiwalent karty';

  @override
  String get bhpUserIssueInfoPriceLabel => 'Cena';

  @override
  String get bhpUserIssueInfoAvailabilityLabel => 'Aktywność';

  @override
  String get bhpUserIssueInfoPercentLabel => 'Procent przydatności';

  @override
  String get bhpUserIssueInfoStatusLabel => 'Status';

  @override
  String get bhpUserIssueInfoMonthSuffix => 'mies.';

  @override
  String get bhpUserIssuesPdfTitle => 'KARTA WYPOSAŻENIA BHP PRACOWNIKA';

  @override
  String get bhpUserIssuesPdfIssuerSignatureLabel => 'Podpis osoby wydającej';

  @override
  String get bhpUserIssuesPdfEmployeeSignatureLabel => 'Podpis pracownika';

  @override
  String get bhpUserIssuesPdfDisclaimer =>
      'Potwierdzam odbiór wyżej wymienionego wyposażenia w stanie zdatnym do użytku oraz zobowiązuję się do używania go zgodnie z przeznaczeniem.';

  @override
  String get bhpUserIssuesPdfHeightLabel => 'Wzrost';

  @override
  String get bhpUserIssuesPdfChestLabel => 'Obwód klatki';

  @override
  String get bhpUserIssuesPdfWaistLabel => 'Obwód pasa';

  @override
  String get bhpUserIssuesPdfHeadLabel => 'Obwód głowy';

  @override
  String get bhpUserIssuesPdfFootLabel => 'Długość stopy';

  @override
  String bhpUserIssuesPdfPageLabel(int current, int total) {
    return 'Strona $current / $total';
  }

  @override
  String get bhpIssueFormEquipmentRequired => 'Wyposażenie jest wymagane.';

  @override
  String get bhpIssueNoEquipmentFallback => 'Brak wyposażenia';

  @override
  String bhpIssueCardFallback(int id) {
    return 'Karta #$id';
  }

  @override
  String get bhpIssueUnknownEquipmentFallback => 'Nieznane wyposażenie';

  @override
  String get bhpIssueEquivalentHelperExisting =>
      'Możesz zmienić datę i kwotę ekwiwalentu. Data nie może być wcześniejsza niż data przydziału.';

  @override
  String get bhpIssueEquivalentHelperOpen =>
      'Ekwiwalent możesz wpisać także dla otwartego wydania. Data nie może być wcześniejsza niż data przydziału.';

  @override
  String get bhpIssueEquivalentHelperClosed =>
      'Data nie może być wcześniejsza niż data przydziału ani data zamknięcia wydania.';

  @override
  String get bhpIssueEquivalentInvalidIssueDate =>
      'Data ekwiwalentu nie może być wcześniejsza niż data przydziału.';

  @override
  String get bhpIssueEquivalentInvalidCloseDate =>
      'Data ekwiwalentu nie może być wcześniejsza niż data zamknięcia wydania.';

  @override
  String get bhpIssueValidationPositiveAmount =>
      'Podaj poprawną kwotę większą od 0.';

  @override
  String get bhpIssueEditInvalidDateMessage =>
      'Wybierz poprawną datę przydziału.';

  @override
  String get bhpIssueEditMissingSourceMessage =>
      'Nie można edytować tego wydania, bo brakuje danych źródłowych.';

  @override
  String get bhpUserIssueCommandInProgress => 'Operacja jest już w toku.';

  @override
  String get bhpDeleteUserTitle => 'Usuń pracownika';

  @override
  String get bhpDeleteUserSubtitle =>
      'Operacja usuwa pracownika z aktywnej listy przez archiwizację.';

  @override
  String bhpDeleteUserConfirmMessage(Object name) {
    return 'Czy na pewno chcesz usunąć $name?';
  }

  @override
  String get bhpDeleteUserArchiveMessage =>
      'Operacja nieodwracalnie usuwa pracownika i całą historię BHP z bazy.';

  @override
  String get bhpArchiveUserAction => 'Archiwizuj';

  @override
  String get bhpArchiveUserTitle => 'Archiwizuj pracownika';

  @override
  String get bhpArchiveUserSubtitle =>
      'Operacja usuwa pracownika z aktywnej listy, ale nie kasuje jego historii BHP.';

  @override
  String bhpArchiveUserConfirmMessage(Object name) {
    return 'Czy na pewno chcesz zarchiwizować $name?';
  }

  @override
  String get bhpArchiveUserMessage =>
      'Pracownik zostanie przeniesiony do archiwum i zniknie z aktywnej listy. Historię BHP będzie można dalej przeglądać, a pracownika później przywrócić.';

  @override
  String get bhpStatisticsComparisonsTabMetrics => 'Wskaźniki roczne';

  @override
  String get bhpStatisticsComparisonsTabProducts => 'Produkty';

  @override
  String get bhpStatisticsComparisonsTabEquivalents => 'Ekwiwalenty';

  @override
  String get bhpStatisticsComparisonsMetricsTitle =>
      'Porównanie głównych wskaźników rocznych';

  @override
  String get bhpStatisticsComparisonsMetricsSubtitle =>
      'Zestawienie najważniejszych wskaźników BHP dla wybranego roku oraz dwóch lat wstecz.';

  @override
  String get bhpStatisticsComparisonsTableColumnMetric => 'Wskaźnik';

  @override
  String bhpStatisticsComparisonsYearLabel(int year) {
    return 'Rok $year';
  }

  @override
  String get bhpStatisticsComparisonsProductsTitle =>
      'Porównanie wydań produktów (artykułów BHP)';

  @override
  String get bhpStatisticsComparisonsProductsSubtitle =>
      'Zestawienie zapotrzebowania na poszczególne produkty w formacie: Liczba wydań (Ilość sztuk).';

  @override
  String get bhpStatisticsComparisonsTableColumnProduct =>
      'Produkt / Artykuł BHP';

  @override
  String get bhpStatisticsComparisonsEquivalentsCountRow =>
      'Liczba wypłaconych ekwiwalentów';

  @override
  String get bhpStatisticsComparisonsEquivalentsCountTooltip =>
      'Łączna liczba zarejestrowanych wypłat ekwiwalentu pieniężnego w danym roku.';

  @override
  String get bhpStatisticsComparisonsEquivalentsAmountRow =>
      'Suma wypłaconych ekwiwalentów';

  @override
  String get bhpStatisticsComparisonsEquivalentsAmountTooltip =>
      'Łączna suma wypłaconych kwot ekwiwalentów (w złotych) w danym roku.';

  @override
  String get bhpStatisticsComparisonsEquivalentsTitle =>
      'Podsumowanie ekwiwalentów';

  @override
  String get bhpStatisticsComparisonsEquivalentsSubtitle =>
      'Zestawienie liczby wypłaconych ekwiwalentów oraz ich łącznej sumy rocznej.';

  @override
  String get bhpStatisticsComparisonsEquivalentsProductsTitle =>
      'Ekwiwalenty według produktów (artykułów BHP)';

  @override
  String get bhpStatisticsComparisonsEquivalentsProductsSubtitle =>
      'Zestawienie wypłat ekwiwalentów za poszczególne produkty w formacie: Liczba wypłat (Suma zł).';

  @override
  String get bhpCurrencyPln => 'zł';

  @override
  String get bhpStatisticsChartTitle => 'Wizualizacja miesięczna';

  @override
  String get bhpStatisticsChartToggleCount => 'Liczba operacji';

  @override
  String get bhpStatisticsChartToggleQuantity => 'Wydana ilość';

  @override
  String get bhpStatisticsChartStructureEquipmentTitle =>
      'Najczęściej wydawane artykuły (Top 5)';

  @override
  String get bhpStatisticsChartStructurePositionsTitle =>
      'Wydania według stanowisk (Top 5)';

  @override
  String get bhpStatisticsChartComparisonsTitle => 'Wizualne porównanie metryk';

  @override
  String get inventoryEditDatesAction => 'Edytuj daty';

  @override
  String get inventoryEditDatesTitle => 'Edycja dat inwentaryzacji';

  @override
  String get inventoryEditDatesSubtitle =>
      'Zmień zakres dat aktywnej inwentaryzacji.';

  @override
  String get inventoryDatesSavedMessage =>
      'Daty inwentaryzacji zostały zapisane.';

  @override
  String get inventoryTreeProgressTitle => 'Wykonanie arkuszy';

  @override
  String get inventoryTreeLoadErrorTitle => 'Nie udało się załadować drzewa';

  @override
  String get inventoryRetryAction => 'Ponów';

  @override
  String get inventoryTreeNoLocationsTitle => 'Brak miejsc do pokazania';

  @override
  String get inventoryTreeNoLocationsMessage =>
      'Ta inwentaryzacja nie ma jeszcze przypisanych miejsc.';

  @override
  String inventoryTreeNodesSummary(int count) {
    return 'Węzły: $count';
  }

  @override
  String inventoryTreeNodesAmbiguousSummary(int count, int ambiguous) {
    return 'Węzły: $count • niejednoznaczne: $ambiguous';
  }

  @override
  String inventoryTreeCompanySummary(int places, int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      places,
      locale: localeName,
      other: '$places miejsc',
      few: '$places miejsca',
      one: '1 miejsce',
    );
    return '$_temp0 • $sheets z arkuszem';
  }

  @override
  String get inventoryTreeCompanyAmbiguousSuffix => ' • są niejednoznaczne';

  @override
  String inventoryProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produktów',
      few: '$count produkty',
      one: '1 produkt',
    );
    return '$_temp0';
  }

  @override
  String inventoryTreeIncompleteTitle(int count) {
    return 'Niewykonane ($count)';
  }

  @override
  String get inventoryTreeStatusAmbiguous => 'Niejednoznaczne';

  @override
  String get inventoryTreeStatusCompleted => 'Wykonano';

  @override
  String get inventoryTreeStatusMissingSheet => 'Brak arkusza';

  @override
  String get inventoryTreeStatusNoProducts => 'Brak produktów';

  @override
  String get inventoryTreeAmbiguousTooltip =>
      'To miejsce ma więcej niż jedno mapowanie dla tej samej firmy i identyfikatora miejsca. Status arkusza nie jest pewny.';

  @override
  String get inventoryTreeProductsTooltip =>
      'Pokaż listę produktów dla tego miejsca';

  @override
  String get inventoryLocationProductsTitle => 'Produkty w miejscu';

  @override
  String get inventoryProductsLoadErrorTitle =>
      'Nie udało się załadować produktów';

  @override
  String get inventoryProductsEmptyTitle => 'Brak produktów';

  @override
  String get inventoryProductsEmptyMessage =>
      'To miejsce nie ma aktywnych produktów w snapshotcie stan_st.';

  @override
  String inventoryProductsShownSummary(int visible, int total) {
    return 'Pokazano $visible z $total produktów';
  }

  @override
  String inventoryProductsSummary(int total) {
    return 'Produkty: $total';
  }

  @override
  String get inventoryShowingLastDataTitle => 'Pokazuję ostatnie dane';

  @override
  String get tasksBoardTitle => 'Zadania projektu';

  @override
  String get tasksBoardErrorTitle => 'Nie udało się otworzyć tablicy';

  @override
  String get tasksBoardForbiddenTitle => 'Nie masz dostępu do tej tablicy';

  @override
  String get tasksBoardNotFoundTitle => 'Nie znaleziono projektu lub tablicy';

  @override
  String get tasksBoardOfflineTitle => 'Brak połączenia z serwerem';

  @override
  String tasksBoardSubtitle(int count) {
    return '$count zadań na tablicy';
  }

  @override
  String get tasksKanbanQuickFilter => 'Szybki filtr tablicy';

  @override
  String get tasksKanbanQuickFilterAll => 'Wszystkie zadania';

  @override
  String get tasksKanbanQuickFilterMine => 'Moje zadania';

  @override
  String get tasksKanbanQuickFilterUnassigned => 'Nieprzypisane';

  @override
  String get tasksKanbanQuickFilterBlocked => 'Zablokowane';

  @override
  String get tasksKanbanQuickFilterDueSoon => 'Termin w ciągu 7 dni';

  @override
  String tasksPresenceCount(int count) {
    return 'Osoby online: $count';
  }

  @override
  String get tasksPresenceOnline => 'Online';

  @override
  String get tasksPresenceOffline => 'Offline';

  @override
  String get tasksRealtimeConnected => 'Zmiany są synchronizowane na żywo';

  @override
  String get tasksRealtimeConnecting => 'Ponowne łączenie z synchronizacją…';

  @override
  String get tasksRealtimeOffline => 'Brak połączenia z synchronizacją';

  @override
  String get tasksColumnEmpty => 'Brak zadań w tej kolumnie';

  @override
  String get tasksQuickCreate => 'Dodaj zadanie';

  @override
  String get tasksQuickCreateHint => 'Nazwa nowego zadania';

  @override
  String get tasksTemplatesUse => 'Użyj szablonu';

  @override
  String get tasksTemplatesTitle => 'Utwórz z szablonu';

  @override
  String get tasksTemplatesDescription =>
      'Wybierz gotowy układ zadania. Gwiazdką ustawisz swój domyślny szablon.';

  @override
  String get tasksTemplatesEmpty =>
      'W tym workspace nie ma jeszcze szablonów zadań.';

  @override
  String get tasksTemplatesDefault => 'Twój domyślny szablon';

  @override
  String get tasksTemplatesApplyHint => 'Kliknij, aby utworzyć zadanie';

  @override
  String get tasksTemplatesSetDefault => 'Ustaw jako domyślny szablon';

  @override
  String get tasksTemplatesClearDefault => 'Usuń domyślny szablon';

  @override
  String get tasksTemplatesNew => 'Nowa formatka';

  @override
  String get tasksTemplatesNewDescription =>
      'Utwórz nową formatkę od zera z własnymi ustawieniami domyślnymi.';

  @override
  String get tasksTemplateForThisTask => 'Formatka dla tego zadania';

  @override
  String get tasksTemplateNoTemplate => 'Bez formatki';

  @override
  String tasksTemplateDefaultChip(String name) {
    return 'Formatka: $name';
  }

  @override
  String get tasksTemplateUsingDefault => 'Domyślna formatka';

  @override
  String tasksBulkSelected(int count) {
    return 'Wybrano: $count';
  }

  @override
  String get tasksBulkMove => 'Przenieś wybrane zadania';

  @override
  String get tasksBulkPriority => 'Zmień priorytet wybranych zadań';

  @override
  String get tasksBulkDueDate => 'Ustaw termin wybranych zadań';

  @override
  String get tasksBulkClearSelection => 'Wyczyść zaznaczenie';

  @override
  String get tasksSelectLoadedGroup => 'Zaznacz tylko zadania w tej grupie';

  @override
  String get tasksSelectLoadedSubtasks => 'Zaznacz tylko podzadania tej gałęzi';

  @override
  String get tasksKeyboardShortcuts =>
      'Ctrl lub Command+A zaznacza wczytane zadania, Escape czyści zaznaczenie, a Alt+strzałka w lewo lub prawo przewija kolumny Kanbanu.';

  @override
  String get tasksManageLabels => 'Zarządzaj etykietami';

  @override
  String get tasksManageCustomFields => 'Pola własne';

  @override
  String get tasksCustomFieldsEmpty => 'Projekt nie ma jeszcze pól własnych.';

  @override
  String get tasksCustomFieldText => 'Tekst';

  @override
  String get tasksCustomFieldNumber => 'Liczba';

  @override
  String get tasksCustomFieldDate => 'Data';

  @override
  String get tasksCustomFieldBoolean => 'Tak/Nie';

  @override
  String get tasksCustomFieldSingleSelect => 'Wybór pojedynczy';

  @override
  String get tasksCustomFieldMultiSelect => 'Wybór wielokrotny';

  @override
  String get tasksCustomFieldUser => 'Użytkownik';

  @override
  String get tasksCreateCustomField => 'Dodaj pole własne';

  @override
  String get tasksEditCustomField => 'Edytuj pole własne';

  @override
  String get tasksArchiveCustomField => 'Archiwizuj pole własne';

  @override
  String tasksArchiveCustomFieldConfirm(String name) {
    return 'Zarchiwizować pole „$name”? Zachowane wartości pozostaną w historii, ale pole zniknie z nowych zadań.';
  }

  @override
  String get tasksCustomFieldName => 'Nazwa pola';

  @override
  String get tasksCustomFieldType => 'Typ pola';

  @override
  String get tasksCustomFieldOptions => 'Opcje (po jednej w wierszu)';

  @override
  String get tasksCustomFieldOptionsHint => 'Np. Do zrobienia, W toku, Gotowe';

  @override
  String get tasksCustomFieldNameRequired => 'Wpisz nazwę pola.';

  @override
  String get tasksCustomFieldOptionsRequired =>
      'Dodaj co najmniej jedną opcję.';

  @override
  String get tasksCustomFieldTypeImmutable =>
      'Typ pola jest ustalany przy tworzeniu i nie może zostać zmieniony.';

  @override
  String get tasksManageMilestones => 'Kamienie milowe';

  @override
  String get tasksManageWorkflow => 'Przejścia workflow';

  @override
  String get tasksWorkflowDescription =>
      'Włącz przejścia, które użytkownicy mogą wykonać na tablicy Kanban.';

  @override
  String get tasksWorkflowEmpty =>
      'Projekt nie ma skonfigurowanych statusów workflow.';

  @override
  String get tasksWorkflowAllowTransition =>
      'Dozwolone przejścia z tego statusu';

  @override
  String get tasksWorkflowInitial => 'Początkowy';

  @override
  String get tasksWorkflowTerminal => 'Końcowy';

  @override
  String get tasksCustomWorkflowTitle => 'Własne statusy';

  @override
  String get tasksCustomWorkflowAddStatus => 'Dodaj status';

  @override
  String get tasksCustomWorkflowStatusName => 'Nazwa statusu';

  @override
  String get tasksCustomWorkflowCategory => 'Kategoria';

  @override
  String get tasksCustomWorkflowColor => 'Kolor';

  @override
  String get tasksCustomWorkflowCategoryTodo => 'Do zrobienia';

  @override
  String get tasksCustomWorkflowCategoryInProgress => 'W toku';

  @override
  String get tasksCustomWorkflowCategoryDone => 'Gotowe';

  @override
  String get tasksCustomWorkflowCategoryCancelled => 'Anulowane';

  @override
  String get tasksCustomWorkflowDefault => 'Domyślny status';

  @override
  String get tasksCustomWorkflowWip => 'Limit WIP';

  @override
  String get tasksCustomWorkflowTemplates => 'Szablony workflow';

  @override
  String get tasksCustomWorkflowReplaceWarning =>
      'Zastosowanie szablonu zastąpi bieżące własne statusy i ich kolejność.';

  @override
  String get tasksCustomWorkflowApply => 'Zastosuj szablon';

  @override
  String get tasksAutomationsTitle => 'Automatyzacje';

  @override
  String get tasksSettings => 'Ustawienia Tasks';

  @override
  String get tasksSettingsHubDescription =>
      'Wspólna konfiguracja projektu i prywatne ustawienia w jednym miejscu.';

  @override
  String get tasksAdministration => 'Administracja';

  @override
  String get tasksPersonalSettings => 'Moje ustawienia';

  @override
  String get tasksPersonalSettingsDescription =>
      'Ta notatka jest prywatna i zapisana tylko na tym urządzeniu. Nie jest widoczna dla zespołu.';

  @override
  String get tasksPersonalNote => 'Moja notatka do projektu';

  @override
  String get tasksPersonalNoteHint =>
      'Np. priorytety na ten tydzień, kontekst pracy lub przypomnienie';

  @override
  String get tasksPersonalSettingsSaved => 'Zapisano moje ustawienia.';

  @override
  String get tasksKanbanSettingsTitle => 'Ustawienia Kanbana';

  @override
  String get tasksKanbanSettingsDescription =>
      'Skonfiguruj wspólny układ tablicy dla całego projektu.';

  @override
  String get tasksKanbanLayout => 'Układ tablicy';

  @override
  String get tasksKanbanSwimlane => 'Grupowanie poziome';

  @override
  String get tasksKanbanSwimlaneNone => 'Bez grupowania';

  @override
  String get tasksKanbanSwimlaneAssignee => 'Według osoby przypisanej';

  @override
  String get tasksKanbanSwimlanePriority => 'Według priorytetu';

  @override
  String get tasksKanbanSwimlaneMilestone => 'Według kamienia milowego';

  @override
  String get tasksKanbanCardDensity => 'Gęstość kart';

  @override
  String get tasksKanbanDensityCompact => 'Kompaktowa';

  @override
  String get tasksKanbanDensityComfortable => 'Wygodna';

  @override
  String get tasksKanbanDensityDetailed => 'Szczegółowa';

  @override
  String get tasksKanbanVisibleColumns => 'Widoczne kolumny systemowe';

  @override
  String get tasksKanbanCardFields => 'Pola na kartach';

  @override
  String get tasksKanbanFieldAssignee => 'Osoby przypisane';

  @override
  String get tasksKanbanFieldDueDate => 'Termin';

  @override
  String get tasksKanbanFieldLabels => 'Etykiety';

  @override
  String get tasksKanbanFieldChecklist => 'Lista kontrolna';

  @override
  String get tasksKanbanFieldSubtasks => 'Podzadania';

  @override
  String get tasksKanbanFieldTimeTracking => 'Czas pracy';

  @override
  String get tasksKanbanFieldBlockers => 'Blokady';

  @override
  String get tasksKanbanFieldCoverAttachment => 'Okładka załącznika';

  @override
  String get tasksKanbanFieldCustomFields => 'Pola własne';

  @override
  String get tasksKanbanWipLimits => 'Limity zadań w toku (WIP)';

  @override
  String get tasksKanbanWipLimitsDescription =>
      'Puste pole oznacza brak limitu dla danej kolumny.';

  @override
  String get tasksKanbanWipUnlimited => 'Bez limitu';

  @override
  String get tasksAutomationsDescription =>
      'Reguły wykonują działania w odpowiedzi na zdarzenia projektu.';

  @override
  String get tasksAutomationsRules => 'Reguły projektu';

  @override
  String get tasksAutomationsEmpty => 'Projekt nie ma jeszcze automatyzacji.';

  @override
  String get tasksAutomationsRecipes => 'Gotowe przepisy';

  @override
  String get tasksAutomationsRecipesEmpty =>
      'Brak dostępnych przepisów automatyzacji.';

  @override
  String get tasksAutomationsInstall => 'Zainstaluj';

  @override
  String get tasksAutomationsArchive => 'Archiwizuj';

  @override
  String tasksAutomationsArchiveConfirm(String name) {
    return 'Zarchiwizować automatyzację „$name”? Zatrzyma się natychmiast, ale historia uruchomień pozostanie dostępna.';
  }

  @override
  String tasksAutomationsRuleSummary(String trigger, int count) {
    return 'Wyzwalacz: $trigger · uruchomienia: $count';
  }

  @override
  String get tasksAutomationTriggerTaskCreated => 'utworzenie zadania';

  @override
  String get tasksAutomationTriggerTaskStatusChanged =>
      'zmiana statusu zadania';

  @override
  String get tasksAutomationTriggerTaskKanbanMoved =>
      'przeniesienie na Kanbanie';

  @override
  String get tasksAutomationTriggerTaskDueSoon => 'zbliżający się termin';

  @override
  String get tasksAutomationTriggerFileUploaded => 'dodanie pliku';

  @override
  String get tasksAutomationTriggerWikiPublished => 'publikacja Wiki';

  @override
  String get tasksAutomationTriggerWhiteboardExported => 'eksport whiteboardu';

  @override
  String get tasksAutomationTriggerSchedule => 'harmonogram';

  @override
  String get tasksAutomationsRuns => 'Historia uruchomień';

  @override
  String get tasksAutomationsRunsEmpty =>
      'Ta automatyzacja nie została jeszcze uruchomiona.';

  @override
  String get tasksAutomationRunQueued => 'W kolejce';

  @override
  String get tasksAutomationRunRunning => 'W trakcie';

  @override
  String get tasksAutomationRunSucceeded => 'Zakończono';

  @override
  String get tasksAutomationRunPartiallySucceeded => 'Częściowo zakończono';

  @override
  String get tasksAutomationRunFailed => 'Niepowodzenie';

  @override
  String get tasksAutomationRunSkippedConditions => 'Pominięto: warunki';

  @override
  String get tasksAutomationRunSkippedDisabled => 'Pominięto: reguła wyłączona';

  @override
  String get tasksAutomationRunSkippedLoop => 'Pominięto: ochrona przed pętlą';

  @override
  String get tasksAutomationsDryRun => 'Symuluj';

  @override
  String get tasksAutomationsDryRunDescription =>
      'Symulacja nie zapisuje zmian. Wybierz zadanie, aby sprawdzić warunki i planowane akcje.';

  @override
  String get tasksAutomationsSelectTask => 'Zadanie do symulacji';

  @override
  String get tasksAutomationsTasksEmpty =>
      'Projekt nie ma zadań dostępnych do symulacji.';

  @override
  String get tasksAutomationsDryRunMatched => 'Warunki są spełnione';

  @override
  String get tasksAutomationsDryRunSkipped => 'Warunki nie są spełnione';

  @override
  String get tasksPresenceAnonymousUser => 'Użytkownik obecny w widoku';

  @override
  String get tasksListEmpty => 'Brak zadań spełniających wybrane filtry.';

  @override
  String get tasksListLoadMore => 'Pokaż kolejne zadania';

  @override
  String get tasksListStatus => 'Status';

  @override
  String get tasksListPriority => 'Priorytet';

  @override
  String get tasksListTask => 'Zadanie';

  @override
  String get tasksListOwner => 'Właściciel';

  @override
  String get tasksListDueDate => 'Termin';

  @override
  String get tasksListProgress => 'Postęp';

  @override
  String get tasksListActions => 'Akcje zadania';

  @override
  String get tasksListAll => 'Wszystkie';

  @override
  String get tasksListStatusBacklog => 'Backlog';

  @override
  String get tasksListStatusTodo => 'Do zrobienia';

  @override
  String get tasksListStatusInProgress => 'W toku';

  @override
  String get tasksListStatusBlocked => 'Zablokowane';

  @override
  String get tasksListStatusDone => 'Gotowe';

  @override
  String get tasksListStatusCancelled => 'Anulowane';

  @override
  String get tasksViewBoard => 'Tablica';

  @override
  String get tasksViewRecurrence => 'Cykliczne';

  @override
  String get tasksViewList => 'Lista';

  @override
  String get tasksMilestonesEmpty => 'Projekt nie ma jeszcze kamieni milowych.';

  @override
  String get tasksCreateMilestone => 'Dodaj kamień milowy';

  @override
  String get tasksEditMilestone => 'Edytuj kamień milowy';

  @override
  String get tasksDeleteMilestone => 'Usuń kamień milowy';

  @override
  String tasksDeleteMilestoneConfirm(String name) {
    return 'Usunąć kamień milowy „$name”? Tej operacji nie można cofnąć.';
  }

  @override
  String get tasksMilestoneName => 'Nazwa kamienia milowego';

  @override
  String get tasksMilestoneDescription => 'Opis';

  @override
  String get tasksMilestoneDueDate => 'Termin';

  @override
  String get tasksMilestoneNoDueDate => 'Bez terminu';

  @override
  String get tasksMilestoneStatus => 'Status';

  @override
  String get tasksMilestoneActive => 'Aktywny';

  @override
  String get tasksMilestoneCompleted => 'Ukończony';

  @override
  String get tasksMilestoneCancelled => 'Anulowany';

  @override
  String get tasksMilestoneNameRequired => 'Wpisz nazwę kamienia milowego.';

  @override
  String get tasksMilestoneTasksEmpty => 'Brak przypisanych zadań.';

  @override
  String get taskDetailsMilestone => 'Kamień milowy';

  @override
  String get taskDetailsNoMilestone => 'Nie przypisano';

  @override
  String get taskDetailsRemoveMilestone => 'Usuń przypisanie';

  @override
  String get taskDetailsMilestoneUnavailable =>
      'Nie udało się odczytać przypisania — kliknij, aby spróbować ponownie.';

  @override
  String get taskDetailsLoading => 'Ładowanie…';

  @override
  String get tasksLabelsSettingsDescription =>
      'Etykiety są dostępne dla wszystkich zadań w tym projekcie.';

  @override
  String get tasksLabelsEmpty => 'Projekt nie ma jeszcze aktywnych etykiet.';

  @override
  String get tasksCreateLabel => 'Dodaj etykietę';

  @override
  String get tasksEditLabel => 'Edytuj etykietę';

  @override
  String get tasksArchiveLabel => 'Archiwizuj etykietę';

  @override
  String tasksArchiveLabelConfirm(String name) {
    return 'Zarchiwizować etykietę „$name”? Nie będzie można przypisać jej do nowych zadań.';
  }

  @override
  String get tasksLabelName => 'Nazwa etykiety';

  @override
  String get tasksLabelColor => 'Kolor';

  @override
  String get tasksLabelNameRequired => 'Wpisz nazwę etykiety.';

  @override
  String get tasksArchiveAction => 'Archiwizuj';

  @override
  String tasksSelectTask(String taskCode) {
    return 'Wybierz zadanie $taskCode';
  }

  @override
  String tasksOpenTask(Object taskCode, Object title) {
    return 'Otwórz zadanie $taskCode: $title';
  }

  @override
  String tasksExpandColumn(Object name) {
    return 'Rozwiń kolumnę $name';
  }

  @override
  String tasksDropAtEnd(String name) {
    return 'Upuść zadanie na końcu kolumny $name';
  }

  @override
  String get tasksPinTask => 'Przypnij zadanie';

  @override
  String get tasksUnpinTask => 'Odepnij zadanie';

  @override
  String get tasksWatchTask => 'Obserwuj zadanie';

  @override
  String get tasksUnwatchTask => 'Przestań obserwować zadanie';

  @override
  String get tasksRecurrenceSeries => 'Seria';

  @override
  String get tasksRecurrenceCycle => 'Cykl';

  @override
  String get tasksAssignedToMilestone => 'Przypisano do kamienia milowego';

  @override
  String tasksShowSubtasks(int count) {
    return 'Pokaż podzadania ($count)';
  }

  @override
  String get tasksHideSubtasks => 'Ukryj podzadania';

  @override
  String get tasksSubtasksLoading => 'Ładowanie podzadań…';

  @override
  String get tasksSubtasksError => 'Błąd ładowania podzadań';

  @override
  String get tasksSubtasksEmpty => 'Brak podzadań';

  @override
  String tasksSubtasksMore(int count) {
    return '+$count więcej';
  }

  @override
  String get tasksSubtasksTitle => 'Podzadania';

  @override
  String tasksSubtasksShowMoreRemaining(int count) {
    return 'Pokaż $count kolejne';
  }

  @override
  String get tasksAddSubtask => 'Dodaj podzadanie';

  @override
  String get tasksContextMenuOpen => 'Otwórz szczegóły';

  @override
  String get tasksContextMenuCopyCode => 'Kopiuj kod zadania';

  @override
  String get tasksContextMenuCopyLink => 'Kopiuj link do zadania';

  @override
  String get tasksContextMenuStatus => 'Zmień status';

  @override
  String get tasksContextMenuPriority => 'Zmień priorytet';

  @override
  String get tasksContextMenuAssignee => 'Zmień wykonawcę';

  @override
  String get tasksContextMenuDueDate => 'Zmień termin';

  @override
  String get tasksContextMenuAddSubtask => 'Dodaj podzadanie';

  @override
  String get tasksTemplatesManage => 'Zarządzaj szablonem';

  @override
  String get tasksTemplateLineItemsHint => 'Jeden element w wierszu';

  @override
  String get tasksTemplatesRename => 'Zmień nazwę';

  @override
  String get tasksTemplatesDeleteTitle => 'Usunąć szablon?';

  @override
  String tasksTemplatesDeleteDescription(String name) {
    return 'Szablon „$name” zostanie trwale usunięty.';
  }

  @override
  String get taskDetailsArchive => 'Archiwizuj zadanie';

  @override
  String get taskDetailsRestore => 'Przywróć zadanie';

  @override
  String get taskDetailsArchiveConfirmTitle => 'Archiwizować zadanie?';

  @override
  String get taskDetailsArchiveConfirmMessage =>
      'Zadanie zniknie z aktywnych widoków, ale będzie można je później przywrócić.';

  @override
  String get taskDetailsHistory => 'Historia zmian';

  @override
  String get taskDetailsCreateTemplate => 'Zapisz jako szablon';

  @override
  String get taskDetailsCreateTemplateTitle => 'Nowy szablon zadania';

  @override
  String get taskDetailsCreateTemplateDescription =>
      'Aktualny stan tego zadania zostanie zapisany jako szablon w tym workspace.';

  @override
  String get taskDetailsTemplateName => 'Nazwa szablonu';

  @override
  String get taskDetailsTemplateCreated => 'Utworzono szablon zadania.';

  @override
  String get taskDetailsHistoryEmpty =>
      'Nie zarejestrowano jeszcze żadnych zmian.';

  @override
  String get taskDetailsHistoryRetry => 'Spróbuj ponownie';

  @override
  String get taskDetailsHistoryActorSystem => 'System';

  @override
  String get taskDetailsHistoryActorAutomation => 'Automatyzacja';

  @override
  String get taskDetailsHistoryActorUser => 'Użytkownik';

  @override
  String taskDetailsHistoryVersion(int version) {
    return 'w.$version';
  }

  @override
  String get taskDetailsRecurrence => 'Cykliczność';

  @override
  String get taskDetailsConfigureRecurrence => 'Skonfiguruj';

  @override
  String get taskDetailsRecurrenceNotConfigured =>
      'To zadanie nie jest cykliczne.';

  @override
  String taskDetailsRecurrenceEvery(int count) {
    return 'co $count';
  }

  @override
  String get taskDetailsRecurrenceActive => 'Aktywna';

  @override
  String get taskDetailsRecurrencePaused => 'Wstrzymana';

  @override
  String get taskDetailsRecurrenceMode => 'Tryb harmonogramu';

  @override
  String get taskDetailsRecurrenceModeScheduled => 'Według harmonogramu';

  @override
  String get taskDetailsRecurrenceModeAfterCompletion => 'Po ukończeniu';

  @override
  String get taskDetailsRecurrenceFrequency => 'Częstotliwość';

  @override
  String get taskDetailsRecurrenceFrequencyDaily => 'Codziennie';

  @override
  String get taskDetailsRecurrenceFrequencyWeekly => 'Co tydzień';

  @override
  String get taskDetailsRecurrenceFrequencyMonthly => 'Co miesiąc';

  @override
  String get taskDetailsRecurrenceInterval => 'Co ile okresów';

  @override
  String get taskDetailsRecurrenceTimeZone => 'Strefa czasowa IANA';

  @override
  String get taskDetailsRecurrenceOccurrenceStatus =>
      'Status nowego wystąpienia';

  @override
  String get taskDetailsRecurrenceSkipPrevious =>
      'Pomiń, gdy poprzednie wystąpienie jest otwarte';

  @override
  String get taskDetailsRecurrenceFirstOccurrence => 'Pierwsze wystąpienie';

  @override
  String get taskDetailsRecurrenceNextOccurrence => 'Następne wystąpienie';

  @override
  String get taskDetailsRecurrencePause => 'Wstrzymaj cykliczność';

  @override
  String get taskDetailsRecurrenceResume => 'Wznów cykliczność';

  @override
  String get taskDetailsRecurrenceCreate => 'Utwórz cykliczność';

  @override
  String get taskDetailsRecurrenceInvalid =>
      'Wpisz dodatni interwał i poprawną strefę IANA, np. Europe/Warsaw.';

  @override
  String get taskDetailsRecurrenceRetry => 'Spróbuj ponownie';

  @override
  String get taskDetailsAttachments => 'Załączniki';

  @override
  String get taskDetailsAttachmentsAdd => 'Dodaj pliki';

  @override
  String get taskDetailsAttachmentsEmpty => 'Nie ma jeszcze załączników';

  @override
  String get taskDetailsAttachmentsSelect =>
      'Wybierz pliki, aby dodać je do tego zadania.';

  @override
  String get taskDetailsAttachmentsDrop => 'Upuść pliki tutaj, aby je załączyć';

  @override
  String get taskDetailsAttachmentsQueued => 'Oczekuje na wysłanie';

  @override
  String get taskDetailsAttachmentsUploading => 'Wysyłanie';

  @override
  String get taskDetailsAttachmentsUploaded => 'Wysłano';

  @override
  String get taskDetailsAttachmentsFailed => 'Wysyłanie nie powiodło się';

  @override
  String get taskDetailsTimeTracking => 'Rejestracja czasu';

  @override
  String get taskDetailsTimeAdd => 'Dodaj czas';

  @override
  String taskDetailsTimeTotal(String duration) {
    return 'Zarejestrowano: $duration';
  }

  @override
  String get taskDetailsTimeStart => 'Uruchom timer';

  @override
  String get taskDetailsTimeStop => 'Zatrzymaj timer';

  @override
  String get taskDetailsTimeNoDescription => 'Bez opisu';

  @override
  String get taskDetailsTimeSubmit => 'Prześlij';

  @override
  String get taskDetailsTimeMinutes => 'Czas w minutach';

  @override
  String get taskDetailsTimeDescription => 'Opis';

  @override
  String get taskDetailsTimeBillable => 'Rozliczalne';

  @override
  String get taskDetailsTimeDraft => 'Szkic';

  @override
  String get taskDetailsTimeSubmitted => 'Przesłano';

  @override
  String get taskDetailsTimeApproved => 'Zaakceptowano';

  @override
  String get taskDetailsTimeRejected => 'Odrzucono';

  @override
  String get tasksBoardEmpty => 'Projekt nie ma skonfigurowanych kolumn';

  @override
  String get tasksPriorityLow => 'Niski priorytet';

  @override
  String get tasksPriorityNormal => 'Normalny priorytet';

  @override
  String get tasksPriorityHigh => 'Wysoki priorytet';

  @override
  String get tasksPriorityCritical => 'Krytyczny priorytet';

  @override
  String get taskDetailsClose => 'Zamknij szczegóły zadania';

  @override
  String get taskDetailsArchived => 'Zarchiwizowane';

  @override
  String get taskDetailsProperties => 'Właściwości';

  @override
  String get taskDetailsAssignees => 'Wykonawcy';

  @override
  String get taskDetailsEditAssignees => 'Edytuj wykonawców';

  @override
  String get taskDetailsAssigneesLoadError =>
      'Nie udało się pobrać członków projektu.';

  @override
  String get taskDetailsNoProjectMembers =>
      'Brak dostępnych członków projektu.';

  @override
  String get taskDetailsProjectMember => 'Członek projektu';

  @override
  String get taskDetailsNobody => 'Nie przypisano';

  @override
  String get taskDetailsWatch => 'Obserwuj zadanie';

  @override
  String get taskDetailsStopWatching => 'Przestań obserwować zadanie';

  @override
  String get taskDetailsWatchers => 'Obserwujący';

  @override
  String get taskDetailsNoWatchers =>
      'Nikt jeszcze nie obserwuje tego zadania.';

  @override
  String taskDetailsWatchersMore(int count) {
    return '+$count';
  }

  @override
  String get taskDetailsPin => 'Przypnij zadanie';

  @override
  String get taskDetailsUnpin => 'Odepnij zadanie';

  @override
  String get taskDetailsLabels => 'Etykiety';

  @override
  String get taskDetailsEditLabels => 'Edytuj etykiety';

  @override
  String get taskDetailsNoLabels => 'Nie przypisano jeszcze etykiet.';

  @override
  String get taskDetailsNoProjectLabels =>
      'Projekt nie ma jeszcze aktywnych etykiet.';

  @override
  String get taskDetailsCustomFields => 'Pola własne';

  @override
  String get taskDetailsEditCustomFields => 'Edytuj pola własne';

  @override
  String get taskDetailsNoCustomFields =>
      'Projekt nie ma skonfigurowanych pól własnych.';

  @override
  String get taskDetailsRequiredField => 'Wymagane';

  @override
  String get taskDetailsInvalidNumber => 'Wpisz poprawną liczbę.';

  @override
  String get taskDetailsUserFieldUnavailable =>
      'Wybór użytkownika wymaga katalogu członków projektu.';

  @override
  String get taskDetailsDueDate => 'Termin';

  @override
  String get tasksTemplateTaskType => 'Typ zadania';

  @override
  String get tasksTemplateSize => 'Rozmiar';

  @override
  String get tasksTemplateComplexity => 'Złożoność';

  @override
  String get tasksTemplateRisk => 'Ryzyko';

  @override
  String get tasksTemplateBusinessValue => 'Wartość biznesowa';

  @override
  String get tasksTemplateAddLabel => 'Dodaj etykietę';

  @override
  String get tasksTemplateNoLabels => 'Brak etykiet w szablonie';

  @override
  String get tasksTemplateAssignees => 'Domyślni wykonawcy';

  @override
  String get tasksTemplateCustomValues => 'Pola własne';

  @override
  String get tasksTemplateAddCustomValue => 'Dodaj wartość';

  @override
  String get tasksTemplateNoCustomValues => 'Brak wartości pól własnych';

  @override
  String get tasksTemplateCustomValue => 'Wartość';

  @override
  String get tasksTemplateMultiValueHint => 'Oddziel wartości przecinkami';

  @override
  String get tasksTemplatesUnsavedTitle => 'Odrzucić niezapisane zmiany?';

  @override
  String get tasksTemplatesUnsavedDescription =>
      'Masz niezapisane zmiany w formularzu formatki. Czy na pewno chcesz je odrzucić?';

  @override
  String get tasksTemplatesDiscardChanges => 'Odrzuć zmiany';

  @override
  String get tasksTemplatesKeepEditing => 'Wróć do edycji';

  @override
  String get tasksTemplatesCreateAction => 'Utwórz formatkę';

  @override
  String get tasksTemplatesSaveAction => 'Zapisz zmiany';

  @override
  String get tasksTemplatesFormFixErrors =>
      'Popraw oznaczone pola w formularzu.';

  @override
  String get tasksTemplatesNameRequired => 'Nazwa formatki jest wymagana.';

  @override
  String get tasksTemplatesNameTooLong =>
      'Nazwa formatki może mieć maksymalnie 160 znaków.';

  @override
  String get tasksTemplatesTitleRequired => 'Tytuł zadania jest wymagany.';

  @override
  String get tasksTemplatesTitleTooLong =>
      'Tytuł zadania może mieć maksymalnie 240 znaków.';

  @override
  String get tasksTemplatesDescriptionTooLong =>
      'Opis może mieć maksymalnie 20 000 znaków.';

  @override
  String get tasksTemplatesInvalidDueDate =>
      'Termin końcowy nie może być wcześniejszy niż początkowy.';

  @override
  String get tasksTemplatesInvalidEstimate =>
      'Estymata musi być dodatnią liczbą całkowitą minut.';

  @override
  String get tasksTemplatesInvalidPercentage =>
      'Wartość musi być liczbą całkowitą od 0 do 100.';

  @override
  String get tasksTemplatesTaskTypeTooLong =>
      'Typ zadania może mieć maksymalnie 80 znaków.';

  @override
  String get tasksTemplatesChecklistItemTooLong =>
      'Element checklisty może mieć maksymalnie 500 znaków.';

  @override
  String get tasksTemplatesCriteriaTooLong =>
      'Kryterium akceptacji może mieć maksymalnie 1000 znaków.';

  @override
  String get tasksTemplatesLabelDuplicate =>
      'Etykieta o tej nazwie już istnieje.';

  @override
  String get tasksTemplatesCustomFieldDuplicate =>
      'Pole o tej nazwie już istnieje.';

  @override
  String get tasksTemplatesSectionBasic => 'Podstawowe';

  @override
  String get tasksTemplatesSectionPlanning => 'Planowanie';

  @override
  String get tasksTemplatesSectionResponsibility => 'Odpowiedzialność';

  @override
  String get tasksTemplatesSectionScope => 'Zakres pracy';

  @override
  String get tasksTemplatesSectionClassification => 'Klasyfikacja';

  @override
  String get tasksTemplatesSectionMetadata => 'Metadane';

  @override
  String get tasksTemplatesAssigneesSearchHint => 'Szukaj osób...';

  @override
  String get tasksTemplatesAssigneesEmpty => 'Brak pasujących osób';

  @override
  String get tasksTemplatesAssigneesLoadError =>
      'Nie udało się pobrać listy osób';

  @override
  String get tasksTemplatesEmptyCreateCta => 'Utwórz pierwszą formatkę';

  @override
  String get tasksTemplatesUseTileAction => 'Użyj';

  @override
  String get tasksTemplatesCustomStatus => 'Własna kolumna';

  @override
  String get tasksTemplatesSystemStatus => 'Status systemowy';

  @override
  String get tasksAutomationsCreate => 'Nowa automatyzacja';

  @override
  String get tasksAutomationsName => 'Nazwa reguły';

  @override
  String get tasksAutomationsEdit => 'Edytuj automatyzację';

  @override
  String get tasksAutomationsConditionStatus => 'Tylko gdy status zadania to';

  @override
  String get tasksAutomationsConditionPriority =>
      'Tylko gdy priorytet zadania to';

  @override
  String get tasksAutomationsConditionDueWithinDays =>
      'Tylko gdy termin jest w ciągu (dni)';

  @override
  String get tasksAutomationsConditionTitleContains =>
      'Tylko gdy tytuł zawiera';

  @override
  String get tasksAutomationsConditionOptional =>
      'Pozostaw puste, aby nie używać tego warunku.';

  @override
  String get tasksAutomationsConditionAssignee => 'Tylko gdy wykonawcą jest';

  @override
  String get tasksAutomationsConditionLabel => 'Tylko gdy zadanie ma etykietę';

  @override
  String get tasksAutomationsUnknownMember => 'Członek niedostępny w projekcie';

  @override
  String get tasksAutomationsUnknownLabel => 'Nieaktywna etykieta';

  @override
  String get tasksAutomationsNoCondition => 'Bez warunku statusu';

  @override
  String get tasksAutomationsTrigger => 'Gdy nastąpi';

  @override
  String get tasksAutomationsAction => 'Wykonaj';

  @override
  String get tasksAutomationsDueWithinDays => 'Horyzont terminu (dni)';

  @override
  String get tasksAutomationsDaysHint => 'Od 0 do 365 dni';

  @override
  String get tasksAutomationsSubtaskTitle => 'Tytuł podzadania';

  @override
  String get tasksAutomationsActionSetStatus => 'Ustaw status zadania';

  @override
  String get tasksAutomationsActionSetPriority => 'Ustaw priorytet zadania';

  @override
  String get tasksAutomationsActionClearDueDate => 'Wyczyść termin zadania';

  @override
  String get tasksAutomationsActionSetDueDate =>
      'Ustaw lub wyczyść termin zadania';

  @override
  String get tasksAutomationsDueDateUnset => 'Brak terminu (wyczyść)';

  @override
  String get tasksAutomationsClearDueDate => 'Wyczyść wybrany termin';

  @override
  String get tasksAutomationsActionCreateSubtask => 'Utwórz podzadanie';

  @override
  String get tasksAutomationsActionAssignTask => 'Przypisz wykonawcę';

  @override
  String get tasksAutomationsActionAddLabel => 'Dodaj etykietę';

  @override
  String get tasksAutomationsActionRemoveLabel => 'Usuń etykietę';

  @override
  String get tasksAutomationsActionAssignee => 'Wykonawca docelowy';

  @override
  String get tasksAutomationsActionLabel => 'Etykieta docelowa';

  @override
  String get tasksAutomationsActionNotifyUser => 'Wyślij powiadomienie';

  @override
  String get tasksAutomationsNotificationRecipient => 'Odbiorca powiadomienia';

  @override
  String get tasksAutomationsNotificationText => 'Treść powiadomienia';

  @override
  String get tasksAutomationsBuilderInvalid =>
      'Uzupełnij nazwę i poprawne parametry automatyzacji.';

  @override
  String get taskDetailsNoDueDate => 'Brak terminu';

  @override
  String get taskDetailsNoDate => 'Nie ustawiono daty';

  @override
  String get taskDetailsEstimate => 'Estymacja';

  @override
  String get taskDetailsNoEstimate => 'Brak estymacji';

  @override
  String taskDetailsMinutes(int count) {
    return '$count min';
  }

  @override
  String get taskDetailsDescription => 'Opis';

  @override
  String get taskDetailsEditDescription => 'Edytuj opis';

  @override
  String get tasksCollapseColumn => 'Zwiń kolumnę';

  @override
  String get taskDetailsNoDescription => 'To zadanie nie ma jeszcze opisu.';

  @override
  String get taskDetailsChecklist => 'Checklista';

  @override
  String get taskDetailsAddChecklistItem => 'Dodaj element checklisty';

  @override
  String get taskDetailsDeleteChecklistItem => 'Usuń element checklisty';

  @override
  String get taskDetailsEditChecklistItem => 'Edytuj element checklisty';

  @override
  String get taskDetailsAcceptanceCriteria => 'Kryteria akceptacji';

  @override
  String get taskDetailsAddAcceptanceCriterion => 'Dodaj kryterium akceptacji';

  @override
  String get taskDetailsDeleteAcceptanceCriterion =>
      'Usuń kryterium akceptacji';

  @override
  String get taskDetailsEditAcceptanceCriterion =>
      'Edytuj kryterium akceptacji';

  @override
  String get taskDetailsSubtasks => 'Podzadania';

  @override
  String get taskDetailsAddSubtask => 'Dodaj podzadanie';

  @override
  String get taskDetailsNoSubtasks => 'Nie ma jeszcze podzadań.';

  @override
  String get taskDetailsDependencies => 'Zależności';

  @override
  String get taskDetailsAddDependency => 'Dodaj zależność';

  @override
  String get taskDetailsDeleteDependency => 'Usuń zależność';

  @override
  String get taskDetailsNoDependencies =>
      'To zadanie nie ma jeszcze zależności.';

  @override
  String get taskDetailsSearchTask => 'Wyszukaj zadanie';

  @override
  String get taskDetailsDependencyType => 'Typ zależności';

  @override
  String get taskDetailsDependencyKind => 'Relacja harmonogramu';

  @override
  String get taskDetailsDependencyLagDays => 'Lag (dni robocze)';

  @override
  String get taskDependencyKindFinishToStart => 'Koniec → początek';

  @override
  String get taskDependencyKindStartToStart => 'Początek → początek';

  @override
  String get taskDependencyKindFinishToFinish => 'Koniec → koniec';

  @override
  String get taskDependencyKindStartToFinish => 'Początek → koniec';

  @override
  String get taskDependencyBlocks => 'Blokuje';

  @override
  String get taskDependencyRelated => 'Powiązane';

  @override
  String get taskDependencyDuplicate => 'Duplikat';

  @override
  String get taskDetailsEditBasics => 'Edytuj zadanie';

  @override
  String get taskDetailsTitleField => 'Tytuł';

  @override
  String get taskDetailsStatusField => 'Status';

  @override
  String get taskDetailsPriorityField => 'Priorytet';

  @override
  String get taskDetailsEditPlanning => 'Edytuj terminy i estymację';

  @override
  String get taskDetailsStartDate => 'Data rozpoczęcia';

  @override
  String get taskDetailsEstimateMinutes => 'Estymacja w minutach';

  @override
  String get taskDetailsClearDate => 'Wyczyść datę';

  @override
  String get taskDetailsInvalidEstimate =>
      'Estymacja musi być dodatnią liczbą minut.';

  @override
  String get taskDetailsInvalidDependencyLag =>
      'Lag musi mieścić się w zakresie od -365 do 365 dni.';

  @override
  String get taskDetailsInvalidDateRange =>
      'Termin zakończenia nie może być wcześniejszy niż rozpoczęcie.';

  @override
  String get taskStatusBacklog => 'Backlog';

  @override
  String get taskStatusTodo => 'Do zrobienia';

  @override
  String get taskStatusInProgress => 'W toku';

  @override
  String get taskStatusBlocked => 'Zablokowane';

  @override
  String get taskStatusDone => 'Gotowe';

  @override
  String get taskStatusCanceled => 'Anulowane';

  @override
  String get myTasksFilter => 'Filtruj zadania';

  @override
  String get myTasksFiltersTitle => 'Filtry zadań';

  @override
  String get myTasksFiltersSubtitle =>
      'Dostosuj kryteria filtrowania zadań osobistych.';

  @override
  String get projectUserHubPinnedSuccess => 'Projekt przypięty do ulubionych.';

  @override
  String get projectUserHubUnpinnedSuccess => 'Projekt odpięty z ulubionych.';

  @override
  String get projectUserHubHiddenSuccess => 'Projekt ukryty z bocznego menu.';

  @override
  String get projectUserHubUnhiddenSuccess =>
      'Projekt przywrócony do bocznego menu.';

  @override
  String get myTasksStatus => 'Status';

  @override
  String get myTasksPriority => 'Priorytet';

  @override
  String get myTasksInvolvement => 'Mój udział';

  @override
  String get myTasksAll => 'Wszystkie';

  @override
  String get myTasksAny => 'Dowolny';

  @override
  String get myTasksDueFrom => 'Termin od';

  @override
  String get myTasksDueTo => 'Termin do';

  @override
  String get myTasksAnyDueDate => 'Dowolny termin';

  @override
  String get myTasksClear => 'Wyczyść';

  @override
  String get myTasksChooseDate => 'Wybierz datę';

  @override
  String get myTasksApply => 'Zastosuj';

  @override
  String get myTasksInvalidDueRange =>
      'Data końcowa nie może być wcześniejsza od początkowej.';

  @override
  String get myTasksEmpty => 'Nie masz obecnie zadań wymagających działania.';

  @override
  String get myTasksRetry => 'Spróbuj ponownie';

  @override
  String get myTasksPriorityLow => 'Niski';

  @override
  String get myTasksPriorityNormal => 'Normalny';

  @override
  String get myTasksPriorityHigh => 'Wysoki';

  @override
  String get myTasksPriorityCritical => 'Krytyczny';

  @override
  String get myTasksInvolvementAny => 'Dowolny';

  @override
  String get myTasksInvolvementPrimaryAssignee => 'Główny wykonawca';

  @override
  String get myTasksInvolvementCollaborator => 'Współpracownik';

  @override
  String get myTasksInvolvementAssignee => 'Wykonawca';

  @override
  String get myTasksInvolvementWatcher => 'Obserwator';

  @override
  String get settingsSectionProfileTitle => 'Profil';

  @override
  String get settingsSectionProfileSubtitle => 'Zdjęcie i dane konta';

  @override
  String get settingsProfileTitle => 'Zdjęcie profilowe';

  @override
  String get settingsProfileSubtitle =>
      'Zdjęcie będzie widoczne w Workspaces i przy Twoich zadaniach.';

  @override
  String get settingsProfileChooseAvatar => 'Wybierz zdjęcie';

  @override
  String get settingsProfileRemoveAvatar => 'Usuń zdjęcie';

  @override
  String get settingsProfileAvatarHint =>
      'PNG, JPEG, WebP lub GIF. Wybierz czytelne, kwadratowe zdjęcie.';

  @override
  String get settingsProfileUploadInProgress => 'Zapisywanie zdjęcia…';

  @override
  String get settingsProfileRetry => 'Spróbuj ponownie';

  @override
  String get settingsProfileAvatarTooLarge =>
      'Wybrane zdjęcie jest większe niż 5 MB.';

  @override
  String get tasksScheduleTitle => 'Harmonogram projektu';

  @override
  String get tasksScheduleDescription =>
      'Ustal sposób automatycznego przesuwania terminów i dni wolne dla całego workspace’u.';

  @override
  String get tasksScheduleMode => 'Tryb harmonogramu';

  @override
  String get tasksScheduleManual => 'Ręczny';

  @override
  String get tasksSchedulePushSuccessors => 'Przesuwaj tylko kolejne zadania';

  @override
  String get tasksScheduleStrictCascade => 'Ścisła kaskada';

  @override
  String get tasksScheduleHolidays => 'Dni wolne';

  @override
  String get tasksScheduleNoHolidays => 'Brak zdefiniowanych dni wolnych.';

  @override
  String get tasksScheduleAddHoliday => 'Dodaj dzień wolny';

  @override
  String get tasksScheduleHolidayName => 'Nazwa dnia wolnego';

  @override
  String get tasksScheduleChooseHolidayDate => 'Wybierz datę';

  @override
  String get tasksSavedViews => 'Zapisane widoki';

  @override
  String get tasksSavedViewsCreate => 'Utwórz widok';

  @override
  String get tasksSavedViewsManage => 'Zarządzaj widokiem';

  @override
  String get tasksSavedViewsRename => 'Zmień nazwę';

  @override
  String get tasksSavedViewsDelete => 'Usuń widok';

  @override
  String tasksSavedViewsDeleteDescription(Object name) {
    return 'Czy na pewno chcesz usunąć widok „$name”?';
  }

  @override
  String get tasksSavedViewsName => 'Nazwa widoku';

  @override
  String get tasksSavedViewsLayout => 'Układ';

  @override
  String get tasksSavedViewsSort => 'Sortowanie';

  @override
  String get tasksSavedViewsAscending => 'Rosnąco';

  @override
  String get tasksSavedViewsDescending => 'Malejąco';

  @override
  String get tasksSavedViewsGroup => 'Grupowanie';

  @override
  String get tasksSavedViewsFilters => 'Filtry';

  @override
  String get tasksSavedViewsSearch => 'Szukaj w tytule i opisie';

  @override
  String get tasksSavedViewsPinnedOnly => 'Tylko przypięte zadania';

  @override
  String get tasksSavedViewsIncludeArchived => 'Uwzględnij zarchiwizowane';

  @override
  String get tasksSavedViewsStatuses => 'Statusy';

  @override
  String get tasksSavedViewsPriorities => 'Priorytety';

  @override
  String get tasksSavedViewsColumns => 'Widoczne kolumny';

  @override
  String get tasksSavedViewsSortPosition => 'Pozycja na tablicy';

  @override
  String get tasksSavedViewsSortUpdated => 'Ostatnia aktualizacja';

  @override
  String get tasksSavedViewsSortDueDate => 'Termin';

  @override
  String get tasksSavedViewsSortPriority => 'Priorytet';

  @override
  String get tasksSavedViewsSortTitle => 'Tytuł';

  @override
  String get tasksSavedViewsGroupNone => 'Bez grupowania';

  @override
  String get tasksSavedViewsGroupStatus => 'Według statusu';

  @override
  String get tasksListGroupProjectWorkflow => 'Workflow projektu';

  @override
  String get tasksSavedViewsGroupPriority => 'Według priorytetu';

  @override
  String get tasksSavedViewsGroupAssignee => 'Według wykonawcy';

  @override
  String get tasksSavedViewsColumnKey => 'Klucz';

  @override
  String get tasksSavedViewsColumnTitle => 'Tytuł';

  @override
  String get tasksSavedViewsColumnStatus => 'Status';

  @override
  String get tasksSavedViewsColumnPriority => 'Priorytet';

  @override
  String get tasksSavedViewsColumnAssignees => 'Wykonawcy';

  @override
  String get tasksSavedViewsColumnStartDate => 'Data rozpoczęcia';

  @override
  String get tasksSavedViewsColumnDueDate => 'Termin';

  @override
  String get tasksSavedViewsColumnChecklist => 'Postęp checklisty';

  @override
  String get tasksSavedViewsColumnUpdated => 'Ostatnia aktualizacja';

  @override
  String get tasksSavedViewsUnassigned => 'Nieprzypisane';

  @override
  String get tasksSavedViewsAssigned => 'Przypisane zadania';

  @override
  String get tasksSavedViewsDefault => 'Widok domyślny';

  @override
  String get tasksSavedViewsSaveCurrent => 'Zapisz bieżący widok';

  @override
  String get tasksSavedViewsSaveActiveChanges => 'Zapisz bieżące zmiany';

  @override
  String get tasksSavedViewsModified => 'Zmieniono';

  @override
  String get tasksSavedViewsListLoading => 'Lista zadań jeszcze się ładuje';

  @override
  String get tasksCapacityTitle => 'Dostępność zespołu';

  @override
  String get tasksCapacityDescription =>
      'Ustaw domyślną dzienną dostępność workspace’u i okresowe wyjątki dla osób w tym projekcie.';

  @override
  String get tasksCapacityDefaultDaily => 'Domyślna dzienna dostępność';

  @override
  String get tasksCapacityMinutes => 'min';

  @override
  String get tasksCapacityOverrides => 'Wyjątki dostępności';

  @override
  String get tasksCapacityAddOverride => 'Dodaj wyjątek';

  @override
  String get tasksCapacityNoOverrides => 'Nie ma jeszcze wyjątków dostępności.';

  @override
  String get tasksCapacityUnknownMember => 'Niedostępny członek projektu';

  @override
  String get tasksCapacityMember => 'Członek projektu';

  @override
  String get tasksCapacityStartDate => 'Data początkowa';

  @override
  String get tasksCapacityEndDate => 'Data końcowa';

  @override
  String get tasksCapacityReason => 'Powód (opcjonalnie)';

  @override
  String get tasksViewWorkload => 'Obciążenie';

  @override
  String get tasksWorkloadTitle => 'Obciążenie zespołu';

  @override
  String get tasksWorkloadRange => 'Zakres dat';

  @override
  String get tasksWorkloadTasks => 'zadań';

  @override
  String get tasksWorkloadAvailable => 'Dostępne';

  @override
  String get tasksWorkloadRemaining => 'Pozostało';

  @override
  String get tasksWorkloadOverCapacity => 'Przeciążenie';

  @override
  String get tasksWorkloadEmpty =>
      'Brak danych o obciążeniu dla wybranego zakresu.';

  @override
  String get tasksViewTimeline => 'Timeline';

  @override
  String get tasksTimelineTitle => 'Harmonogram projektu';

  @override
  String get tasksTimelineRange => 'Zakres harmonogramu';

  @override
  String get tasksTimelineUndated => 'Bez terminu';

  @override
  String get tasksTimelineDependencies => 'zależności';

  @override
  String get taskDetailsCascadePreview => 'Podgląd kaskady';

  @override
  String get taskDetailsCascadePreviewDescription =>
      'Sprawdź, które zadania i terminy zmienią się przed zapisem.';

  @override
  String get taskDetailsCascadeChanges => 'Zmiany harmonogramu';

  @override
  String get taskDetailsCascadeNoChanges =>
      'Zmiana terminu nie przesuwa innych zadań.';

  @override
  String get taskDetailsCascadeApply => 'Zastosuj kaskadę';

  @override
  String get taskDetailsCascadeCritical => 'Ścieżka krytyczna';

  @override
  String get taskDetailsCascadePreviewFailed =>
      'Nie udało się przygotować podglądu kaskady.';

  @override
  String get taskDetailsCascadeApplyFailed =>
      'Nie udało się zastosować kaskady. Odśwież dane i spróbuj ponownie.';

  @override
  String get taskDetailsCascadeDatesRequired =>
      'Aby wyświetlić podgląd kaskady, ustaw datę rozpoczęcia i termin wykonania.';

  @override
  String get tasksRecurrenceTitle => 'Zadania cykliczne';

  @override
  String get tasksRecurrenceDescription =>
      'Zarządzanie harmonogramem powtarzania i audyt cykli w projekcie';

  @override
  String get tasksRecurrenceTabSchedule => 'Harmonogram';

  @override
  String get tasksRecurrenceTabRuns => 'Historia wykonań';

  @override
  String get tasksRecurrenceActive => 'Aktywna';

  @override
  String get tasksRecurrencePaused => 'Wstrzymana';

  @override
  String get tasksRecurrenceEmptyTitle =>
      'Brak zadań cyklicznych w tym projekcie';

  @override
  String get tasksRecurrenceEmptyDescription =>
      'Aby skonfigurować cykliczność, otwórz zadanie i kliknij ikonę powtarzania 🔄.';

  @override
  String get tasksRecurrenceRunsEmptyTitle => 'Brak historii wykonań';

  @override
  String get tasksRecurrenceRunsEmptyDescription =>
      'W tym miejscu pojawi się audyt zrealizowanych i pominiętych cykli zadań.';

  @override
  String get tasksRecurrenceRunNow => 'Uruchom cykl natychmiast';

  @override
  String get tasksRecurrenceRunNowSuccess =>
      'Wygenerowano nowe wystąpienie zadania';

  @override
  String get tasksRecurrenceEdit => 'Edytuj ustawienia cyklu';

  @override
  String get tasksRecurrenceNext => 'Następne';

  @override
  String get tasksRecurrenceModeScheduled => 'Według harmonogramu';

  @override
  String get tasksRecurrenceModeAfterCompletion => 'Po ukończeniu';

  @override
  String get tasksRecurrenceOutcomeCreated => 'Utworzono wystąpienie';

  @override
  String get tasksRecurrenceOutcomeSkipped =>
      'Pominięto (poprzednie zadanie było otwarte)';

  @override
  String get tasksRecurrenceFilterOnly => 'Cykliczne';

  @override
  String get tasksRecurrenceDelete => 'Usuń cykliczność';

  @override
  String get tasksRecurrenceDeleteConfirm =>
      'Czy na pewno chcesz usunąć regułę powtarzania dla tego zadania?';

  @override
  String get tasksRecurrenceDeleteSuccess =>
      'Pomyślnie usunięto cykliczność zadania';

  @override
  String get taskRecurrenceIntervalDaily => 'Codziennie';

  @override
  String taskRecurrenceIntervalDays(int interval) {
    return 'Co $interval dni';
  }

  @override
  String get taskRecurrenceIntervalWeekly => 'Co tydzień';

  @override
  String taskRecurrenceIntervalWeeks(int interval) {
    return 'Co $interval tyg.';
  }

  @override
  String get taskRecurrenceIntervalMonthly => 'Co miesiąc';

  @override
  String taskRecurrenceIntervalMonths(int interval) {
    return 'Co $interval mies.';
  }

  @override
  String get taskRecurrenceHeader => 'Powtarzanie zadania';

  @override
  String get taskRecurrenceFrequencyLabel => 'Częstotliwość powtórzeń';

  @override
  String get taskRecurrencePresetWorkdays => 'W dni robocze';

  @override
  String get taskRecurrencePresetCustom => 'Własne...';

  @override
  String get taskRecurrenceRepeatEvery => 'Powtarzaj co:';

  @override
  String get taskRecurrenceUnitDays => 'Dni';

  @override
  String get taskRecurrenceUnitWeeks => 'Tygodnie';

  @override
  String get taskRecurrenceUnitMonths => 'Miesiące';

  @override
  String get taskRecurrenceScheduleLabel => 'Termin wykonania cyklu';

  @override
  String get taskRecurrenceModeLabel => 'Tryb powtarzania';

  @override
  String get taskRecurrenceOccurrenceStatus =>
      'Początkowy status nowego zadania';

  @override
  String get taskRecurrenceSkipIfPreviousOpen =>
      'Pomiń utworzenie, jeśli poprzednie zadanie jest nadal otwarte';

  @override
  String get taskRecurrenceSave => 'Zapisz harmonogram';

  @override
  String get taskRecurrenceSaving => 'Zapisywanie...';

  @override
  String get taskRecurrencePauseSeries => 'Wstrzymaj serię';

  @override
  String get taskRecurrenceResumeSeries => 'Wznów serię';

  @override
  String get taskRecurrenceSaveSuccess => 'Zapisano harmonogram powtarzania';

  @override
  String get tasksListEditTitleTooltip => 'Edytuj tytuł zadania';

  @override
  String get tasksListPinTooltip => 'Przypnij zadanie';

  @override
  String get tasksListUnpinTooltip => 'Odepnij zadanie';

  @override
  String get tasksListWatchTooltip => 'Obserwuj zadanie';

  @override
  String get tasksListUnwatchTooltip => 'Przestań obserwować zadanie';

  @override
  String get tasksListMoreOptionsTooltip => 'Więcej opcji';

  @override
  String get tasksListKeyCopiedTooltip => 'Skopiowano klucz zadania do schowka';

  @override
  String tasksListAddInGroupTooltip(String group) {
    return 'Dodaj zadanie w grupie: $group';
  }

  @override
  String get tasksListQuickCreateTitle => 'Nowe zadanie';

  @override
  String get tasksListQuickCreateHint => 'Wpisz tytuł nowego zadania...';

  @override
  String get tasksListQuickCreateButton => 'Utwórz';

  @override
  String get tasksListQuickCreateCancel => 'Anuluj';

  @override
  String get tasksListCreateTitleRequired => 'Tytuł zadania jest wymagany.';

  @override
  String get tasksListCreateForbidden =>
      'Nie masz uprawnień do utworzenia zadania.';

  @override
  String get tasksListCreateConflict =>
      'Wystąpił konflikt danych. Odśwież listę i spróbuj ponownie.';

  @override
  String get tasksListCreateValidation => 'Dane zadania są nieprawidłowe.';

  @override
  String get tasksListCreateDuplicate => 'Tworzenie zadania jest już w toku.';

  @override
  String get tasksListCreateUnavailable =>
      'Lista zadań nie jest jeszcze gotowa.';

  @override
  String get tasksListRecurrenceSeriesBadge => 'Seria';

  @override
  String get tasksListRecurrenceCycleBadge => 'Cykl';

  @override
  String get tasksListInlineCreateKeyboardHint =>
      'Naciśnij Enter aby zapisać, Esc aby anulować';

  @override
  String get tasksListInlineCreateHint => 'Nazwa zadania';

  @override
  String get tasksListInlineCreateButton => 'Dodaj zadanie';

  @override
  String get tasksListExpandGroupTooltip => 'Rozwiń grupę';

  @override
  String get tasksListCollapseGroupTooltip => 'Zwiń grupę';

  @override
  String get tasksListClearDateButton => 'Wyczyść';

  @override
  String get tasksListCancelButton => 'Anuluj';

  @override
  String get tasksListSaveButton => 'Zapisz';

  @override
  String get tasksListChecklistTitle => 'Checklista';

  @override
  String get tasksListChecklistEmpty => 'Brak pozycji checklisty';

  @override
  String get tasksListChecklistAddItem => 'Dodaj pozycję';

  @override
  String get tasksListChecklistNewItemHint => 'Wpisz nową pozycję...';

  @override
  String get tasksListChecklistAddAction => 'Dodaj checklistę';

  @override
  String get tasksListDatePresetToday => 'Dzisiaj';

  @override
  String get tasksListDatePresetTomorrow => 'Jutro';

  @override
  String get tasksListDatePresetNextWeek => 'Za tydzień';

  @override
  String get tasksListDatePresetNextMonth => 'Za miesiąc';

  @override
  String get tasksListCustomStatusLabel => 'Status własny';

  @override
  String get tasksListCustomStatusNone => 'Brak własnego statusu';

  @override
  String get tasksListLabelsSearchHint => 'Szukaj etykiet...';

  @override
  String get tasksListLabelsEmpty => 'Brak etykiet';

  @override
  String get projectSettingsTitle => 'Ustawienia projektu';

  @override
  String get projectSettingsTabGeneral => 'Ogólne';

  @override
  String get projectSettingsTabMembers => 'Członkowie i dostęp';

  @override
  String get projectSettingsTabWorkflow => 'Statusy i Workflow';

  @override
  String get projectSettingsTabCustomFields => 'Pola niestandardowe';

  @override
  String get projectSettingsTabLabels => 'Etykiety';

  @override
  String get projectSettingsTabMilestones => 'Kamienie milowe';

  @override
  String get projectSettingsTabAutomations => 'Automatyzacje';

  @override
  String get projectSettingsNameLabel => 'Nazwa projektu';

  @override
  String get projectSettingsNameHint => 'Wpisz nazwę projektu...';

  @override
  String get projectSettingsDescriptionLabel => 'Opis projektu';

  @override
  String get projectSettingsDescriptionHint =>
      'Wpisz opcjonalny opis projektu...';

  @override
  String get projectSettingsIconAndColorLabel => 'Ikona i kolor przewodni';

  @override
  String get projectSettingsVisibilityLabel => 'Widoczność projektu';

  @override
  String get projectSettingsVisibilityShared => 'Współdzielony (Shared)';

  @override
  String get projectSettingsVisibilitySharedDesc =>
      'Widoczny dla wszystkich członków przestrzeni roboczej.';

  @override
  String get projectSettingsVisibilityPrivate => 'Prywatny (Private)';

  @override
  String get projectSettingsVisibilityPrivateDesc =>
      'Dostępny wyłącznie dla osób jawnie dodanych do projektu.';

  @override
  String get projectSettingsSaveGeneral => 'Zapisz zmiany';

  @override
  String get projectSettingsGeneralSavedSuccess =>
      'Pomyślnie zaktualizowano dane projektu.';

  @override
  String get projectSettingsDangerZoneTitle => 'Strefa niebezpieczna';

  @override
  String get projectSettingsArchiveProject => 'Zarchiwizuj projekt';

  @override
  String get projectSettingsArchiveProjectConfirm =>
      'Czy na pewno chcesz zarchiwizować ten projekt? Zadania i zasoby pozostaną zachowane w historii.';

  @override
  String get projectSettingsRestoreProject => 'Przywróć projekt';

  @override
  String get projectSettingsDeleteProject => 'Usuń projekt trwale';

  @override
  String get projectSettingsDeleteProjectConfirm =>
      'Czy na pewno chcesz trwale usunąć ten zarchiwizowany projekt? Tej operacji nie można cofnąć.';

  @override
  String get projectSettingsMembersSearchHint => 'Filtruj członków projektu...';

  @override
  String get projectSettingsAddMemberButton => 'Dodaj członka';

  @override
  String get projectSettingsAddMemberDialogTitle => 'Dodaj członka do projektu';

  @override
  String get projectSettingsSelectWorkspaceUser =>
      'Wybierz użytkownika z przestrzeni roboczej';

  @override
  String get projectSettingsSelectRole => 'Wybierz rolę w projekcie';

  @override
  String get projectSettingsMemberRoleOwner => 'Właściciel (Owner)';

  @override
  String get projectSettingsMemberRoleAdmin => 'Administrator (Admin)';

  @override
  String get projectSettingsMemberRoleMember => 'Członek (Member)';

  @override
  String get projectSettingsMemberRoleObserver => 'Obserwator (Observer)';

  @override
  String get projectSettingsRemoveMemberConfirm =>
      'Czy na pewno chcesz usunąć tego użytkownika z projektu?';

  @override
  String get projectSettingsNoMembersFound =>
      'Nie znaleziono członków projektu';

  @override
  String get projectSettingsWorkflowColumnsHeader =>
      'Kolumny tablicy i statusy zadań';

  @override
  String get projectSettingsWorkflowAddStatus => 'Dodaj status';

  @override
  String get projectSettingsWorkflowEditStatus => 'Edytuj status';

  @override
  String get projectSettingsWorkflowDeleteStatus => 'Usuń status';

  @override
  String get projectSettingsWorkflowStatusName => 'Nazwa statusu';

  @override
  String get projectSettingsWorkflowStatusColor => 'Kolor';

  @override
  String get projectSettingsWorkflowStatusCategory => 'Kategoria analityczna';

  @override
  String get projectSettingsWorkflowWipLimit => 'Limit zadań (WIP)';

  @override
  String get projectSettingsWorkflowWipLimitHint => '0 = brak limitu';

  @override
  String get projectSettingsWorkflowTemplatesButton =>
      'Gotowe szablony workflow';

  @override
  String get projectSettingsWorkflowApplyTemplateConfirm =>
      'Zastosowanie szablonu utworzy nowe kolumny workflow. Czy chcesz kontynuować?';

  @override
  String get projectSettingsWorkflowEmptyTitle =>
      'Brak zdefiniowanych kolumn tablicy';

  @override
  String get projectSettingsWorkflowEmptyDesc =>
      'Projekt korzysta ze standardowych statusów systemowych lub nie posiada jeszcze własnych kolumn workflow. Zdefiniuj własne etapy pracy lub wybierz sprawdzony szablon workflow.';

  @override
  String get projectSettingsCustomFieldsHeader =>
      'Definicje pól niestandardowych';

  @override
  String get projectSettingsAddCustomField => 'Dodaj pole';

  @override
  String get projectSettingsCustomFieldName => 'Nazwa pola';

  @override
  String get projectSettingsCustomFieldType => 'Typ pola';

  @override
  String get projectSettingsCustomFieldRequired => 'Pole wymagane';

  @override
  String get projectSettingsCustomFieldOptions =>
      'Opcje wyboru (rozdzielone przecinkiem)';

  @override
  String get projectSettingsCustomFieldsEmpty =>
      'Brak zdefiniowanych pól niestandardowych';

  @override
  String get projectSettingsLabelsHeader => 'Etykiety projektu';

  @override
  String get projectSettingsAddLabel => 'Dodaj etykietę';

  @override
  String get projectSettingsLabelName => 'Nazwa etykiety';

  @override
  String get projectSettingsLabelColor => 'Kolor etykiety';

  @override
  String get projectSettingsLabelsEmpty => 'Brak utworzonych etykiet';

  @override
  String get projectSettingsMilestonesHeader =>
      'Kamienie milowe (Etapy projektu)';

  @override
  String get projectSettingsAddMilestone => 'Nowy kamień milowy';

  @override
  String get projectSettingsMilestoneName => 'Nazwa kamienia milowego';

  @override
  String get projectSettingsMilestoneDueDate => 'Termin docelowy';

  @override
  String get projectSettingsMilestoneProgress => 'Postęp';

  @override
  String get projectSettingsMilestonesEmpty =>
      'Brak zdefiniowanych kamieni milowych';

  @override
  String get projectSettingsAutomationsHeader => 'Reguły automatyzacji zadań';

  @override
  String get projectSettingsAddAutomation => 'Nowa automatyzacja';

  @override
  String get projectSettingsAutomationTrigger => 'Wyzwalacz (Kiedy)';

  @override
  String get projectSettingsAutomationAction => 'Akcja (Wtedy)';

  @override
  String get projectSettingsAutomationsEmpty =>
      'Brak skonfigurowanych automatyzacji';

  @override
  String get projectSettingsReadOnlyNotice =>
      'Posiadasz uprawnienia tylko do odczytu (Member/Observer). Edycja ustawień projektu jest zablokowana.';

  @override
  String get workspaceSettingsTitle => 'Ustawienia przestrzeni roboczej';

  @override
  String get workspaceSettingsTabGeneral => 'Ogólne';

  @override
  String get workspaceSettingsTabMembers => 'Członkowie i zaproszenia';

  @override
  String get workspaceSettingsTabNotifications => 'Powiadomienia';

  @override
  String get workspaceSettingsTabCapacity => 'Czas pracy i obciążenie';

  @override
  String get workspaceSettingsNameLabel => 'Nazwa przestrzeni roboczej';

  @override
  String get workspaceSettingsNameHint => 'Wpisz nazwę przestrzeni...';

  @override
  String get workspaceSettingsDescriptionLabel => 'Opis przestrzeni';

  @override
  String get workspaceSettingsDescriptionHint =>
      'Wpisz opcjonalny opis przestrzeni...';

  @override
  String get workspaceSettingsSaveGeneral => 'Zapisz dane przestrzeni';

  @override
  String get workspaceSettingsSavedSuccess =>
      'Pomyślnie zaktualizowano dane przestrzeni roboczej.';

  @override
  String get workspaceSettingsArchiveWorkspace =>
      'Zarchiwizuj przestrzeń roboczą';

  @override
  String get workspaceSettingsArchiveConfirm =>
      'Czy na pewno chcesz zarchiwizować tę przestrzeń roboczą? Zostanie ona ukryta na liście aktywnych.';

  @override
  String get workspaceSettingsRestoreWorkspace => 'Przywróć przestrzeń';

  @override
  String get workspaceSettingsMembersHeader => 'Aktywni członkowie';

  @override
  String get workspaceSettingsInviteUserButton => 'Zaproś użytkownika';

  @override
  String get workspaceSettingsInviteDialogTitle =>
      'Zaproś lokalnego użytkownika do przestrzeni';

  @override
  String get workspaceSettingsSearchReadyHint =>
      'Wpisz imię, nazwisko, login lub e-mail lokalnego użytkownika...';

  @override
  String get workspaceSettingsSearchReadyMinChars =>
      'Wpisz co najmniej 2 znaki, aby wyszukać w lokalnym katalogu.';

  @override
  String get workspaceSettingsInvitationsSentHeader => 'Oczekujące zaproszenia';

  @override
  String get workspaceSettingsInvitationResend => 'Wyślij ponownie';

  @override
  String get workspaceSettingsInvitationCancel => 'Anuluj';

  @override
  String get workspaceSettingsMemberRoleOwner => 'Właściciel (Owner)';

  @override
  String get workspaceSettingsMemberRoleAdmin => 'Administrator (Admin)';

  @override
  String get workspaceSettingsMemberRoleMember => 'Członek (Member)';

  @override
  String get workspaceSettingsMemberRoleObserver => 'Obserwator (Observer)';

  @override
  String get workspaceSettingsRemoveMemberConfirm =>
      'Czy na pewno chcesz usunąć tego członka z przestrzeni roboczej?';

  @override
  String get workspaceSettingsNotificationsChannels => 'Kanały powiadomień';

  @override
  String get workspaceSettingsNotificationsInApp =>
      'Powiadomienia w aplikacji (In-App)';

  @override
  String get workspaceSettingsNotificationsEmail => 'Powiadomienia E-mail';

  @override
  String get workspaceSettingsNotificationsCategories =>
      'Kategorie powiadomień';

  @override
  String get workspaceSettingsCategoryTasks => 'Zadania i przypisania';

  @override
  String get workspaceSettingsCategoryProjects => 'Wydarzenia w projektach';

  @override
  String get workspaceSettingsCategoryWorkspace =>
      'Zarządzanie przestrzenią i zaproszenia';

  @override
  String get workspaceSettingsCategoryMentions =>
      'Wzmianki w czacie i komentarze';

  @override
  String get workspaceSettingsSaveNotifications =>
      'Zapisz preferencje powiadomień';

  @override
  String get workspaceSettingsNotificationsSaved =>
      'Pomyślnie zaktualizowano preferencje powiadomień.';

  @override
  String get workspaceSettingsReadOnlyNotice =>
      'Posiadasz uprawnienia tylko do odczytu. Edycja ustawień administracyjnych jest zablokowana.';

  @override
  String get projectSettingsTabTemplates => 'Szablony Projektu';

  @override
  String get projectSettingsTemplatesHeader => 'Szablony projektów';

  @override
  String get projectSettingsCreateTemplateFromProject =>
      'Zapisz projekt jako szablon';

  @override
  String get projectSettingsCreateTemplateDialogTitle =>
      'Nowy szablon z projektu';

  @override
  String get projectSettingsTemplateNameLabel => 'Nazwa szablonu *';

  @override
  String get projectSettingsTemplateDescLabel => 'Opis szablonu (opcjonalnie)';

  @override
  String get projectSettingsTemplatesEmpty =>
      'Brak zapisanych szablonów w tej przestrzeni.';

  @override
  String get projectSettingsTemplateApplyButton => 'Utwórz projekt z szablonu';

  @override
  String get projectSettingsTemplateApplyDialogTitle =>
      'Utwórz nowy projekt z szablonu';

  @override
  String get projectSettingsTemplateApplyNewProjectName =>
      'Nazwa nowego projektu *';

  @override
  String get projectSettingsTemplateDeleteConfirm =>
      'Czy na pewno chcesz usunąć ten szablon projektu?';

  @override
  String get projectSettingsTemplateRefreshButton =>
      'Odśwież szablon z projektu';

  @override
  String get projectSettingsTemplateRefreshConfirm =>
      'Czy na pewno chcesz zaktualizować zawartość szablonu bieżącym stanem tego projektu?';

  @override
  String get projectSettingsTemplateApplySuccess =>
      'Pomyślnie utworzono nowy projekt z szablonu.';

  @override
  String get projectSettingsTemplateCreatedSuccess =>
      'Pomyślnie utworzono szablon z projektu.';

  @override
  String get projectSettingsTemplateRefreshedSuccess =>
      'Pomyślnie odświeżono szablon z projektu.';

  @override
  String get projectSettingsTemplateDeletedSuccess =>
      'Pomyślnie usunięto szablon projektu.';

  @override
  String get projectSettingsTemplateLeaveDeleteTitle => 'Usuń szablon projektu';

  @override
  String get projectSettingsTemplateLeaveDeleteAction => 'Usuń szablon';

  @override
  String get projectSettingsTemplateDetailsTitle =>
      'Szczegóły szablonu projektu';

  @override
  String get projectSettingsTemplateDetailsWorkflow => 'Statusy workflow';

  @override
  String get projectSettingsTemplateDetailsCustomFields =>
      'Pola niestandardowe';

  @override
  String get projectSettingsTemplateDetailsLabels => 'Etykiety';

  @override
  String projectSettingsTemplateDetailsTasks(int count) {
    return 'Zadania startowe ($count)';
  }

  @override
  String get projectSettingsTemplateDetailsNoTasks =>
      'Brak zdefiniowanych zadań startowych.';

  @override
  String get projectSettingsTemplateDetailsNoFields =>
      'Brak zdefiniowanych pól niestandardowych.';

  @override
  String get projectSettingsTemplateDetailsNoLabels =>
      'Brak zdefiniowanych etykiet.';

  @override
  String get projectSettingsTemplateDetailsPreviewButton =>
      'Podgląd szczegółów';

  @override
  String get projectSettingsTemplateDesc =>
      'Zarządzaj szablonami projektów i twórz nowe struktury zadań, workflow oraz konfiguracji.';

  @override
  String get projectSettingsTemplateCreateDialogDesc =>
      'Bieżący projekt wraz ze statusami workflow, polami własnymi i zadaniami startowymi zostanie zapisany jako szablon wielokrotnego użytku.';

  @override
  String get projectSettingsTemplateApplyDialogDesc =>
      'Na podstawie tego szablonu zostanie utworzony nowy projekt ze wszystkimi statusami, polami niestandardowymi i zadaniami.';

  @override
  String projectSettingsTemplateUpdatedLabel(String date) {
    return 'Zaktualizowano: $date';
  }

  @override
  String get projectUserHubTitle => 'Moje Centrum Projektu';

  @override
  String get projectUserHubTabProfile => 'Mój Profil';

  @override
  String get projectUserHubTabPreferences => 'Moje Preferencje';

  @override
  String get projectUserHubProfileHeader => 'Twoja rola w projekcie';

  @override
  String get projectUserHubProfileDesc =>
      'Informacje o Twoim członkostwie i przypisanych uprawnieniach.';

  @override
  String get projectUserHubRoleOwnerDesc =>
      'Pełna kontrola nad projektem, zarządzanie członkami, przepływem pracy, automatyzacjami i strefą zagrożenia.';

  @override
  String get projectUserHubRoleAdminDesc =>
      'Zarządzanie konfiguracją zadań, statusami, polami niestandardowymi i członkami projektu.';

  @override
  String get projectUserHubRoleMemberDesc =>
      'Pełny dostęp do tworzenia i edycji zadań, komentarzy oraz realizacji pracy.';

  @override
  String get projectUserHubRoleObserverDesc =>
      'Dostęp wyłącznie do odczytu tablicy, zadań i zasobów projektu.';

  @override
  String get projectUserHubLeaveProjectTitle => 'Opuść projekt';

  @override
  String get projectUserHubLeaveProjectSharedDesc =>
      'Jesteś członkiem przestrzeni roboczej. Po opuszczeniu jawnego członkostwa zachowasz dostęp do projektu w trybie współdzielonym.';

  @override
  String get projectUserHubLeaveProjectPrivateDesc =>
      'Opuszczenie projektu spowoduje utratę bezpośredniego dostępu do tego prywatnego projektu.';

  @override
  String get projectUserHubLeaveProjectButton => 'Opuść ten projekt';

  @override
  String get projectUserHubLeaveConfirmTitle =>
      'Czy na pewno chcesz opuścić ten projekt?';

  @override
  String get projectUserHubLeaveConfirmContent =>
      'Twoje jawne członkostwo zostanie cofnięte. W projekcie prywatnym stracisz dostęp.';

  @override
  String get projectUserHubLeaveConfirmAction => 'Tak, opuść projekt';

  @override
  String get projectUserHubPreferencesHeader => 'Personalizacja projektu';

  @override
  String get projectUserHubPreferencesDesc =>
      'Dostosuj widoczność tego projektu na swoim koncie.';

  @override
  String get projectUserHubPinLabel => 'Przypnij do ulubionych';

  @override
  String get projectUserHubPinDesc =>
      'Projekt będzie wyświetlany na samej górze drzewa projektów.';

  @override
  String get projectUserHubHideLabel => 'Ukryj projekt w bocznym menu';

  @override
  String get projectUserHubHideDesc =>
      'Projekt nie będzie widoczny na liście bocznej (możesz go wciąż wyszukać).';

  @override
  String get projectUserHubPreferenceSaved =>
      'Pomyślnie zaktualizowano preferencje projektu.';

  @override
  String get projectUserHubLeaveSharedSuccessNotice =>
      'Opuszczono jawne członkostwo w projekcie. Jako członek przestrzeni nadal masz dostęp do tego projektu.';

  @override
  String get projectUserHubLeavePrivateSuccessNotice =>
      'Pomyślnie opuszczono projekt.';

  @override
  String get tasksListClearValue => 'Wyczyść';

  @override
  String get tasksListCustomStatus => 'Własny status';

  @override
  String get tasksListMilestone => 'Kamień milowy';

  @override
  String get tasksListNoDueDate => 'Brak terminu';

  @override
  String get tasksListDefaultColor => 'Domyślny kolor';

  @override
  String get tasksListNoIcon => 'Bez ikony';

  @override
  String get tasksListMoveUp => 'Przesuń wyżej';

  @override
  String get tasksListMoveDown => 'Przesuń niżej';

  @override
  String get tasksListRemoveOption => 'Usuń opcję';

  @override
  String get tasksListOptionNameHint => 'Nazwa opcji (np. Wysoki, Pilne)...';

  @override
  String get tasksListAddOptionButton => 'Dodaj';

  @override
  String get tasksListCollaborators => 'Współpracownicy';

  @override
  String get tasksListWatchers => 'Obserwujący';

  @override
  String get tasksListCreated => 'Utworzono';

  @override
  String get tasksListTaskType => 'Typ';

  @override
  String get tasksListSize => 'Rozmiar';

  @override
  String get tasksListComplexity => 'Złożoność';

  @override
  String get tasksListRisk => 'Ryzyko';

  @override
  String get tasksListBusinessValue => 'Wartość';

  @override
  String get tasksListEstimatedMinutes => 'Estymata';

  @override
  String get tasksListActualMinutes => 'Czas rzeczywisty';

  @override
  String tasksListResizeColumnTooltip(String name) {
    return 'Zmień szerokość kolumny: $name';
  }

  @override
  String get tasksListColumnsTitle => 'Dostosuj kolumny';

  @override
  String get tasksListColumnsSubtitle =>
      'Zarządzaj widocznością i kolejnością kolumn na liście';

  @override
  String get tasksListColumnsSearchHint => 'Szukaj kolumn...';

  @override
  String get tasksListColumnsRequiredBadge => 'Wymagana';

  @override
  String get tasksListColumnsRequiredTooltip =>
      'Ta kolumna jest wymagana przez administratora projektu';

  @override
  String get tasksListColumnsDisabledBadge => 'Zablokowana';

  @override
  String get tasksListColumnsDisabledTooltip =>
      'Wyłączona przez administratora projektu';

  @override
  String get tasksListColumnsResetButton => 'Przywróć domyślne';

  @override
  String get tasksListColumnsResetSuccess =>
      'Przywrócono domyślny układ kolumn';

  @override
  String get tasksListColumnsSaveAsViewButton => 'Zapisz jako nowy widok';

  @override
  String get tasksListColumnsDoneButton => 'Gotowe';

  @override
  String get tasksListMySettingsButton => 'Moje ustawienia';

  @override
  String get tasksListAdminPanelButton => 'Panel admina';

  @override
  String get tasksListColumnsScopeUser => 'Moje ustawienia';

  @override
  String get tasksListColumnsScopeProject => 'Domyślne projektu (Admin)';

  @override
  String get tasksListSaveProjectDefaults => 'Zapisz jako domyślne projektu';

  @override
  String get tasksListProjectDefaultsSaved =>
      'Pomyślnie zaktualizowano domyślne kolumny projektu';

  @override
  String get tasksListManageWorkflowButton =>
      'Zarządzaj workflow i statusami...';

  @override
  String get tasksListManageCustomFieldsButton =>
      'Pola niestandardowe projektu...';

  @override
  String get tasksListSortAscending => 'Sortuj rosnąco';

  @override
  String get tasksListSortDescending => 'Sortuj malejąco';

  @override
  String get tasksListSortClear => 'Wyczyść sortowanie';

  @override
  String get tasksListSavingPreferences => 'Zapisywanie preferencji...';

  @override
  String get tasksListPreferencesConflict =>
      'Układ kolumn został zaktualizowany w innej sesji. Odświeżono widok.';

  @override
  String get tasksListSaveViewDialogTitle => 'Nowy zapisany widok';

  @override
  String get tasksListSaveViewDialogHint => 'Nazwa widoku...';

  @override
  String get tasksListDragToReorderTooltip =>
      'Przytrzymaj i przeciągnij, aby zmienić kolejność';

  @override
  String get tasksListTaskCopySuffix => '(kopia)';

  @override
  String get storageMyFiles => 'Moje pliki';

  @override
  String get storageSharedWithMe => 'Udostępnione mi';

  @override
  String get storageRecent => 'Ostatnie';

  @override
  String get storageFavorites => 'Ulubione';

  @override
  String get storageTrash => 'Kosz';

  @override
  String get storageNewFolder => 'Nowy folder';

  @override
  String get storageUploadFiles => 'Prześlij pliki';

  @override
  String get storageSearchHint => 'Szukaj plików i folderów...';

  @override
  String get storageAllFiles => 'Wszystkie pliki';

  @override
  String get storageSortNameAsc => 'Nazwa (A-Z)';

  @override
  String get storageSortNameDesc => 'Nazwa (Z-A)';

  @override
  String get storageSortDateDesc => 'Najnowsze';

  @override
  String get storageSortDateAsc => 'Najstarsze';

  @override
  String get storageSortSizeDesc => 'Największe';

  @override
  String get storageSortSizeAsc => 'Najmniejsze';

  @override
  String storageSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zaznaczono $count elementów',
      many: 'Zaznaczono $count elementów',
      few: 'Zaznaczono $count elementy',
      one: 'Zaznaczono 1 element',
    );
    return '$_temp0';
  }

  @override
  String get storageDownloadZip => 'Pobierz ZIP';

  @override
  String get storageDeleteSelected => 'Usuń zaznaczone';

  @override
  String get storageRestoreSelected => 'Przywróć';

  @override
  String get storageRestoreConfirmTitle => 'Przywrócić plik?';

  @override
  String get storageRestoreConfirmMessage =>
      'Plik zostanie przywrócony z kosza.';

  @override
  String get storageRestoreSuccess => 'Plik został przywrócony.';

  @override
  String get storageClearSelection => 'Wyczyść zaznaczenie';

  @override
  String get storageEmptyTitle => 'Katalog jest pusty';

  @override
  String get storageEmptySubtitle => 'Brak plików lub folderów w tym widoku.';

  @override
  String get storageUploadQueueTitle => 'Kolejka przesyłania';

  @override
  String get storageUploadSuccess => 'Plik przesłany pomyślnie';

  @override
  String get storageUploadFailed => 'Nie udało się przesłać pliku';

  @override
  String get storageDetailsTitle => 'Szczegóły pliku';

  @override
  String get storagePreviewTitle => 'Podgląd pliku';

  @override
  String get storageFileSize => 'Rozmiar';

  @override
  String get storageFileCreatedAt => 'Utworzono';

  @override
  String get storageFileUpdatedAt => 'Zaktualizowano';

  @override
  String get storageFileVersion => 'Wersja';

  @override
  String get storageCreateFolderDialogTitle => 'Utwórz nowy folder';

  @override
  String get storageCreateFolderDialogHint => 'Nazwa folderu...';

  @override
  String get storageCreateFolderButton => 'Utwórz';

  @override
  String get storageCreateFolderSuccess => 'Folder został utworzony.';

  @override
  String get storageCreateFolderConflict => 'Folder o tej nazwie już istnieje.';

  @override
  String get storageCreateFolderValidation =>
      'Wprowadź prawidłową nazwę folderu.';

  @override
  String get storageRenameFolderDialogTitle => 'Zmień nazwę folderu';

  @override
  String get storageRenameFolderButton => 'Zmień nazwę';

  @override
  String get storageRenameFolderSuccess => 'Nazwa folderu została zmieniona.';

  @override
  String get storageRenameFolderNotFound => 'Folder już nie istnieje.';

  @override
  String get storageRenameFolderConflict => 'Folder o tej nazwie już istnieje.';

  @override
  String get storageRenameFolderValidation =>
      'Wprowadź prawidłową nazwę folderu.';

  @override
  String get storageDeleteConfirmTitle => 'Potwierdź usunięcie';

  @override
  String get storageDeleteConfirmMessage =>
      'Czy na pewno chcesz usunąć wybrane elementy do kosza?';

  @override
  String get storageDeleteSuccess => 'Element został przeniesiony do kosza.';

  @override
  String get storageMutationNotFound => 'Folder już nie istnieje.';

  @override
  String get storageMutationConflict => 'Folder o tej nazwie już istnieje.';

  @override
  String get storageMutationValidation => 'Wprowadź prawidłową nazwę folderu.';

  @override
  String storageShareTitle(String fileName) {
    return 'Udostępnij: $fileName';
  }

  @override
  String get storageActiveShares => 'Aktywne udostępnienia';

  @override
  String get storageNoActiveShares =>
      'Brak aktywnych udostępnień poza właścicielem.';

  @override
  String storageShareUserLabel(String identifier) {
    return 'Użytkownik: $identifier';
  }

  @override
  String storageShareWorkspaceLabel(String identifier) {
    return 'Workspace: $identifier';
  }

  @override
  String storageShareProjectLabel(String identifier) {
    return 'Projekt: $identifier';
  }

  @override
  String get storageUserInputHint => 'Identyfikator użytkownika / e-mail';

  @override
  String get storageUserSearchWorkspaceRequired =>
      'Wyszukiwanie lokalnego katalogu jest dostępne dla plików workspace lub projektu.';

  @override
  String get storageUserSearchNoResults =>
      'Nie znaleziono użytkowników z aktywnym kontem lokalnym.';

  @override
  String get storageAddShareButton => 'Dodaj';

  @override
  String get storagePublicLinkTitle => 'Link publiczny';

  @override
  String get storagePublicLinkSubtitle =>
      'Umożliwia dostęp bez logowania z wybranymi prawami';

  @override
  String get storagePublicSharePageTitle => 'Udostępniony plik';

  @override
  String get storagePublicSharePageDescription =>
      'Pobierz plik przez bezpieczny link. Jeśli właściciel ustawił hasło, wpisz je poniżej.';

  @override
  String get storagePublicShareUnavailable =>
      'Publiczne udostępnianie jest chwilowo niedostępne.';

  @override
  String get storagePublicSharePassword => 'Hasło';

  @override
  String get storagePublicSharePasswordOptional =>
      'Pozostaw puste, jeśli link nie wymaga hasła';

  @override
  String get storageShowPassword => 'Pokaż hasło';

  @override
  String get storageHidePassword => 'Ukryj hasło';

  @override
  String get storagePublicShareDownload => 'Pobierz plik';

  @override
  String storagePublicShareDownloadStarted(String fileName) {
    return 'Rozpoczęto pobieranie: $fileName';
  }

  @override
  String get storagePublicLinkNoExpiry => 'Bez daty wygaśnięcia';

  @override
  String storagePublicLinkExpires(String date) {
    return 'Wygasa $date';
  }

  @override
  String get storageCopyPublicLink => 'Kopiuj link publiczny';

  @override
  String get storageGenerateLinkButton => 'Generuj link';

  @override
  String get storageLinkCopied => 'Link skopiowany do schowka';

  @override
  String get storageAccessReader => 'Podgląd';

  @override
  String get storageAccessCommenter => 'Komentarz';

  @override
  String get storageAccessEditor => 'Edycja';

  @override
  String get storageAccessOwner => 'Właściciel';

  @override
  String get storageShareAction => 'Udostępnij';

  @override
  String get storageAddFavoriteAction => 'Dodaj do ulubionych';

  @override
  String get storageRemoveFavoriteAction => 'Usuń z ulubionych';

  @override
  String get storageDownloadAction => 'Pobierz';

  @override
  String storageDownloadSuccess(String fileName) {
    return 'Pobrano plik: $fileName do folderu Pobrane';
  }

  @override
  String get storageDeleteAction => 'Usuń';

  @override
  String get storageOpenOfficeAction => 'Otwórz dokument';

  @override
  String get storageOfficeEditMode => 'Tryb edycji';

  @override
  String get storageOfficeViewMode => 'Tylko podgląd';

  @override
  String get storageOfficeActive => 'Sesja OnlyOffice Document Server aktywna';

  @override
  String get storageOfficeHostLoading => 'Ładowanie edytora OnlyOffice…';

  @override
  String get storageOfficeHostFailure =>
      'Nie udało się załadować osadzonego edytora OnlyOffice.';

  @override
  String get storageOfficeDownloadFailure =>
      'Nie udało się przygotować pobrania dokumentu. Sprawdź połączenie z OnlyOffice i spróbuj ponownie.';

  @override
  String get storageOfficeCloseUnconfirmed =>
      'Edytor nie potwierdził bezpiecznego zamknięcia. Zamknięcie mimo tego może spowodować utratę niezapisanych zmian. Czy zamknąć dokument?';

  @override
  String get storageOfficeSessionFailure =>
      'Nie udało się uruchomić sesji edytora OnlyOffice';

  @override
  String get storageCloseOffice => 'Zamknij dokument';

  @override
  String get storageOfficePrintAction => 'Drukuj';

  @override
  String get storageOfficePrinting => 'Przygotowywanie wydruku…';

  @override
  String get storageOfficePrintFailure => 'Nie udało się wydrukować dokumentu.';

  @override
  String storageOfficeDownloadSuccess(String fileName) {
    return 'Pobrano plik: $fileName do folderu Pobrane';
  }

  @override
  String get storageOfficeSaveCopyAction => 'Zapisz kopię w Storage';

  @override
  String get storageOfficeSavingCopy => 'Zapisywanie kopii w Storage…';

  @override
  String storageOfficeSaveCopySuccess(String fileName) {
    return 'Zapisano kopię „$fileName” w Storage';
  }

  @override
  String get storageOfficeSaveCopyFailure =>
      'Nie udało się zapisać kopii dokumentu w Storage.';

  @override
  String get storageSortTooltip => 'Sortowanie';

  @override
  String get storageListViewTooltip => 'Widok listy';

  @override
  String get storageGridViewTooltip => 'Widok siatki';

  @override
  String get storageMoreOptionsTooltip => 'Więcej opcji';

  @override
  String get storageClearCompletedTooltip => 'Wyczyść zakończone';

  @override
  String get storageCancelUploadTooltip => 'Anuluj wysyłanie';

  @override
  String get storageRetryUploadTooltip => 'Ponów transfer';

  @override
  String get storageErrorTitle => 'Wystąpił błąd';

  @override
  String get storageForbiddenTitle => 'Brak uprawnień';

  @override
  String storagePreviewError(String message) {
    return 'Błąd podglądu: $message';
  }

  @override
  String get storageImageLoadError => 'Nie udało się załadować obrazu.';

  @override
  String get storageOfficeDescription =>
      'Dokument pakietu biurowego gotowy do pracy w OnlyOffice.';

  @override
  String get storagePdfDescription =>
      'Dokument PDF można otworzyć w bezpiecznym podglądzie systemowym.';

  @override
  String get storageVideoDescription =>
      'Plik wideo można odtworzyć w podglądzie systemowym.';

  @override
  String get storageAudioDescription =>
      'Nagranie można odtworzyć w podglądzie systemowym.';

  @override
  String get storageTextDescription => 'Plik tekstowy lub kod źródłowy.';

  @override
  String get storageUnsupportedDescription =>
      'Podgląd bezpośredni nie jest dostępny dla tego formatu.';

  @override
  String get storageOpenPdfPreview => 'Otwórz podgląd PDF';

  @override
  String get storagePlayVideo => 'Odtwórz wideo';

  @override
  String get storagePlayAudio => 'Odtwórz audio';

  @override
  String get storageOpenText => 'Otwórz treść';

  @override
  String get storageRemoveShareTooltip => 'Usuń uprawnienie';

  @override
  String storageShareAccessLabel(String access) {
    return 'Prawa: $access';
  }

  @override
  String get storageFolderTitle => 'Katalog';

  @override
  String get storageWorkspaceFilesTitle => 'Pliki workspace';

  @override
  String get storageProjectFilesTitle => 'Pliki projektu';

  @override
  String get storageAttachmentsTitle => 'Załączniki';

  @override
  String storageFilesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pliku',
      many: '$count plików',
      few: '$count pliki',
      one: '1 plik',
    );
    return '$_temp0';
  }

  @override
  String get storageFoldersTitle => 'Foldery';

  @override
  String storageItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementu',
      many: '$count elementów',
      few: '$count elementy',
      one: '1 element',
    );
    return '$_temp0';
  }

  @override
  String get storageVersionsTitle => 'Historia wersji';

  @override
  String get storageVersionsEmpty => 'Brak zapisanych wersji pliku.';

  @override
  String storageVersionLabel(int version) {
    return 'Wersja $version';
  }

  @override
  String get storageUploadFileTooLarge =>
      'Plik przekracza limit rozmiaru 20 MB.';

  @override
  String get storageUploadCancelledByUser => 'Anulowano przez użytkownika.';

  @override
  String get storageUploadCancelled => 'Wysyłka anulowana.';

  @override
  String get storageUploadUnsupportedScope =>
      'W tym widoku nie można przesyłać plików.';

  @override
  String get storageUploadTicketReservationFailed =>
      'Nie udało się zarezerwować biletu uploadu.';

  @override
  String get storageUploadTransferFailed => 'Błąd przesyłania danych.';

  @override
  String get storageUploadCompletionFailed =>
      'Nie udało się zatwierdzić pliku.';

  @override
  String get storageUploadPlacementFailed =>
      'Plik przesłano, ale nie dodano go do wybranego folderu.';

  @override
  String get storagePartialDeleteFailed =>
      'Część elementów nie mogła zostać usunięta.';

  @override
  String get storageDeleteSelectedFailed =>
      'Nie udało się usunąć wybranych elementów.';

  @override
  String get globalChatEmptyTitle => 'Brak rozmów';

  @override
  String get globalChatEmptyMessage =>
      'Twoje aktywne rozmowy pojawią się tutaj.';

  @override
  String get globalChatLoadFailureTitle => 'Nie udało się pobrać rozmów';

  @override
  String globalChatConversationFallback(String identifier) {
    return 'Rozmowa $identifier';
  }

  @override
  String get globalChatGroupProject => 'Projekt';

  @override
  String get globalChatGroupWorkspace => 'Workspace';

  @override
  String get globalChatGroupPrivate => 'Prywatne';

  @override
  String get globalChatBackToConversations => 'Wróć do rozmów';

  @override
  String get globalChatOpenFullView => 'Otwórz pełny widok';

  @override
  String get globalChatComposerHint => 'Napisz wiadomość…';

  @override
  String get globalChatSendMessage => 'Wyślij wiadomość';

  @override
  String get globalChatDeletedMessage => 'Wiadomość usunięta';

  @override
  String get chatComposerPlainMode => 'Zwykły tekst';

  @override
  String get chatComposerRichMode => 'Formatowany tekst';

  @override
  String chatComposerReplyTo(String message) {
    return 'Odpowiedź na: $message';
  }

  @override
  String get chatComposerCancelReply => 'Anuluj odpowiedź';

  @override
  String get chatComposerReplyAction => 'Odpowiedz';

  @override
  String get chatThreadTitle => 'Wątek';

  @override
  String get chatThreadClose => 'Zamknij wątek';

  @override
  String get chatThreadOpen => 'Otwórz wątek';

  @override
  String get globalNotificationsTitle => 'Powiadomienia';

  @override
  String get globalNotificationsEmptyTitle => 'Brak nowych powiadomień';

  @override
  String get globalNotificationsEmptyMessage =>
      'Tutaj pojawią się informacje dotyczące Twojej pracy.';

  @override
  String get globalNotificationsSessionRequired => 'Sesja wymaga odświeżenia';

  @override
  String get globalNotificationsAccessDenied => 'Brak dostępu';

  @override
  String get globalNotificationsLoadFailureTitle =>
      'Nie udało się pobrać powiadomień';

  @override
  String get globalNotificationsTransportUnavailableTitle =>
      'Powiadomienia nie są jeszcze dostępne';

  @override
  String get globalNotificationsTransportUnavailableMessage =>
      'Transport powiadomień standalone nie jest jeszcze skonfigurowany.';

  @override
  String get globalNotificationsMarkAllRead =>
      'Oznacz wszystkie jako przeczytane';

  @override
  String get globalNotificationsRefreshFailed =>
      'Nie udało się odświeżyć powiadomień';

  @override
  String get globalNotificationsConnecting =>
      'Łączenie z powiadomieniami na żywo…';

  @override
  String get globalNotificationsReconnecting =>
      'Ponowne łączenie z powiadomieniami na żywo…';

  @override
  String get globalNotificationsOffline => 'Powiadomienia na żywo są offline';

  @override
  String get globalChatConnecting => 'Łączenie z czatem na żywo…';

  @override
  String get globalChatReconnecting => 'Ponowne łączenie z czatem na żywo…';

  @override
  String get globalChatOffline => 'Czat na żywo jest offline';

  @override
  String get globalNotificationsGroups => 'Grupy';

  @override
  String get globalNotificationsItems => 'Wpisy';

  @override
  String get globalNotificationsUnreadOnly => 'Tylko nieprzeczytane';

  @override
  String get globalNotificationsAllCategories => 'Wszystkie kategorie';

  @override
  String get globalNotificationsLoadMore => 'Wczytaj więcej';

  @override
  String get globalNotificationsGroupActions => 'Akcje grupy';

  @override
  String get globalNotificationsMarkGroupRead =>
      'Oznacz grupę jako przeczytaną';

  @override
  String get globalNotificationsPin => 'Przypnij';

  @override
  String get globalNotificationsUnpin => 'Odepnij';

  @override
  String get globalNotificationsArchive => 'Archiwizuj';

  @override
  String get globalNotificationsReply => 'Odpowiedz';

  @override
  String get globalNotificationsReplyTitle => 'Odpowiedź na czacie';

  @override
  String get globalNotificationsReplyHint => 'Napisz odpowiedź…';

  @override
  String get globalNotificationsReplyPlainMode => 'Tekst';

  @override
  String get globalNotificationsReplyRichMode => 'Tekst sformatowany';

  @override
  String get globalNotificationsReplySend => 'Wyślij odpowiedź';

  @override
  String get globalNotificationsReplyAccessRevoked =>
      'Dostęp do tej rozmowy został odebrany. Szkic odpowiedzi został usunięty.';

  @override
  String get globalNotificationsReplyFailed =>
      'Nie udało się wysłać odpowiedzi';

  @override
  String globalNotificationsUnreadCount(int count) {
    return '$count nieprzeczytanych powiadomień';
  }

  @override
  String get notificationPreferencesOpen => 'Preferencje powiadomień';

  @override
  String get notificationPreferencesTitle => 'Preferencje powiadomień';

  @override
  String get notificationPreferencesDeliveryTitle => 'Dostarczanie e-mail';

  @override
  String get notificationPreferencesDeliveryDescription =>
      'Wybierz sposób dostarczania każdej kategorii powiadomień na e-mail.';

  @override
  String get notificationPreferencesDeliveryMode => 'Tryb dostarczania';

  @override
  String get notificationPreferencesCategoryInvitation => 'Zaproszenia';

  @override
  String get notificationPreferencesCategoryMembership => 'Członkostwo';

  @override
  String get notificationPreferencesCategoryWorkspace => 'Workspace’y';

  @override
  String get notificationPreferencesCategoryProject => 'Projekty';

  @override
  String get notificationPreferencesCategoryTask => 'Zadania';

  @override
  String get notificationPreferencesCategoryComment => 'Komentarze';

  @override
  String get notificationPreferencesCategoryChat => 'Czat';

  @override
  String get notificationPreferencesCategoryStorage => 'Pliki';

  @override
  String get notificationPreferencesCategorySystem => 'System';

  @override
  String get notificationPreferencesModeNone => 'Nie wysyłaj';

  @override
  String get notificationPreferencesModeImmediate => 'Natychmiast';

  @override
  String get notificationPreferencesModeDailyDigest => 'Dzienny digest';

  @override
  String get notificationPreferencesModeDigest => 'Digest';

  @override
  String get notificationPreferencesStorageTitle => 'Powiadomienia plików';

  @override
  String get notificationPreferencesStorageDescription =>
      'Wybierz dostarczanie zdarzeń dotyczących plików, do których masz dostęp.';

  @override
  String get notificationPreferencesStorageMode => 'Tryb dostarczania plików';

  @override
  String get notificationPreferencesStorageInherited =>
      'Bieżące ustawienie jest dziedziczone z polityki domyślnej.';

  @override
  String get notificationPreferencesStorageImmediate => 'Natychmiast';

  @override
  String get notificationPreferencesStorageDigest => 'Digest';

  @override
  String get notificationPreferencesStorageMentionsOnly => 'Tylko wzmianki';

  @override
  String get notificationPreferencesStorageDisabled => 'Wyłączone';

  @override
  String get notificationPreferencesDigestTitle => 'Podgląd digestu';

  @override
  String get notificationPreferencesDigestDescription =>
      'Tylko do odczytu: podsumowanie aktualnie widocznych grup powiadomień.';

  @override
  String get notificationPreferencesDigestEmpty =>
      'Brak powiadomień w digescie.';

  @override
  String notificationPreferencesDigestSummary(int count) {
    return 'Digest zawiera $count grup powiadomień';
  }

  @override
  String notificationPreferencesDigestCount(int count) {
    return '$count powiadomień';
  }

  @override
  String get chatNotificationSettingsGlobalTitle => 'Powiadomienia Chat';

  @override
  String get chatNotificationSettingsGlobalDescription =>
      'Wybierz kanały, którymi mają docierać powiadomienia z globalnego czatu.';

  @override
  String get chatNotificationSettingsChannelInApp => 'W aplikacji';

  @override
  String get chatNotificationSettingsChannelEmail => 'E-mail';

  @override
  String get chatNotificationSettingsChannelPush => 'Push';

  @override
  String get chatNotificationSettingsChannelDigest => 'Digest';

  @override
  String get chatConversationNotificationSettingsOpen =>
      'Ustawienia powiadomień rozmowy';

  @override
  String get chatConversationNotificationSettingsTitle =>
      'Powiadomienia rozmowy';

  @override
  String get chatConversationNotificationSettingsDescription =>
      'Ustaw sposób otrzymywania powiadomień tylko z tej rozmowy.';

  @override
  String get chatConversationNotificationModeLabel => 'Tryb powiadomień';

  @override
  String get chatConversationNotificationModeAll => 'Wszystkie wiadomości';

  @override
  String get chatConversationNotificationModeMentionsOnly => 'Tylko wzmianki';

  @override
  String get chatConversationNotificationModeMuted => 'Wyciszone';

  @override
  String get chatConversationNotificationModeHighOnly =>
      'Tylko wysoki priorytet';

  @override
  String get resourceChatFileAction => 'Czat pliku';

  @override
  String get resourceChatFileDescription =>
      'Otwórz autoryzowaną rozmowę dotyczącą tego udostępnionego pliku.';

  @override
  String resourceChatFileHeader(
    String fileName,
    String ownerUserId,
    String accessLevel,
  ) {
    return 'Plik: $fileName · Właściciel: $ownerUserId · Dostęp: $accessLevel';
  }

  @override
  String get chatDiscussionTitle => 'Nazwana dyskusja';

  @override
  String get chatDiscussionNameLabel => 'Nazwa dyskusji';

  @override
  String get chatDiscussionOpen => 'Otwórz dyskusję';

  @override
  String chatDiscussionReady(String name) {
    return 'Dyskusja gotowa: $name';
  }

  @override
  String get chatMessageActionsOpen => 'Akcje wiadomości';

  @override
  String get chatMessageEdit => 'Edytuj wiadomość';

  @override
  String get chatMessageDelete => 'Usuń wiadomość';

  @override
  String get chatMessageRevisions => 'Historia edycji';

  @override
  String get chatMessageEditTitle => 'Edytuj wiadomość';

  @override
  String get chatMessageEditLabel => 'Treść wiadomości';

  @override
  String get chatMessageCancel => 'Anuluj';

  @override
  String get chatMessageSave => 'Zapisz zmiany';

  @override
  String get chatMessageClose => 'Zamknij';

  @override
  String get chatMessageRevisionsTitle => 'Historia edycji';

  @override
  String get chatMessageRevisionsEmpty =>
      'Ta wiadomość nie ma wcześniejszych wersji.';

  @override
  String chatMessageRevisionVersion(int version, int newVersion) {
    return 'Wersja $version → $newVersion';
  }

  @override
  String get chatThreadLoadOlder => 'Wczytaj starsze odpowiedzi';

  @override
  String get chatAttachmentsEmpty => 'Nie wybrano załączników';

  @override
  String get chatAttachmentsAdd => 'Dodaj pliki';

  @override
  String get chatAttachmentRemove => 'Usuń załącznik';

  @override
  String get chatAttachmentStatusProcessing => 'Przetwarzanie';

  @override
  String get chatAttachmentStatusScanning => 'Skanowanie';

  @override
  String get chatAttachmentStatusClean => 'Czysty';

  @override
  String get chatAttachmentStatusInfected => 'Zainfekowany';

  @override
  String get chatAttachmentStatusFailed => 'Niepowodzenie';

  @override
  String get meProfileTitle => 'Mój profil';

  @override
  String get meProfileSubtitle =>
      'Zarządzaj swoimi danymi, hasłem i aktywnymi sesjami';

  @override
  String get mePersonalSectionTitle => 'Dane profilu';

  @override
  String get mePersonalSectionSubtitle =>
      'Twoje podstawowe dane identyfikacyjne w systemie';

  @override
  String get meLoginLabel => 'Login';

  @override
  String get meEmailLabel => 'Adres e-mail';

  @override
  String get meDisplayNameLabel => 'Nazwa wyświetlana';

  @override
  String get meDisplayNameHint => 'Wpisz nazwę wyświetlaną';

  @override
  String get meDisplayNameRequired => 'Nazwa wyświetlana nie może być pusta';

  @override
  String get meRolesLabel => 'Przypisane role';

  @override
  String get mePermissionsLabel => 'Uprawnienia';

  @override
  String get meSaveProfileButton => 'Zapisz profil';

  @override
  String get meProfileUpdateSuccess => 'Profil został zaktualizowany.';

  @override
  String get mePasswordSectionTitle => 'Zmiana hasła';

  @override
  String get mePasswordSectionSubtitle =>
      'Wymagane minimum 15 znaków dla bezpieczeństwa konta';

  @override
  String get meCurrentPasswordLabel => 'Aktualne hasło';

  @override
  String get meCurrentPasswordHint => 'Wpisz aktualne hasło';

  @override
  String get meCurrentPasswordRequired => 'Podaj aktualne hasło';

  @override
  String get meNewPasswordLabel => 'Nowe hasło';

  @override
  String get meNewPasswordHint => 'Minimum 15 znaków';

  @override
  String get meNewPasswordMinLengthError =>
      'Nowe hasło musi zawierać co najmniej 15 znaków';

  @override
  String get meNewPasswordMaxLengthError =>
      'Nowe hasło może zawierać maksymalnie 128 znaków';

  @override
  String get meNewPasswordSameAsCurrentError =>
      'Nowe hasło musi różnić się od aktualnego';

  @override
  String get meConfirmPasswordLabel => 'Potwierdź nowe hasło';

  @override
  String get meConfirmPasswordHint => 'Powtórz nowe hasło';

  @override
  String get mePasswordsDoNotMatchError => 'Hasła nie są identyczne';

  @override
  String get meChangePasswordButton => 'Zmień hasło';

  @override
  String get mePasswordChangeSuccess => 'Hasło zostało pomyślnie zmienione.';

  @override
  String get meSessionsSectionTitle => 'Aktywne sesje urządzeń';

  @override
  String get meSessionsSectionSubtitle =>
      'Zalogowane urządzenia i przeglądarki powiązane z Twoim kontem';

  @override
  String get meSessionCurrentBadge => 'Bieżąca sesja';

  @override
  String meSessionCreated(String date) {
    return 'Utworzono: $date';
  }

  @override
  String meSessionLastSeen(String date) {
    return 'Ostatnia aktywność: $date';
  }

  @override
  String get meSessionRevokeButton => 'Zakończ sesję';

  @override
  String get meSessionRevokeConfirmTitle => 'Zakończyć tę sesję?';

  @override
  String meSessionRevokeConfirmMessage(String device) {
    return 'Sesja na urządzeniu \"$device\" zostanie unieważniona, a użytkownik wylogowany.';
  }

  @override
  String get meSessionRevokeConfirmAction => 'Zakończ sesję';

  @override
  String get meSessionRevokedSuccess => 'Sesja została pomyślnie zakończona.';

  @override
  String get meSessionsEmpty => 'Brak aktywnych sesji do wyświetlenia.';

  @override
  String get meSessionsRefreshTooltip => 'Odśwież sesje';

  @override
  String get meProfileRetry => 'Spróbuj ponownie';

  @override
  String get meUnavailableTitle => 'Profil niedostępny';

  @override
  String get meUnavailableMessage =>
      'Usługa profilu nie jest jeszcze skonfigurowana.';
}
