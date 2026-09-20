import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/models/project_action_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Akcje jednego menu kontekstowego projektu z planu §3.3.
///
/// Menu jest jedno dla całego drzewa: ta sama definicja obsługuje widok
/// drzewa, sekcję `Ukryte` i sekcję `Archiwum`, a różnice wynikają wyłącznie
/// z [ProjectMenuPlacement].
enum ProjectContextAction {
  open,
  togglePin,
  hide,
  unhide,
  renameAppearance,
  settings,
  createTemplate,
  archive,
  restore,
  deletePermanently,
  moveToWorkspace,
  leaveProject,
}

/// Miejsce, z którego otwarto menu projektu.
enum ProjectMenuPlacement {
  /// Zwykły wiersz drzewa projektów.
  tree,

  /// Wiersz w sekcji `Ukryte`.
  hiddenSection,

  /// Wiersz w sekcji `Archiwum` — tutaj wolno trwale usunąć projekt.
  archiveSection,
}

/// Dostępność akcji wynikająca z kompozycji i capabilities z serwera.
///
/// Uprawnienia pochodzą wyłącznie z `capabilities` projektu, a nie z roli
/// użytkownika (`myRole`), bo rola nie mówi, czy backend pozwala na konkretną
/// operację (SuperAdmin, delegacje, reguła ostatniego właściciela). Brak
/// capabilities jest stanem jawnym: UI nie zgaduje uprawnień, tylko wyłącza
/// akcje z powodem. Backend zawsze egzekwuje własne ACL.
final class ProjectMenuAvailability {
  const ProjectMenuAvailability({
    required this.capabilities,
    this.canMutatePreferences = false,
    this.canCreateTemplate = false,
    this.canOpenSettings = false,
    this.canManageLifecycle = false,
  });

  /// Możliwości zwrócone przez backend albo `null`, gdy ich nie zwrócił.
  final ProjectActionCapabilities? capabilities;

  /// Czy dostępny jest port preferencji (pin/hide).
  final bool canMutatePreferences;

  /// Czy dostępne jest repozytorium szablonów projektów.
  final bool canCreateTemplate;

  /// Czy centrum ustawień projektu jest dostępne w tej kompozycji.
  final bool canOpenSettings;

  /// Czy dostępny jest port lifecycle (archiwizacja, przywracanie, usunięcie).
  final bool canManageLifecycle;

  /// Czy użytkownik może zmieniać dane projektu (nazwa, opis, wygląd).
  bool get canManage => capabilities?.canManage ?? false;

  /// Czy użytkownik może archiwizować i przywracać projekt.
  bool get canArchive => capabilities?.canArchive ?? false;

  /// Czy użytkownik może trwale usunąć zarchiwizowany projekt.
  bool get canDeletePermanently => capabilities?.canDelete ?? false;

  /// Czy użytkownik może zapisać szablon z projektu.
  bool get canCreateTemplateFromProject =>
      capabilities?.canCreateTemplate ?? false;

  /// Czy użytkownik ma jawne członkostwo, które może opuścić.
  bool get canLeave => capabilities?.canLeave ?? false;

  /// Czy transfer projektu jest dozwolony; dopóki kontrakt transferu nie
  /// istnieje, backend zwraca `false`.
  bool get canTransfer => capabilities?.canTransfer ?? false;
}

/// Pojedyncza pozycja menu kontekstowego z jawnym powodem wyłączenia.
final class ProjectMenuEntry {
  const ProjectMenuEntry({
    required this.action,
    required this.icon,
    required this.label,
    this.disabledReason,
  });

  /// Akcja wywoływana po wybraniu pozycji.
  final ProjectContextAction action;

  /// Ikona pozycji.
  final IconData icon;

  /// Etykieta z ARB.
  final String label;

  /// Powód wyłączenia pozycji; `null` oznacza pozycję aktywną.
  final String? disabledReason;

  /// Czy pozycja jest aktywna.
  bool get enabled => disabledReason == null;
}

