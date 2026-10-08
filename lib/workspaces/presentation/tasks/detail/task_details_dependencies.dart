import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependency_dialogs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependency_fields.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_labelers.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class DependenciesSection extends StatelessWidget {
  const DependenciesSection({
    required this.dependencies,
    required this.isSaving,
    super.key,
  });

  final List<TaskDependencyDetailsResponse> dependencies;
  final bool isSaving;

  void _openSource(BuildContext context, String taskId) {
    final cubit = context.read<TaskDetailsCubit>();
    final navigation = DevPlannerNavigation.of(context);
    unawaited(
      navigation.goToTask(
        workspaceId: cubit.workspaceId,
        projectId: cubit.projectId,
        taskId: taskId,
        currentLocation: Uri.parse(navigation.currentPath),
        source: TaskDetailOpenSource.subtask,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsDependencies,
    action: IconButton(
      tooltip: context.l10n.taskDetailsAddDependency,
      onPressed: isSaving
          ? null
          : () => DevPlannerModalHost.showDialog<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: const CreateDependencyDialog(),
              ),
            ),
      icon: const Icon(Symbols.add_link_rounded, size: 20),
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: dependencies.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                context.l10n.taskDetailsNoDependencies,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            )
          : Column(
              children: [
                for (final dependency in dependencies)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 14, right: 4),
                    leading: Icon(
                      dependency.type == TaskDependencyType.blocks
                          ? Symbols.block_rounded
                          : Symbols.account_tree,
                      color: dependency.type == TaskDependencyType.blocks
                          ? context.colors.error
                          : context.colors.primary,
                    ),
                    title: Text(dependency.relatedTask.title),
                    subtitle: Text(
                      '${dependency.relatedTask.key} · '
                      '${TaskDependencyTypeLabeler.label(context, dependency.type, incoming: dependency.sourceTaskId != context.read<TaskDetailsCubit>().taskId)} · '
                      '${TaskDependencyLabeler.kind(context, dependency.dependencyKind)}'
                      '${dependency.lagDays == 0 ? '' : ' · ${dependency.lagDays > 0 ? '+' : ''}${dependency.lagDays} d'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (dependency.sourceTaskId !=
                            context.read<TaskDetailsCubit>().taskId)
                          IconButton(
                            tooltip:
                                context.l10n.taskDetailsOpenDependencySource,
                            onPressed: isSaving
                                ? null
                                : () => _openSource(
                                    context,
                                    dependency.sourceTaskId,
                                  ),
                            icon: const Icon(Symbols.open_in_new, size: 18),
                          )
                        else ...[
                          IconButton(
                            tooltip: context.l10n.taskDetailsEditDependency,
                            onPressed: isSaving
                                ? null
                                : () => DevPlannerModalHost.showDialog<void>(
                                    context,
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<TaskDetailsCubit>(),
                                      child: EditDependencyDialog(
                                        dependency: dependency,
                                      ),
                                    ),
                                  ),
                            icon: const Icon(Symbols.edit, size: 18),
                          ),
                          IconButton(
                            tooltip: context.l10n.taskDetailsDeleteDependency,
                            onPressed: isSaving
                                ? null
                                : () => unawaited(
                                    context
                                        .read<TaskDetailsCubit>()
                                        .deleteDependency(
                                          dependency,
                                        ),
                                  ),
                            icon: const Icon(Symbols.close_rounded, size: 18),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
    ),
  );
}
