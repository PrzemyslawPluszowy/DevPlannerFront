import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Przenosi zależności do podrzędnego modala ustawień, poza providerami trasy.
final class TaskLabelsSettingsButton extends StatelessWidget {
  const TaskLabelsSettingsButton({
    required this.settings,
    required this.enabled,
    required this.onPressed,
    this.authSession,
    super.key,
  });
  final ProjectSettingsComposition settings;
  final AuthSessionPort? authSession;
  final bool enabled;
  final Future<void> Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ProjectSettingsComposition>.value(value: settings),
      RepositoryProvider<AuthSessionPort?>.value(value: authSession),
    ],
    child: Builder(
      builder: (settingsContext) => TextButton.icon(
        onPressed: enabled ? () => onPressed(settingsContext) : null,
        icon: const Icon(Symbols.settings_rounded),
        label: Text(context.l10n.tasksManageLabels),
      ),
    ),
  );
}
