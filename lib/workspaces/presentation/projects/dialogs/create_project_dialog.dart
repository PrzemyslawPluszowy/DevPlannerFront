import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/repositories/project_setups_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/project_creation_wizard.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Jedno wejście tworzenia projektu: wieloetapowy kreator.
///
/// Sidebar, drzewo projektów i command palette otwierają ten sam kreator — nie
/// istnieje drugi, uproszczony formularz. Kreator nie tworzy projektu przed
/// finalnym potwierdzeniem i nie wstawia do drzewa żadnego lokalnego
/// identyfikatora: identyfikator pochodzi z odpowiedzi serwera.
class CreateProjectDialog extends StatefulWidget {
  /// Tworzy kreator projektu.
  const CreateProjectDialog({
    required this.workspaceId,
    required this.repository,
    this.templatesRepository,
    this.membersRepository,
    this.currentUserId,
    this.onProjectCreated,
    this.onCreated,
    super.key,
  });

  /// Workspace, w którym powstanie projekt.
  final String workspaceId;

  /// Port atomowego kreatora projektu.
  ///
  /// `null` oznacza, że transport tej sesji nie wspiera standalone API. Kreator
  /// nie udaje wtedy sukcesu — pokazuje jawny powód i nie tworzy draftu.
  final ProjectSetupsRepository? repository;

  /// Port katalogu i podglądów szablonów; `null` pokazuje krok startu bez kart.
  final ProjectTemplatesRepository? templatesRepository;

  /// Port członków workspace; `null` pokazuje krok dostępu bez listy osób.
  final WorkspacesRepository? membersRepository;

  /// UUID bieżącego użytkownika, jeśli znany.
  final String? currentUserId;

  /// Powiadomienie z identyfikatorem projektu przydzielonym przez Backend.
  ///
  /// To nim drzewo uzupełnia gałąź bez ponownego pobierania całej listy.
  final FutureOr<void> Function(String projectId)? onProjectCreated;

  /// Ogólne powiadomienie o utworzeniu projektu, zachowane dla istniejących
  /// wywołań sidebaru i drzewa.
  final FutureOr<void> Function()? onCreated;

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  ProjectSetupWizardCubit? _cubit;

  @override
  void initState() {
    super.initState();
    final repository = widget.repository;
    if (repository == null) return;
    _cubit = ProjectSetupWizardCubit(
      workspaceId: widget.workspaceId,
      setups: repository,
      templates: widget.templatesRepository,
      members: widget.membersRepository,
      currentUserId: widget.currentUserId,
    );
  }

  @override
  void dispose() {
    // Cubit należy do tego widgetu, więc zamykamy go dokładnie raz — razem z nim
    // zwalniane są wszystkie jego zasoby.
    final cubit = _cubit;
    if (cubit != null) unawaited(cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = _cubit;
    if (cubit == null) return const _ProjectSetupUnavailableDialog();
    return ProjectCreationWizard(
      workspaceId: widget.workspaceId,
      cubit: cubit,
      onProjectCreated: widget.onProjectCreated,
      onCreated: widget.onCreated,
    );
  }
}

/// Modal pokazywany, gdy sesja nie ma portu tworzenia projektu.
///
/// Brak portu jest wynikiem konfiguracji transportu, a nie błędem użytkownika,
/// więc komunikat mówi wprost, co jest niedostępne, i nie obiecuje zapisu.
class _ProjectSetupUnavailableDialog extends StatelessWidget {
  const _ProjectSetupUnavailableDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return AlertDialog(
      backgroundColor: colors.surfaceContainerLowest,
      icon: Icon(Symbols.cloud_off, color: colors.onSurfaceVariant),
      title: Text(l10n.projectSetupWizardTitle),
      content: Text(l10n.projectSetupErrorUnavailable),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.projectSetupCancelButton),
        ),
      ],
    );
  }
}
