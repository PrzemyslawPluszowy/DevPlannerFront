import 'dart:async';

import 'package:devplanner/shared/presentation/widgets/app_collapsible_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Statyczne podzakładki dostępne w pierwszym szkielecie workspace’u.
enum WorkspaceShellSection { dashboard, projects }

/// Niezmienny stan lokalnej nawigacji shellu.
final class WorkspaceShellNavigationState {
  const WorkspaceShellNavigationState({required this.section});

  final WorkspaceShellSection section;
}

/// Właściciel lokalnego stanu menu i animowanych podzakładek workspace’u.
final class WorkspaceShellNavigationCubit
    extends Cubit<WorkspaceShellNavigationState> {
  WorkspaceShellNavigationCubit({
    required bool initiallyExpanded,
    required this._onPanelChanged,
  }) : super(
         const WorkspaceShellNavigationState(
           section: WorkspaceShellSection.dashboard,
         ),
       ) {
    panelController = AppCollapsibleNavigationController(
      expanded: initiallyExpanded,
      onChanged: (expanded) => unawaited(_onPanelChanged(expanded)),
    );
  }

  final Future<void> Function(bool expanded) _onPanelChanged;
  late final AppCollapsibleNavigationController panelController;

  /// Przełącza podzakładkę bez zmiany trasy i bez dotykania tapety.
  void select(WorkspaceShellSection section) {
    if (state.section == section || isClosed) return;
    emit(WorkspaceShellNavigationState(section: section));
  }

  @override
  Future<void> close() {
    panelController.dispose();
    return super.close();
  }
}