/// Buduje pozycje menu projektu dla danego miejsca i dostępności.
///
/// Funkcja jest czysta, więc kolejność i powody wyłączenia akcji można
/// sprawdzić testem bez uruchamiania UI.
List<ProjectMenuEntry> buildProjectContextMenuEntries({
  required AppLocalizations l10n,
  required ProjectListItem project,
  required ProjectMenuPlacement placement,
  required ProjectMenuAvailability availability,
}) {
  // Brak capabilities to nie to samo co odmowa: komunikat mówi wprost, że
  // backend nie zwrócił uprawnień, zamiast sugerować brak roli.
  final manageReason = availability.capabilities == null
      ? l10n.projectsMenuReasonUnknownCapabilities
      : l10n.projectsMenuReasonManagePermission;
  final deleteReason = availability.capabilities == null
      ? l10n.projectsMenuReasonUnknownCapabilities
      : l10n.projectsMenuReasonDeletePermission;
  final leaveReason = availability.canLeave
      ? null
      : availability.capabilities == null
      ? l10n.projectsMenuReasonUnknownCapabilities
      : l10n.projectsMenuReasonLeaveRule;
  final entries = <ProjectMenuEntry>[];

  entries.add(
    ProjectMenuEntry(
      action: ProjectContextAction.open,
      icon: Icons.open_in_new_rounded,
      label: l10n.projectsMenuOpen,
    ),
  );

  final preferenceReason = availability.canMutatePreferences
      ? null
      : l10n.projectsMenuReasonNoTransport;
  entries
    ..add(
      ProjectMenuEntry(
        action: ProjectContextAction.togglePin,
        icon: project.isPinned
            ? Icons.push_pin_outlined
            : Icons.push_pin_rounded,
        label: project.isPinned ? l10n.projectsMenuUnpin : l10n.projectsMenuPin,
        disabledReason: preferenceReason,
      ),
    )
    ..add(
      ProjectMenuEntry(
        action: placement == ProjectMenuPlacement.hiddenSection
            ? ProjectContextAction.unhide
            : ProjectContextAction.hide,
        icon: placement == ProjectMenuPlacement.hiddenSection
            ? Icons.visibility_rounded
            : Icons.visibility_off_rounded,
        label: placement == ProjectMenuPlacement.hiddenSection
            ? l10n.projectsMenuUnhide
            : l10n.projectsMenuHide,
        disabledReason: preferenceReason,
      ),
    );

  if (placement == ProjectMenuPlacement.tree) {
    entries
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.renameAppearance,
          icon: Icons.edit_outlined,
          label: l10n.projectsMenuRenameAppearance,
          disabledReason: !availability.canManage
              ? manageReason
              : (availability.canOpenSettings
                    ? null
                    : l10n.projectsMenuReasonNoSettings),
        ),
      )
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.settings,
          icon: Icons.tune_rounded,
          label: l10n.projectsMenuSettings,
          disabledReason: availability.canOpenSettings
              ? null
              : l10n.projectsMenuReasonNoSettings,
        ),
      )
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.createTemplate,
          icon: Icons.bookmark_add_outlined,
          label: l10n.projectsMenuCreateTemplate,
          disabledReason: !availability.canCreateTemplate
              ? l10n.projectsMenuReasonNoTemplatePort
              : (availability.canCreateTemplateFromProject
                    ? null
                    : manageReason),
        ),
      )
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.archive,
          icon: Icons.archive_outlined,
          label: l10n.projectsMenuArchive,
          disabledReason: !availability.canManageLifecycle
              ? l10n.projectsMenuReasonNoTransport
              : (availability.canArchive ? null : manageReason),
        ),
      )
      // Kontrakty, których jeszcze nie ma, są jawnie wyłączone z powodem.
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.moveToWorkspace,
          icon: Icons.drive_file_move_outlined,
          label: l10n.projectsMenuMoveToWorkspace,
          disabledReason: availability.canTransfer
              ? null
              : l10n.projectsMenuReasonTransferContract,
        ),
      )
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.leaveProject,
          icon: Icons.logout_rounded,
          label: l10n.projectsMenuLeaveProject,
          disabledReason: leaveReason,
        ),
      );
  }

  if (placement == ProjectMenuPlacement.archiveSection) {
    entries
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.restore,
          icon: Icons.unarchive_outlined,
          label: l10n.projectsMenuRestore,
          disabledReason: !availability.canManageLifecycle
              ? l10n.projectsMenuReasonNoTransport
              : (availability.canArchive ? null : manageReason),
        ),
      )
      ..add(
        ProjectMenuEntry(
          action: ProjectContextAction.deletePermanently,
          icon: Icons.delete_forever_outlined,
          label: l10n.projectsMenuDeletePermanently,
          disabledReason: !availability.canManageLifecycle
              ? l10n.projectsMenuReasonNoTransport
              : (availability.canDeletePermanently ? null : deleteReason),
        ),
      );
  }

  return List<ProjectMenuEntry>.unmodifiable(entries);
}

/// Przycisk otwierający jedno menu kontekstowe projektu.
///
/// Widget nie wykonuje żądań: wybór akcji trafia do właściciela drzewa, który
/// decyduje o optimistycznej zmianie stanu, potwierdzeniu i rollbacku.
class ProjectContextMenuButton extends StatelessWidget {
  const ProjectContextMenuButton({
    required this.project,
    required this.placement,
    required this.availability,
    required this.onSelected,
    this.busy = false,
    super.key,
  });

  /// Projekt, którego dotyczy menu.
  final ProjectListItem project;

  /// Miejsce w drzewie, z którego otwarto menu.
  final ProjectMenuPlacement placement;

  /// Dostępność akcji w bieżącej kompozycji.
  final ProjectMenuAvailability availability;

  /// Wywoływane po wybraniu akcji.
  final ValueChanged<ProjectContextAction> onSelected;

  /// Czy trwa zapisywanie zmiany tego projektu.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = buildProjectContextMenuEntries(
      l10n: l10n,
      project: project,
      placement: placement,
      availability: availability,
    );

    return PopupMenuButton<ProjectContextAction>(
      tooltip: busy ? l10n.projectsMenuBusy : l10n.projectsTreeMenuTooltip,
      padding: EdgeInsets.zero,
      iconSize: 16,
      icon: Icon(
        Symbols.more_vert_rounded,
        size: 16,
        color: context.colors.onSurfaceVariant,
      ),
      onSelected: onSelected,
      itemBuilder: (context) => <PopupMenuEntry<ProjectContextAction>>[
        for (final entry in entries)
          PopupMenuItem<ProjectContextAction>(
            value: entry.action,
            enabled: entry.enabled,
            height: entry.enabled ? 38 : 56,
            child: _ProjectMenuEntryTile(entry: entry),
          ),
      ],
    );
  }
}

class _ProjectMenuEntryTile extends StatelessWidget {
  const _ProjectMenuEntryTile({required this.entry});

  final ProjectMenuEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = entry.enabled
        ? colors.onSurface
        : colors.onSurfaceVariant;

    return Row(
      children: [
        Icon(entry.icon, size: 16, color: foreground),
        Gaps.w8,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelLarge?.copyWith(color: foreground),
              ),
              if (entry.disabledReason case final reason?)
                Text(
                  reason,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
