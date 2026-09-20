import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_access_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_basics_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_start_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_starter_features_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_summary_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_workflow_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/steps/project_setup_working_style_step.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kreator projektu: jedno wejście dla sidebaru, drzewa i command palette.
///
/// Widget jest wyłącznie warstwą prezentacji: tworzy [ProjectSetupWizardCubit],
/// pokazuje właściwy krok i po sukcesie przekazuje identyfikator projektu
/// z odpowiedzi serwera. Nie dodaje do drzewa żadnego projektu z lokalnym ID —
/// drzewo uzupełnia się odpowiedzią serwera przez [onCreated].
class ProjectCreationWizard extends StatefulWidget {
  /// Tworzy kreator projektu.
  const ProjectCreationWizard({
    required this.workspaceId,
    required this.cubit,
    this.onProjectCreated,
    this.onCreated,
    super.key,
  });

  /// Workspace, w którym powstanie projekt.
  final String workspaceId;

  /// Kontroler kreatora z wstrzykniętymi portami.
  final ProjectSetupWizardCubit cubit;

  /// Powiadomienie z identyfikatorem projektu przydzielonym przez Backend.
  final FutureOr<void> Function(String projectId)? onProjectCreated;

  /// Ogólne powiadomienie o utworzeniu projektu.
  final FutureOr<void> Function()? onCreated;

  @override
  State<ProjectCreationWizard> createState() => _ProjectCreationWizardState();
}

class _ProjectCreationWizardState extends State<ProjectCreationWizard> {
  bool _handledSuccess = false;

  @override
  void initState() {
    super.initState();
    unawaited(widget.cubit.load());
  }

  void _handleSuccess(ProjectSetupWizardState state) {
    if (_handledSuccess || !state.isSucceeded) return;
    final creation = state.creation;
    if (creation == null) return;
    _handledSuccess = true;
    final projectId = creation.project.id;
    // Najpierw identyfikator z serwera, potem ogólne odświeżenie — drzewo może
    // dzięki temu wstawić dokładnie ten projekt, który powstał.
    if (widget.onProjectCreated case final callback?) {
      unawaited(Future.sync(() => callback(projectId)));
    }
    if (widget.onCreated case final callback?) {
      unawaited(Future.sync(callback));
    }
    Navigator.of(context).pop();
    unawaited(
      context.plannerNavigation.go(
        '/workspaces/${widget.workspaceId}/projects/$projectId',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectSetupWizardCubit>.value(
      value: widget.cubit,
      child: BlocListener<ProjectSetupWizardCubit, ProjectSetupWizardState>(
        listenWhen: (previous, next) => next.isSucceeded,
        listener: (context, state) => _handleSuccess(state),
        child: ProjectSetupWizardShell(
          stepBody: (context, state) => switch (state.step) {
            ProjectSetupStep.start => ProjectSetupStartStep(state: state),
            ProjectSetupStep.basics => ProjectSetupBasicsStep(state: state),
            ProjectSetupStep.access => ProjectSetupAccessStep(state: state),
            ProjectSetupStep.workflow => ProjectSetupWorkflowStep(state: state),
            ProjectSetupStep.workingStyle => ProjectSetupWorkingStyleStep(
              state: state,
            ),
            ProjectSetupStep.starterFeatures => ProjectSetupStarterFeaturesStep(
              state: state,
            ),
            ProjectSetupStep.summary => ProjectSetupSummaryStep(state: state),
          },
        ),
      ),
    );
  }
}
